//
//  FLObjcSourceFile.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcSourceFile.h"
#import "FLObjcCodeGeneratorHeaders.h"

@implementation FLObjcSourceFile

+ (id) sourceFile:(NSString*) rootFileName {
    return FLAutorelease([[[self class] alloc] initWithFileName:rootFileName]);
}

- (void) writeCodeToCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
    for(id<FLObjcCodeWriter> codeElement in self.fileElements) {
        [codeElement writeCodeToSourceFile:self withCodeBuilder:codeBuilder];
    }
}

- (void) setFileName:(NSString*) fileName {
    [super setFileName:[fileName stringByAppendingSuffix_fl:@".m"]];
}

- (BOOL) canUpdateExistingFile {
    return NO;
}

- (NSString*) counterPartFileName {
    return [[self.fileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"h"];
}

@end