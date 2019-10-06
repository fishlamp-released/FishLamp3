//
//  FLObjcIvar.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcIvar.h"
#import "FLObjcCodeGeneratorHeaders.h"

@implementation FLObjcIvar

+ (id) objcIvar:(FLObjcName*) variableName ivarType:(FLObjcType*) variableType {
    return FLAutorelease([[[self class] alloc] initWithVariableName:variableName variableType:variableType]);
}

- (void) writeCodeToHeaderFile:(FLObjcFile*) file withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
    [codeBuilder appendVariableDeclaration:self.variableType.generatedReference variableName:self.variableName.generatedName];
}

@end
