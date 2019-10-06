//
//  FLObjcMutableObjectType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 6/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcMutableObjectType.h"

@implementation FLObjcMutableObjectType

+ (id) objcMutableObjectType:(FLObjcName*) typeName 
       importFileName:(NSString*) importFileName {

    return FLAutorelease([[[self class] alloc] initWithTypeName:typeName importFileName:importFileName]);
}


- (BOOL) isMutableObject {
    return YES;
}

@end
