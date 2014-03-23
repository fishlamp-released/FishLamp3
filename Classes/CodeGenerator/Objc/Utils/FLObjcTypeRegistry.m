//
//  FLObjcTypeRegistry.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/13/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcTypeRegistry.h"
#import "FLObjcCodeGeneratorHeaders.h"

@interface FLObjcTypeRegistry ()
@end

@implementation FLObjcTypeRegistry

+ (id) objcTypeRegistry {
    return FLAutorelease([[[self class] alloc] init]);
}

- (BOOL) hasType:(FLObjcType*) type {
    return [self hasObjcName:type.typeName];
}

- (void) addType:(FLObjcType*) type {
    [self addObject:type forObjcName:type.typeName];
}

- (void) replaceType:(FLObjcType*) type {
    [self replaceObject:type forObjcName:type.typeName];
}

- (id) typeForClass:(Class) aClass {
    return [self objectForClass:aClass];
}

- (id) typeForKey:(NSString*) key {
    return [self objectForKey:key];
}

- (id) typeForName:(FLObjcName*) name {
    return [self objectForObjcName:name];
}

@end
