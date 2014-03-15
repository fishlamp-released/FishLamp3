//
//  FLObjcNumberObjectType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcNumberObjectType.h"
#import "FLObjcCodeGeneratorHeaders.h"

@implementation FLObjcNumberObjectType 

- (id) init {	
	return [super initWithTypeName:[FLObjcImportedName objcImportedName:@"NSNumber"] importFileName:nil];
}

+ (id) objcNumberObjectType {
    return FLAutorelease([[[self class] alloc] init]);
}

@end
