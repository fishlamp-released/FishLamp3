//
//  FLObjcEnumName.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcEnumName.h"

@implementation FLObjcEnumName : FLObjcName 
+ (id) objcEnumName:(NSString*) importedName  prefix:(NSString*) prefix{
    return FLAutorelease([[[self class] alloc] initWithIdentifierName:importedName prefix:prefix suffix:nil]);
}
@end