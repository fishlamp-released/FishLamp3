//
//  FLObjcNamedObjectCollection.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcNamedObjectCollection.h"
#import "FLObjcCodeGeneratorHeaders.h"

@implementation FLObjcNamedObjectCollection

- (id) init {	
	self = [super init];
	if(self) {
        _objects = [FLCarefulDictionary carefulDictionary:^id(id key) {
            FLAssertWithComment([key isKindOfClass:[NSString class]], @"expecting the key to be a string");
            return [key lowercaseString]; 
        }];
	}
	return self;
}

+ (id) objcNamedObjectCollection {
    return FLAutorelease([[[self class] alloc] init]);
}

- (NSString*) keyFromObjcName:(FLObjcName*) name {
    return name.identifier;
}

- (void) addObject:(id) object forObjcName:(FLObjcName*) name {
    id key = [self keyFromObjcName:name];
    [_objects addObject:object forKey:key];
    [_objects addAlias:name.generatedName forKey:key];
}

- (void) replaceObject:(id) object forObjcName:(FLObjcName*) name {
    [_objects replaceObject:object forKey:[self keyFromObjcName:name]];
}

- (id) objectForClass:(Class) aClass {
    return [_objects objectForKey:NSStringFromClass(aClass)];
}

- (BOOL) hasObjcName:(FLObjcName*) name {
    return [_objects hasKey:[self keyFromObjcName:name]];
}

- (id) objectForObjcName:(FLObjcName*) name {
    return [_objects objectForKey:[self keyFromObjcName:name]];
}

- (NSEnumerator *)keyEnumerator {
    return [_objects keyEnumerator];
}

- (NSEnumerator *)objectEnumerator {
    return [_objects objectEnumerator];
}

- (NSArray *)allKeys {
    return [_objects allKeys];
}

- (NSArray *)allValues {
    return [_objects allValues];
}

- (void) addAlias:(NSString*) alias forObjcName:(FLObjcName*) name {
    [_objects addAlias:alias forKey:[self keyFromObjcName:name]];
}

- (id) objectForKey:(NSString*) key {
    return [_objects objectForKey:key];
}

- (BOOL) hasKey:(NSString*) key {
    return [_objects hasKey:key];
}

- (void) removeObjectForObjcName:(FLObjcName*) name {
    [_objects removeObjectWithKey:[self keyFromObjcName:name]];
}

- (NSString*) description {
    return [_objects description];
}

@end
