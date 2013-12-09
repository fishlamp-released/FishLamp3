//
//  FLPropertyDescriber.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/22/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPropertyAttributes.h"
#import "FLStringToObjectConverting.h"
#import "FLDatabase.h"

@class FLObjectDescriber;

@interface FLPropertyDescriber : NSObject {
@private
    NSString* _propertyName;
    NSString* _propertyKey;
    NSString* _serializationKey;
    FLObjectDescriber* _representedObjectDescriber;
    NSMutableArray* _containedTypes;
    
    FLPropertyAttributes_t _attributes;
    NSString* _structName;
    NSString* _ivarName;
    NSString* _unionName;
    SEL _customGetter;
    SEL _customSetter;
    SEL _selector;
}

// property attributes
@property (readonly, strong) NSString* propertyName;
@property (readonly, strong) NSString* propertyKey; // lowercase version of name

// represented object 
@property (readonly, assign) Class representedObjectClass;
@property (readonly, assign) BOOL representsObject;
@property (readonly, assign) BOOL representsModelObject;
@property (readonly, assign) BOOL representsArray;
//@property (readonly, strong) id<FLStringToObjectConverter> objectEncoder;
- (BOOL) representsClass:(Class) aClass;
- (id) createRepresentedObject;

// contained types
@property (readonly, strong) NSArray* containedTypes;
@property (readonly, assign) NSUInteger containedTypesCount;
- (FLPropertyDescriber*) containedTypeForIndex:(NSUInteger) idx;
- (FLPropertyDescriber*) containedTypeForClass:(Class) aClass;
- (FLPropertyDescriber*) containedTypeForName:(NSString*) name;

+ (id) propertyDescriber:(NSString*) identifier 
           propertyClass:(Class) aClass;


- (NSString*) stringEncodingKeyForRepresentedData;

@property (readwrite, strong) NSString* serializationKey;
@property (readonly, assign) FLPropertyAttributes_t attributes;

@end

@interface FLPropertyDescriber (RunTimeInfo)
- (NSString*) structName;
- (NSString*) ivarName;
- (NSString*) unionName;
- (SEL) customGetter;
- (SEL) customSetter;
- (SEL) selector;
- (BOOL) representsIvar;
@end

@interface FLPropertyDescriber (Database)
- (FLDatabaseType) databaseColumnType;          
@end


@interface FLPropertyDescriber (Deprecated)
+ (id) propertyDescriber:(NSString*) name class:(Class) aClass;
@end

@interface FLValuePropertyDescriber : FLPropertyDescriber
@end

@interface FLNumberPropertyDescriber : FLValuePropertyDescriber 
@end

@interface FLBoolNumberPropertyDescriber : FLValuePropertyDescriber
@end


@interface FLObjectPropertyDescriber : FLPropertyDescriber
@end

@interface FLModelObjectPropertyDescriber : FLObjectPropertyDescriber
@end

@interface FLArrayPropertyDescriber : FLObjectPropertyDescriber
@end