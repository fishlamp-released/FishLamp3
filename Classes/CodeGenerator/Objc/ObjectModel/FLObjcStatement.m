//
//  FLObjcStatement.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/12/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcStatement.h"
#import "FLObjcType.h"

@implementation FLObjcStatement

//+ (id) objcStatement:(FLObjcProject*) project {
//    return FLAutorelease([[[self class] alloc] initWithProject:project]);
//}
- (void) writeCodeToHeaderFile:(FLObjcFile*) file withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
}

- (void) writeCodeToSourceFile:(FLObjcFile*) file withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
}

- (FLObjcFile*) headerFile {
    return nil;
}

- (FLObjcFile*) sourceFile {
    return nil;
}

- (BOOL) includeInAllFiles {
    return NO;
}

- (BOOL) hasCode {
    return NO;
}

@end

