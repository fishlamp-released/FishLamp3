//
//  FLObjcArrayType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcArrayType.h"

@implementation FLObjcArrayType

//- (id) init {	
//	return [super initWithTypeName:[FLObjcImportedName objcImportedName:@"NSMutableArray"] importedFileName:nil];
//}

- (NSString*) generatedName {
    return @"NSMutableArray";
}


+ (id) objcArrayType:(FLObjcName*) typeName 
       importFileName:(NSString*) importFileName {
       return [super objcMutableObjectType:typeName importFileName:importFileName];
}


@end
