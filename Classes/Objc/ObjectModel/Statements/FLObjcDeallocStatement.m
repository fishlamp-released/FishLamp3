//
//  FLObjcDeallocStatement.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcDeallocStatement.h"
#import "FLObjcCodeGeneratorHeaders.h"


@implementation FLObjcDeallocStatement  
@synthesize object = _object;

- (void) writeCodeToSourceFile:(FLObjcFile*) file 
               withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder  {
               
    for(FLObjcIvar* ivar in [self.object.ivars objectEnumerator]) {
        if(ivar.variableType.isObject) {
            [codeBuilder appendRelease:ivar.variableName.generatedName];
        }
    }
    
    [codeBuilder appendSuperDealloc];
}

- (BOOL) hasCode {
    return YES;
}


@end