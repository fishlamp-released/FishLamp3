//
//  FLObjectDescriber.m
//  PackMule
//
//  Created by Mike Fullerton on 6/30/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLObjectDescriber.h"

#import "FLObjcRuntime.h"
#import "FLModelObject.h"

typedef void (^FLPropertyVisitor)(NSString* propertyName, id value, BOOL* stop);
typedef void (^FLPropertyDescriberVisitor)(FLPropertyDescriber* propertyDescriber, BOOL* stop);
typedef void (^FLPropertyDescriberVisitorRecursive)(FLObjectDescriber* object, FLPropertyDescriber* propertyDescriber, BOOL* stop);

//#import "FLTrace.h"

@interface FLPropertyDescriber (Internal)
@property (readwrite, strong) FLObjectDescriber* representedObjectDescriber;
@property (readwrite, copy) NSArray* containedTypes;

- (id) initWithProperty_t:(objc_property_t) property_t;
+ (id) propertyDescriberWithProperty_t:(objc_property_t) property_t;

- (void) addContainedProperty:(FLPropertyDescriber*) propertyDescriber;
@end


@interface FLObjectDescriber ()
- (void) addPropertiesForClass:(Class) aClass;
- (id) initWithClass:(Class) aClass;
- (void) describeSelfForObjectDescriber;

// type registration
// NOTE THE METHODS BELOW ARE NOT THREAD SAFE
- (void) addProperty:(FLPropertyDescriber*) subtype;
- (void) addPropertyArrayTypes:(NSArray*) arrayTypes forPropertyName:(NSString*) propertyName;

// deprected
- (void) addPropertyWithName:(NSString*) name withArrayTypes:(NSArray*) types;
- (void) addArrayProperty:(NSString*) name withArrayTypes:(NSArray*) types;

@property (readwrite, assign) Class objectClass;
@end

@implementation FLObjectDescriber

static NSMutableDictionary* s_registry = nil;

@synthesize objectClass = _objectClass;
@synthesize properties = _properties;

+ (void) initialize {
    if(!s_registry) {
        s_registry = [[NSMutableDictionary alloc] init];
    }
}

- (id) init {
    return [self initWithClass:nil];
}

- (id) initWithClass:(Class) aClass properties:(NSDictionary*) properties {
    FLAssertNotNil(aClass);
	self = [super init];
	if(self) {
        _objectClass = aClass;
        _properties = [properties mutableCopy];
        _storageRepPred = 0;
	}
	return self;
}

- (id) initWithClass:(Class) aClass {
    return [self initWithClass:aClass properties:nil];
}

+ (id) objectDescriber:(Class) aClass {
    FLObjectDescriber* describer = nil;

    @synchronized(s_registry) {
        describer = [s_registry objectForKey:NSStringFromClass(aClass)];

        if(!describer) {
            describer = FLAutorelease([[[self class] alloc] initWithClass:aClass]);
            [s_registry setObject:describer forKey:NSStringFromClass(aClass)];
            [describer describeSelfForObjectDescriber];
            [aClass didRegisterObjectDescriber:describer];
        }
    }
    
    return describer;
}

+ (id) objectDescriber {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_storageRepresentation release];
    [_properties release];
    [super dealloc];
}
#endif

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_properties countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSEnumerator*) propertyEnumerator {
    return [_properties objectEnumerator];
}

- (FLObjectDescriber*) propertyForName:(NSString*) propertyName {
    @synchronized(self) {
        return [_properties objectForKey:[propertyName lowercaseString]];
    }
}

- (FLPropertyDescriber*) propertyForContainerTypeByName:(NSString*) name {
    @synchronized(self) {
        
        FLPropertyDescriber* outDescriber = nil;
        for(FLPropertyDescriber* describer in [_properties objectEnumerator]) {
            FLPropertyDescriber* contained = [describer containedTypeForName:name];
            if(contained) {
                if(outDescriber) {
                    FLLog(@"duplicated contained type for %@", name);
                }
                outDescriber = describer;
            }
        }
    
        return outDescriber;
    }
}

- (NSDictionary*) properties {
    @synchronized(self) {
        return FLCopyWithAutorelease(_properties);
    }
}

- (NSUInteger) propertyCount {
    @synchronized(self) {
        return [_properties count];
    }
}

- (void) addProperty:(FLPropertyDescriber*) property {
    FLAssertNotNil(property);
    
    if(!_properties) {
        _properties = [[NSMutableDictionary alloc] init];
    }
   
    FLPropertyDescriber* existing = [_properties objectForKey:property.propertyKey];
    if(existing) {
        FLTrace(@"replacing property %@ to %@", property.propertyName, NSStringFromClass(self.objectClass));
        existing.representedObjectDescriber = property.representedObjectDescriber;
        existing.containedTypes = property.containedTypes;
    } 
    else {
        FLTrace(@"added property %@ to %@", property.propertyName, NSStringFromClass(self.objectClass));
        [_properties setObject:property forKey:property.propertyKey];
    }
}

- (NSString*) description {
    
    FLPrettyString* contained = [FLPrettyString prettyString];
    [contained indent:nil];
    
    for(FLPropertyDescriber* describer in [_properties objectEnumerator]) {
        [contained appendBlankLine];
        [contained appendFormat:@"%@", [describer description]];
    }
    
    return [NSString stringWithFormat:@"%@ %@", NSStringFromClass(self.objectClass), contained.string];
}

- (BOOL) shouldAddProperty:(FLPropertyDescriber*) property {
    return property.representsIvar;
}

- (void) addPropertiesForClass:(Class) aClass {
// do all the properties
    unsigned int propertyCount = 0;
    objc_property_t* propertys = class_copyPropertyList(aClass, &propertyCount);

    FLTrace(@"found %d properties for %@", propertyCount, NSStringFromClass(aClass));

    for(unsigned int i = 0; i < propertyCount; i++) {
    
        FLPropertyDescriber* propertyDescriber = [FLPropertyDescriber propertyDescriberWithProperty_t:propertys[i]];
        if(propertyDescriber && [self shouldAddProperty:propertyDescriber]) {
            [self addProperty:propertyDescriber];
        }
    }

    free(propertys);
}

- (void) addPropertiesForParentClasses:(Class) aClass {
    if([aClass isModelObject]) {
        if(aClass && [aClass respondsToSelector:@selector(objectDescriber)]) {
            FLObjectDescriber* describer = [aClass objectDescriber];
            for(FLPropertyDescriber* property in [describer.properties objectEnumerator]) {
                [self addProperty:property];
            }
        }
    }
}

- (void) describeSelfForObjectDescriber {
    Class aClass = [self objectClass];
    BOOL isModelObject = [aClass isModelObject];
    if(isModelObject) {
    // do parents first, because we can override them in subclass
        [self addPropertiesForParentClasses:[aClass superclass]];

    // add our discovered properties
        [self addPropertiesForClass:aClass];
    }
}


- (id) copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithClass:_objectClass properties:_properties];
}



- (void) addPropertyArrayTypes:(NSArray*) types forPropertyName:(NSString*) name {

    FLPropertyDescriber* property = [self.properties objectForKey:[name lowercaseString]];
    FLAssertNotNil(property);
   
    if(![property representsClass:[NSMutableArray class]] ) {
        property.representedObjectDescriber  = [FLObjectDescriber objectDescriber:[NSMutableArray class]];
    }
    FLAssertNil(property.containedTypes);
    FLAssertNotNil(types);

    property.containedTypes = types;    

} 

- (void) addPropertyWithName:(NSString*) name withArrayTypes:(NSArray*) types {
    [self addPropertyArrayTypes:types forPropertyName:name];
}

- (void) addArrayProperty:(NSString*) name withArrayTypes:(NSArray*) types {
    [self addPropertyArrayTypes:types forPropertyName:name];
}

- (void) addContainerType:(FLPropertyDescriber*) describer forContainerProperty:(NSString*) name {
    FLPropertyDescriber* prop = [self propertyForName:name];
    FLAssertNotNil(prop);
    if(prop) {
        [prop addContainedProperty:describer];
    }
}

- (BOOL) visitRecursively:(FLPropertyDescriberVisitorRecursive) visitor{
        
    BOOL stop = NO;
    
    for(FLPropertyDescriber* prop in [self.properties objectEnumerator]) {
    
        visitor(self, prop, &stop);
        
        if(stop) {
            return YES;
        }
        
        if([prop representsModelObject]) {
            stop = [[[prop representedObjectClass] objectDescriber] visitRecursively:visitor];
        }
        else if([prop representsArray]) {
            for(FLPropertyDescriber* containedType in prop.containedTypes) {
                if([containedType representsModelObject]) {
                    stop = [[[containedType representedObjectClass] objectDescriber] visitRecursively:visitor];
                }
            }
        }
        
        if(stop) {
            return YES;
        }
    }
    
    return NO;
}
@end

@implementation FLModelObjectDescriber
@end


@implementation FLAbstractObjectType
@end

@implementation NSObject (FLObjectDescriber)
+ (void) didRegisterObjectDescriber:(FLObjectDescriber*) describer {
}

+ (Class) objectDescriberClass {
    return [self isModelObject] ? [FLModelObjectDescriber class] : [FLObjectDescriber class];
}
+ (FLObjectDescriber*) objectDescriber { 
    return [[self objectDescriberClass] objectDescriber:[self class]];
}
- (FLObjectDescriber*) objectDescriber {
    return [[self class] objectDescriber];
}

//- (void) visitEachProperty:(FLPropertyVisitor) visitor;
//- (void) visitEachPropertyDescriber:(FLPropertyDescriberVisitor) visitor;


- (void) visitEachProperty:(FLPropertyVisitor) visitor {
    if ([[self class] isModelObject]) {
        BOOL stop = NO;
        FLObjectDescriber* describer = [self objectDescriber];
        for(FLPropertyDescriber* property in [describer.properties objectEnumerator]) {
            visitor(property.propertyName, [self valueForKey:property.propertyName], &stop);
            
            if(stop) {
                break;
            }
        }
    
    }
}

- (void) visitEachPropertyDescriber:(FLPropertyDescriberVisitor) visitor {
    if ([[self class] isModelObject]) {
        BOOL stop = NO;
        FLObjectDescriber* describer = [self objectDescriber];

        for(FLPropertyDescriber* prop in [describer.properties objectEnumerator]) {
            visitor(prop, &stop);
            
            if(stop) {
                break;
            }
        }
    
    }
}

- (void) visitEachPropertyRecursively:(FLPropertyDescriberVisitorRecursive) visitor{
    if ([[self class] isModelObject]) {
        [[self objectDescriber] visitRecursively:visitor];
    }
}

- (Class) propertyClassForName:(NSString*) name {
    FLPropertyDescriber* objectDescriber = [[self objectDescriber] propertyForName:name];
    return [objectDescriber representedObjectClass];
}

- (id) lazyValueForKey:(NSString*) propertyName {
    if([[self class] isModelObject] &&
        [self valueForKey:propertyName] == nil) {
        Class aClass = [self propertyClassForName:propertyName];
        if(aClass) {
            id object = FLAutorelease([[aClass alloc] init]);
            if(object) {
                [object setValue:object forKey:propertyName];
            }   
            return object;
        }
        
    }

    return nil;

}

@end

/*
@implementation FLLegacyObjectDescriber

+ (id) registerClass:(Class) aClass {
    FLAssertFailedWithComment(@"no longer supported");
    return nil;
}

- (id) initWithClass:(Class) aClass {
    return [super initWithClass:aClass];
}

- (void) addPropertyWithName:(NSString*) name withClass:(Class) objectClass {
    FLPropertyDescriber* property = [self.properties objectForKey:name];
    FLAssertNotNil(property);
    
    if(![property representsClass:objectClass]) {
    
//        FLTrace(@"replaced property class %@ with %@", NSStringFromClass(property.propertyClass), NSStringFromClass(objectClass));
        property.representedObjectDescriber = [FLObjectDescriber objectDescriber:objectClass];
    }
}

- (void) addPropertyWithName:(NSString*) name withArrayTypes:(NSArray*) types {
    FLPropertyDescriber* property = [self.properties objectForKey:name];
    FLAssertNotNil(property);
   
    if(![property representsClass:[NSMutableArray class]] ) {
        property.representedObjectDescriber  = [FLObjectDescriber objectDescriber:[NSMutableArray class]];
    }
    FLAssertNil(property.containedTypes);
    FLAssertNotNil(types);

    property.containedTypes = types;    

}        

- (BOOL) shouldAddProperty:(FLPropertyDescriber*) property {
    return property.representsObject && property.representsIvar;
}

+ (id) createDescriberForClass:(Class) aClass {
    return FLAutorelease([[FLLegacyObjectDescriber alloc] initWithClass:aClass]);
}



@end
*/
