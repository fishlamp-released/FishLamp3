//
//  FLObjcCustomProperty.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcCustomProperty.h"
#import "FLObjcMethod.h"

@implementation FLObjcCustomProperty

+ (id) objcCustomProperty:(FLObjcProject*) project {
    return [super objcProperty:project];
}

- (void) writeCodeToSourceFile:(FLObjcFile*) file 
               withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {

    [self.getter writeCodeToSourceFile:file withCodeBuilder:codeBuilder];
    [self.setter writeCodeToSourceFile:file withCodeBuilder:codeBuilder];
}

@end
