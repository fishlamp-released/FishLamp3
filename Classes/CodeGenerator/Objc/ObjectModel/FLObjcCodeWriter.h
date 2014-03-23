//
//  FLObjcCodeWriter.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//
#import "FLGenerated.h"

@class FLObjcCodeBuilder;
@class FLObjcFile;
@class FLObjcProject;
@class FLObjcFileHeader;

@protocol FLObjcCodeWriter <NSObject>
- (void) writeCodeToHeaderFile:(FLObjcFile*) file 
               withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder;

- (void) writeCodeToSourceFile:(FLObjcFile*) file 
               withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder;

- (FLObjcFile*) headerFile;

- (FLObjcFile*) sourceFile;

- (BOOL) includeInAllFiles;

- (BOOL) hasCode;

@end

@interface FLObjcCodeWriter : NSObject<FLObjcCodeWriter, FLGenerated> {
@private
    __unsafe_unretained FLObjcProject* _project;
}
@property (readwrite, assign, nonatomic) FLObjcProject* project;

- (id) initWithProject:(FLObjcProject*) project;

// factory methods
- (FLObjcFileHeader*) generatedFileHeader;
- (FLObjcFileHeader*) userFileHeader;
- (FLObjcFile*) generatedHeaderFile;
- (FLObjcFile*) generatedSourceFile;
- (FLObjcFile*) userHeaderFile;
- (FLObjcFile*) userSourceFile;
@end
