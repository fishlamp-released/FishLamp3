//
//  FLObjcAbstractObjectType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcAbstractObjectType.h"
#import "FLObjcImportedName.h"

@implementation FLObjcAbstractObjectType 
- (id) init {	
	return [self initWithTypeName:[FLObjcImportedName objcImportedName:@"id"] importFileName:nil];
}
+ (id) objcAbstractObjectType {
    return FLAutorelease([[[self class] alloc] init]);
}
- (BOOL) isObject {
    return YES;
}
@end

