//
//  FLObjcValueType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcValueType.h"

@implementation FLObjcValueType

+ (id) objcValueType:(FLObjcName*) typeName 
       importFileName:(NSString*) importFileName {

    return FLAutorelease([[[self class] alloc] initWithTypeName:typeName importFileName:importFileName]);
}

- (BOOL) isObject {
    return NO;
}

@end
