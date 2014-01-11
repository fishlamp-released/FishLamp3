//
//  FLObjcImmutableObjectType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 6/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcImmutableObjectType.h"

@implementation FLObjcImmutableObjectType

+ (id) objcImmutableObjectType:(FLObjcName*) typeName 
                importFileName:(NSString*) importFileName {
    return FLAutorelease([[[self class] alloc] initWithTypeName:typeName importFileName:importFileName]);
}

- (BOOL) isMutableObject {
    return NO;
}

@end
