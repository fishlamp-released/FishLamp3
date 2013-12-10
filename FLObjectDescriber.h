

//
//  FLObjectDescriber.h
//  PackMule
//
//  Created by Mike Fullerton on 6/30/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLPropertyDescriber.h"

@interface FLObjectDescriber : NSObject<NSCopying, NSFastEnumeration> {
@private
    Class _objectClass;
    NSMutableDictionary* _properties;
    dispatch_once_t _storageRepPred;
    id _storageRepresentation;
}

@property (readonly, assign) Class objectClass;
@property (readonly, assign) NSUInteger propertyCount;
@property (readonly, copy) NSDictionary* properties;

@property (readonly, strong) id storageRepresentation;

+ (id) objectDescriber:(Class) aClass;

// helpers
- (FLPropertyDescriber*) propertyForName:(NSString*) identifier;
- (FLPropertyDescriber*) propertyForContainerTypeByName:(NSString*) identifier;

- (NSEnumerator*) propertyEnumerator;

@end

@interface FLObjectDescriber (Building)
- (void) addContainerType:(FLPropertyDescriber*) describer forContainerProperty:(NSString*) name;
@end


@interface FLModelObjectDescriber : FLObjectDescriber
@end

@interface FLAbstractObjectType : NSObject
@end

@interface NSObject (FLObjectDescriber)
+ (void) didRegisterObjectDescriber:(FLObjectDescriber*) describer;

+ (FLObjectDescriber*) objectDescriber;
- (FLObjectDescriber*) objectDescriber;

+ (Class) objectDescriberClass;
@end
