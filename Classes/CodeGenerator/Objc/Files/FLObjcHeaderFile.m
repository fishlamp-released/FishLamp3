//
//  FLObjcHeaderFile.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcHeaderFile.h"
#import "FLObjcCodeGeneratorHeaders.h"
#import "NSString+FishLamp.h"

@implementation FLObjcHeaderFile
- (BOOL) isHeaderFile {
    return YES;
}

+ (id) headerFile:(NSString*) rootFileName {
    return FLAutorelease([[[self class] alloc] initWithFileName:rootFileName]);
}

- (void) writeCodeToCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
    for(id<FLObjcCodeWriter> codeElement in self.fileElements) {
        [codeElement writeCodeToHeaderFile:self withCodeBuilder:codeBuilder];
    }
}

- (void) setFileName:(NSString*) fileName {
    [super setFileName:[fileName stringByAppendingSuffix_fl:@".h"]];
}

- (BOOL) canUpdateExistingFile {
    return NO;
}

- (NSString*) counterPartFileName {
    return [[self.fileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"m"];
}

@end
