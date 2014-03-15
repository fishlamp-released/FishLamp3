//
//  FLObjcEnumRegistry.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 6/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcEnumRegistry.h"
#import "FLObjcCodeGeneratorHeaders.h"

@implementation FLObjcEnumRegistry

+ (id) objcEnumRegistry {
    return FLAutorelease([[[self class] alloc] init]);
}

- (BOOL) hasEnum:(FLObjcEnumCodeWriter*) theEnum {
    return [self hasObjcName:theEnum.enumName];
}

- (void) addEnum:(FLObjcEnumCodeWriter*) theEnum {
    [self addObject:theEnum forObjcName:theEnum.enumName];
}

- (void) replaceEnum:(FLObjcEnumCodeWriter*) theEnum {
    [self replaceObject:theEnum forObjcName:theEnum.enumName];
}

- (id) enumForKey:(NSString*) key {
    return [self objectForKey:key];
}

- (id) enumForName:(FLObjcName*) name {
    return [self objectForObjcName:name];
}


@end
