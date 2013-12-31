//
//  FLJsonObjectBuilder.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/26/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLJsonObjectBuilder.h"
#import "FLBase64Encoding.h"
#import "FLStringToObjectConversionManager.h"
#import "FLPropertyDescriber.h"
#import "FLObjectDescriber.h"
#import "FLJsonDataEncoder.h"

@interface FLJsonObjectBuilder ()
- (id) objectFromJSON:(id) jsonObject withTypeDesc:(FLPropertyDescriber*) type;
@end

@implementation NSString (FLJsonObjectBuilder)

- (id) objectWithJsonObjectBuilder:(FLJsonObjectBuilder*) builder typeDesc:(FLPropertyDescriber*) typeDesc {
    FLAssertNotNil(builder);
    FLAssertNotNil(typeDesc);
    
    
    NSString* forTypeName = typeDesc.stringEncodingKeyForRepresentedData;
    if(forTypeName) {
        FLAssertNotNil(builder.decoder);
        return [builder.decoder objectFromString:self forTypeName:forTypeName];
    }
    else {
        FLLog(@"Json property %@ has no encoder key", typeDesc.propertyName);
    }

    return nil;
}

@end

@implementation NSNumber (FLJsonObjectBuilder)
- (id) objectWithJsonObjectBuilder:(FLJsonObjectBuilder*) builder typeDesc:(FLPropertyDescriber*) typeDesc {
    return self;
}
@end

@implementation NSDictionary (FLJsonObjectBuilder)

- (id) objectWithJsonObjectBuilder:(FLJsonObjectBuilder*) builder typeDesc:(FLPropertyDescriber*) typeDesc {
    FLAssertNotNil(builder);
    FLAssertNotNil(typeDesc);

//    if(!FLStringsAreEqual(jsonDictionary.jsonObjectName, typeDesc.objectName)) {
//        id subElement = [jsonDictionary jsonObjectForElementName:typeDesc.objectName];
//
//        if(!subElement) {
//            FLThrowErrorCodeWithComment(NSCocoaErrorDomain, NSFileNoSuchFileError, @"XmlObjectBuilder: \"%@\" not found in \"%@\"", typeDesc.typeName, jsonDictionary.jsonObjectName);
//        }
//        
//        jsonDictionary = subElement;
//    }
//
//    FLAssertWithComment(FLStringsAreEqual(jsonDictionary.key, typeDesc.typeName), @"trying to build wrong object jsonDictionary name: \"%@\", object typeDesc name: \"%@\"", jsonDictionary.key, typeDesc.typeName);

//    Class objectClass = typeDesc.propertyClass;
//    if(!objectClass) {
//        FLLog(@"Object description has nil object class: %@", [typeDesc description]);
//        return nil;
//    }
    
//    if(![objectClass isModelObject]) {
//        return nil;
//    }
//    
//    typeDesc = [objectClass objectDescriber];

    id rootObject = [typeDesc createRepresentedObject];
    FLAssertNotNil(rootObject);
    
//    FLAutorelease([[objectClass alloc] init]);
//    FLAssertNotNilWithComment(rootObject, @"unable to create object of type: %@", NSStringFromClass(objectClass));
    
    for(id key in self) {
        id value = [self objectForKey:key];

        FLPropertyDescriber* subType = [typeDesc containedTypeForName:key];
        if(!subType) {
            FLLog(@"object builder skipped missing typeDesc named: %@", key);
            continue;
        }
        
        id object = [value objectWithJsonObjectBuilder:builder typeDesc:subType];
        FLAssertNotNil(object);
        [rootObject setValue:object forKey:key];
    }
    return rootObject;
}

// I'm not sure this makes any sense at all... ????
- (NSArray*) objectArrayWithJsonObjectBuilder:(FLJsonObjectBuilder*) builder withTypeDescs:(NSArray*) arrayOfObjectDescribers {

    FLAssertionFailedWithComment(@"array from dictinary for JSON object makes no sense");
    
    return nil;
}

@end

@implementation NSArray (FLJsonObjectBuilder)

- (NSArray*) objectArrayWithJsonObjectBuilder:(FLJsonObjectBuilder*) builder withTypeDescs:(NSArray*) arrayOfObjectDescribers {

// TODO: handle hetrogenous arrays
    FLPropertyDescriber* typeDesc = [arrayOfObjectDescribers objectAtIndex:0];

    NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:self.count];
    for(id child in self) {	
    
// TODO: we need a way of choosing the type. We'll have to add a way to associate a property like "type" with the type??            
                    		
        [newArray addObject:[builder objectFromJSON:child withTypeDesc:typeDesc]];
    }

    return newArray;
}

- (id) objectWithJsonObjectBuilder:(FLJsonObjectBuilder*) builder typeDesc:(FLPropertyDescriber*) typeDesc {

    NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:self.count];
    for(id child in self) {			
        [newArray addObject:[builder objectFromJSON:child withTypeDesc:typeDesc]];
    }

    return newArray;

}


@end


@implementation FLJsonObjectBuilder

@synthesize decoder = _decoder;

- (id) init {
    return [self initWithDataDecoder:[FLJsonDataEncoder instance]];
}

- (id) initWithDataDecoder:(FLStringToObjectConversionManager*) decoder {
    self = [super init];
    if(self) {
        _decoder = FLRetain(decoder);
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_decoder release];
    [super dealloc];
}
#endif

+ (id) jsonObjectBuilder:(FLStringToObjectConversionManager*) decoder {
    return FLAutorelease([[[self class] alloc] initWithDataDecoder:decoder]);
}

+ (id) jsonObjectBuilder {
    return FLAutorelease([[[self class] alloc] init]);
}

- (NSArray*) arrayOfObjectsFromJSON:(id) jsonObject withTypeDescs:(NSArray*) arrayOfObjectDescriber {
    return [jsonObject objectArrayWithJsonObjectBuilder:self withTypeDescs: arrayOfObjectDescriber];
}

- (NSArray*) arrayOfObjectsFromJSON:(id) json withTypeDesc:(FLPropertyDescriber*) type {
    return [self arrayOfObjectsFromJSON:json withTypeDescs:[NSArray arrayWithObject:type]];
}

- (id) objectFromJSON:(id) jsonObject withTypeDesc:(FLPropertyDescriber*) type {
    return [jsonObject objectWithJsonObjectBuilder:self typeDesc:type];
}

- (NSArray*) arrayOfObjectsFromJSON:(id) json expectedRootObjectClass:(Class) aClass {
    return [self arrayOfObjectsFromJSON:json withTypeDescs:[NSArray arrayWithObject:[aClass objectDescriber]]];
}

- (id) objectFromJSON:(id) parsedJson expectedRootObjectClass:(Class) type {
    return [parsedJson objectWithJsonObjectBuilder:self typeDesc:nil]; // TODO fix parmam
}

@end




