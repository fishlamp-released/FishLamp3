//
//  FLWsdlCodeEnum.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWsdlCodeEnum.h"
#import "FLWsdlCodeProjectReader.h"

@implementation FLWsdlCodeEnum

+ (id) wsdlCodeEnum:(NSString*) name {
    FLWsdlCodeEnum* theEnum = FLAutorelease([[[self class] alloc] init]);
    theEnum.name = name;
    return theEnum;
}

- (void) setName:(NSString*) name {
    [super setName:FLDeleteNamespacePrefix(name)];
    FLConfirmStringIsNotEmptyWithComment(self.name, @"enum name cannot be empty");
}


@end
