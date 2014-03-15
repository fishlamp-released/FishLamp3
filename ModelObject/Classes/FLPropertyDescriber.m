//
//  FLPropertyDescriber.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/22/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPropertyDescriber.h"
#import "FLObjectDescriber.h"
#import "FLPropertyAttributes.h"
#import "FLModelObject.h"

@implementation NSObject (FLXmlBuilder)
+ (id) propertyDescriber {
    return [FLObjectPropertyDescriber propertyDescriber];
}
+ (Class) propertyDescriberClass {
    return [self isModelObject] ?   [FLModelObjectPropertyDescriber class] :
                                    [FLObjectPropertyDescriber class];
}
@end

@implementation NSArray (FLXmlBuilder)
+ (id) propertyDescriber {
    return [FLArrayPropertyDescriber propertyDescriber];
}
+ (Class) propertyDescriberClass {
    return [FLArrayPropertyDescriber class];
}
@end

#define LazySelectorGetter(name, ivar, function) \
- (SEL) name { \
    if(!ivar) { \
        @synchronized(self) { \
            if(!ivar) { \
                ivar = function(_attributes); \
            } \
        } \
    } \
    return ivar; \
}

@interface FLPropertyDescriber ()

//@property (readwrite, strong) NSString* propertyKey;
@property (readonly, strong) FLObjectDescriber* representedObjectDescriber;
@property (readwrite, strong) NSArray* containedTypes;

+ (id) propertyDescriberWithProperty_t:(objc_property_t) property_t;
- (void) addContainedProperty:(NSString*) name withClass:(Class) aClass; 

@end


@implementation FLPropertyDescriber
@synthesize propertyName = _propertyName;
@synthesize representedObjectDescriber = _representedObjectDescriber;
@synthesize containedTypes = _containedTypes;
@synthesize propertyKey = _propertyKey;
@synthesize serializationKey = _serializationKey;
@synthesize attributes = _attributes;

FLSynthesizeLazyGetterWithBlock(structName, NSString*, _structName, ^{
        return FLPropertyAttributesGetStructName(_attributes);
    }
);

FLSynthesizeLazyGetterWithBlock(unionName, NSString*, _unionName, ^{
        return FLPropertyAttributesGetUnionName(_attributes);
    }
);

FLSynthesizeLazyGetterWithBlock(ivarName, NSString*, _ivarName, ^{
        return FLPropertyAttributesGetIvarName(_attributes);
    }
);

LazySelectorGetter(customGetter, _customGetter, FLPropertyAttributesGetCustomGetter)
LazySelectorGetter(customSetter, _customSetter, FLPropertyAttributesGetCustomSetter)
LazySelectorGetter(selector, _selector, FLPropertyAttributesGetSelector)

- (id) initWithPropertyName:(NSString*) name
            objectDescriber:(FLObjectDescriber*) objectDescriber {
    self = [super init];
    if(self) {
        _propertyName = FLRetain(name);
        _serializationKey = FLRetain(name);
        _propertyKey = FLRetain([name lowercaseString]);
        _representedObjectDescriber = FLRetain(objectDescriber);
    }

    return self;
}

- (id) initWithPropertyName:(NSString*) name
            objectDescriber:(FLObjectDescriber*) objectDescriber
                 attributes:(FLPropertyAttributes_t) attributes {

    self = [self initWithPropertyName:name objectDescriber:objectDescriber];
    if(self) {
        _attributes = attributes;
    }

    return self;
}

+ (id) propertyDescriber {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) propertyDescriber:(NSString*) name
            objectDescriber:(FLObjectDescriber*) objectDescriber
            attributes:(FLPropertyAttributes_t) attributes {
    return FLAutorelease([[[self class] alloc] initWithPropertyName:name
                                                    objectDescriber:objectDescriber
                                                         attributes:attributes]);
}

+ (id) propertyDescriber:(NSString*) name propertyClass:(Class) aClass {

    return FLAutorelease([[[aClass propertyDescriberClass] alloc] initWithPropertyName:name
                                                                       objectDescriber:[aClass objectDescriber]]);
}

+ (id) propertyDescriber:(NSString*) name class:(Class) aClass {
    return [FLPropertyDescriber propertyDescriber:name propertyClass:aClass];
}

+ (id) propertyDescriberWithProperty_t:(objc_property_t) property_t {

    FLPropertyAttributes_t attributes = FLPropertyAttributesParse(property_t);

    NSString* propertyName = FLPropertyAttributesGetPropertyName(attributes);

    FLAssertStringIsNotEmpty(propertyName);

    if(attributes.is_object) {

        NSString* className = FLPropertyAttributesGetClassName(attributes);

        Class objectClass = nil;
        if(className) {
            objectClass = NSClassFromString(className);
        }
        else {
            objectClass = [FLAbstractObjectType class];
        }

        FLAssertNotNil(objectClass,
                                  @"Can't find class for: \"%@\"",
                                  className );

        return [[objectClass propertyDescriberClass] propertyDescriber:propertyName
                                                       objectDescriber:[objectClass objectDescriber]
                                                            attributes:attributes];

    }
    else {
        if(attributes.is_bool_number) {
            return [FLBoolNumberPropertyDescriber propertyDescriber:propertyName objectDescriber:nil attributes:attributes];
        }
        else if(attributes.is_number) {
            return [FLNumberPropertyDescriber propertyDescriber:propertyName objectDescriber:nil attributes:attributes];
        }
    }

    FLAssertFailed(@"No property describer created for property: \"%@\"", propertyName );

    return nil;
}

- (BOOL) representsIvar {
    return _attributes.ivar.length > 0;
}

- (BOOL) representsObject {
    return NO;
}

- (BOOL) representsModelObject {
    return NO;
}

- (BOOL) representsArray {
    return NO;
}

- (id) createRepresentedObject {
    return nil; 
}

- (Class) representedObjectClass {
    return _representedObjectDescriber.objectClass;
}   

- (FLPropertyDescriber*) containedTypeForName:(NSString*) name {
// TODO: figure out a better way to make this thread safe
    @synchronized(self) {
        name = [name lowercaseString];
        for(FLPropertyDescriber* property in _containedTypes) {
            if(FLStringsAreEqual(property.propertyKey, name)) {
                return property;
            }
        }
    }
    return nil;
}

- (NSUInteger) containedTypesCount {
// TODO: figure out a better way to make this thread safe
    @synchronized(self) {
        return _containedTypes.count;
    }
}

- (FLPropertyDescriber*) containedTypeForIndex:(NSUInteger) idx {
// TODO: figure out a better way to make this thread safe
    @synchronized(self) {
        return [_containedTypes objectAtIndex:idx];
    }
}
- (FLPropertyDescriber*) containedTypeForClass:(Class) aClass {
 // TODO: figure out a better way to make this thread safe
   @synchronized(self) {
        for(FLPropertyDescriber* subType in _containedTypes) {
            if([aClass isKindOfClass:[subType representedObjectClass]]) {
                return subType;
            }
        }
    }
    return nil;
}

- (BOOL) representsClass:(Class) aClass {
    return self.representedObjectClass == aClass;
}

- (void) setContainedTypes:(NSArray*) types {
// TODO: figure out a better way to make this thread safe
    @synchronized(self) {
        FLSetObjectWithCopy(_containedTypes, types);
    }
}

// TODO: figure out a better way to make this thread safe
- (NSArray*) containedTypes {
    @synchronized(self) {
        return FLCopyWithAutorelease(_containedTypes);
    }
}

- (void) addContainedProperty:(FLPropertyDescriber*) propertyDescriber {
    if(!_containedTypes) {
        _containedTypes = [[NSMutableArray alloc] init];
    }

    [_containedTypes addObject:propertyDescriber];
}

- (void) addContainedProperty:(NSString*) name withClass:(Class) aClass {
    [self addContainedProperty:[FLPropertyDescriber propertyDescriber:name class:aClass]];
}

- (NSString*) description {
    
    FLPrettyString* contained = nil;
    
    for(FLPropertyDescriber* describer in _containedTypes) {
        if(!contained) {
            contained = [FLPrettyString prettyString];
            [contained indent:nil];
        }
    
        [contained appendBlankLine];
        [contained appendFormat:@"%@", [describer description]];
    }
    
    return [NSString stringWithFormat:@"%@ %@: %@ %@", [super description], self.propertyName, NSStringFromClass(self.representedObjectClass), contained ? [contained string] : @""];
}

#if FL_MRC
- (void) dealloc {
    [_structName release];
    [_ivarName release];
    [_unionName release];
    [_serializationKey release];
    [_propertyKey release];
    [_representedObjectDescriber release];
	[_propertyName release];
    [_containedTypes release];
    [super dealloc];
}
#endif

- (NSString*) stringEncodingKeyForRepresentedData {
    return nil;
}
@end


@implementation FLObjectPropertyDescriber : FLPropertyDescriber

- (BOOL) representsObject {
    return YES;
}

- (id) createRepresentedObject {
    return FLAutorelease([[[self representedObjectClass] alloc] init]);
}

- (NSString*) stringEncodingKeyForRepresentedData {
    return [[self representedObjectClass] typeNameForStringSerialization];
}

@end

@implementation FLModelObjectPropertyDescriber : FLObjectPropertyDescriber

- (BOOL) representsModelObject {
    return YES;
}

@end

@implementation FLArrayPropertyDescriber : FLObjectPropertyDescriber

- (BOOL) representsModelObject {
    return NO;
}

- (BOOL) representsArray {
    return YES;
}

- (id) createRepresentedObject {
    return [NSMutableArray array];
}

@end

@implementation FLValuePropertyDescriber 

- (BOOL) representsObject {
    return NO;
}

- (BOOL) representsModelObject {
    return NO;
}

- (BOOL) representsArray {
    return NO;
}

- (id) createRepresentedObject {
    return nil;
}

- (NSString*) stringEncodingKeyForRepresentedData {
    return nil;
}

@end

@implementation FLNumberPropertyDescriber 

- (NSString*) stringEncodingKeyForRepresentedData {
    return [NSNumber typeNameForStringSerialization];
}

@end

@implementation FLBoolNumberPropertyDescriber 


- (NSString*) stringEncodingKeyForRepresentedData {
    return [FLBoolStringToNSNumberObjectConverter typeNameForStringSerialization];
}

@end
