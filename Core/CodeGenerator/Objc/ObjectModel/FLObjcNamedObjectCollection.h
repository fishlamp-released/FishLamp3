//
//  FLObjcNamedObjectCollection.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FLCarefulDictionary.h"

@class FLObjcName;

@interface FLObjcNamedObjectCollection : NSObject {
@private
    FLCarefulDictionary* _objects;
}

+ (id) objcNamedObjectCollection;

- (NSString*) keyFromObjcName:(FLObjcName*) name;

- (void) addObject:(id) object forObjcName:(FLObjcName*) key;
- (void) addAlias:(NSString*) alias forObjcName:(FLObjcName*) key;
- (void) replaceObject:(id) object forObjcName:(FLObjcName*) key;
- (void) removeObjectForObjcName:(FLObjcName*) key;

- (BOOL) hasObjcName:(FLObjcName*) name;
- (BOOL) hasKey:(NSString*) key;

- (id) objectForClass:(Class) aClass;
- (id) objectForObjcName:(FLObjcName*) name;
- (id) objectForKey:(NSString*) key;

- (NSEnumerator *)keyEnumerator;
- (NSEnumerator *)objectEnumerator;
- (NSArray *)allKeys;
- (NSArray *)allValues;

@end
