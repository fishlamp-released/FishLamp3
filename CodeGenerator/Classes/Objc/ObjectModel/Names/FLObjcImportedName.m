//
//  FLObjcImportedName.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcImportedName.h"



@implementation FLObjcImportedName : FLObjcName 
+ (id) objcImportedName:(NSString*) importedName{
    return FLAutorelease([[[self class] alloc] initWithIdentifierName:importedName prefix:nil suffix:nil]);
}
@end