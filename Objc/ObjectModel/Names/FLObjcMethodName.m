//
//  FLObjcMethodName.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcMethodName.h"


@implementation FLObjcMethodName : FLObjcName
+ (id) objcMethodName:(NSString*) methodName {
    return FLAutorelease([[[self class] alloc] initWithIdentifierName:methodName
                                                               prefix:nil
                                                               suffix:nil]);
}

- (NSString*) generatedName {
    return [[super generatedName] stringWithLowercaseFirstLetter_fl];
}

@end