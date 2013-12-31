//
//  FLObjcVoidType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcVoidType.h"
#import "FLObjcCodeGeneratorHeaders.h"

@implementation FLObjcVoidType 
- (id) init {	
	return [self initWithTypeName:[FLObjcImportedName objcImportedName:@"void"] importFileName:nil];
}
+ (id) objcVoidType {
    return FLAutorelease([[[self class] alloc] init]);
}
- (BOOL) isObject {
    return NO;
}
@end
