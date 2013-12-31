//
//  FLWsdlCodeMethod.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWsdlCodeMethod.h"
#import "FLCodeCodeSnippet.h"
#import "FLWsdlCodeProjectReader.h"

@implementation FLWsdlCodeMethod

+ (id) wsdlCodeMethod:(NSString*) methodName methodReturnType:(NSString*) returnType {

    FLWsdlCodeMethod* method = FLAutorelease([[[self class] alloc] init]);
    method.name = methodName;
    
    if(FLStringIsNotEmpty(returnType)) {
        method.returnType = returnType;
    }
    
    return method;
}

- (void) setName:(NSString*) name {
    [super setName:FLDeleteNamespacePrefix(name)];
    FLConfirmStringIsNotEmptyWithComment(self.name, @"method name cannot be empty");
}

- (void) setReturnType:(NSString*) returnType {
    [super setReturnType:FLDeleteNamespacePrefix(returnType)];
}

@end
