//
//  FLObjcParameterName.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcParameterName.h"


@implementation FLObjcParameterName : FLObjcName 
+ (id) objcParameterName:(NSString*) parameterName {
    return FLAutorelease([[[self class] alloc] initWithIdentifierName:parameterName prefix:nil suffix:nil]);
}
@end