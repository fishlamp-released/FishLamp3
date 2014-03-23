//
//  FLObjcCodeWriter.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcCodeWriter.h"
#import "FLObjcProject.h"
#import "FLObjcCodeBuilder.h"
#import "FLObjcFile.h"
#import "FLObjcFileHeader.h"

#import "FLCodeProject.h"
#import "FLCodeGeneratorOptions.h"
#import "FLObjcCodeGeneratorHeaders.h"
#import "FLObjcGeneratedHeaderFile.h"
#import "FLObjcGeneratedSourceFile.h"
#import "FLObjcUserHeaderFile.h"
#import "FLObjcUserSourceFile.h"

@implementation FLObjcCodeWriter
@synthesize project = _project;

- (NSString*) generatedReference {
    return nil;
}

- (NSString*) generatedName {
    return nil;
}

- (id) init {	
	return [self initWithProject:nil];
}

- (id) initWithProject:(FLObjcProject*) project {	
    FLAssertNotNil(project);
	self = [super init];
	if(self) {
		_project = project;
	}
	return self;
}

- (void) writeCodeToHeaderFile:(FLObjcFile*) file 
               withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
}

- (void) writeCodeToSourceFile:(FLObjcFile*) file 
               withCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
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

- (FLObjcFileHeader*) generatedFileHeader {
    FLObjcFileHeader* fileHeader = [FLObjcGeneratedFileHeader objcFileHeader:self.project];
    [fileHeader configureWithInputProject:self.project.inputProject];
    return fileHeader;
}

- (FLObjcFileHeader*) userFileHeader {
    FLObjcFileHeader* fileHeader = [FLObjcUserFileHeader objcFileHeader:self.project];
    [fileHeader configureWithInputProject:self.project.inputProject];
    return fileHeader;
}


- (FLObjcFile*) generatedHeaderFile {
    FLObjcFile* file = [FLObjcGeneratedHeaderFile headerFile:self.generatedName];
    file.folder = self.project.inputProject.options.objectsFolderName;
    [file addCodeWriter:[self generatedFileHeader]];
    [file addCodeWriter:self];
    return file;
}

- (FLObjcFile*) generatedSourceFile {
    FLObjcFile* file = [FLObjcGeneratedSourceFile sourceFile:self.generatedName];
    file.folder = self.project.inputProject.options.objectsFolderName;

    [file addCodeWriter:[self generatedFileHeader]];
    [file addCodeWriter:self];

    return file;
}

- (FLObjcFile*) userHeaderFile {
    FLObjcFile* file = [FLObjcUserHeaderFile headerFile:self.generatedName];
    file.folder = self.project.inputProject.options.userObjectsFolderName;

    [file addCodeWriter:[self userFileHeader]];
    [file addCodeWriter:self];

    return file;
}

- (FLObjcFile*) userSourceFile {
    FLObjcFile* file = [FLObjcUserSourceFile sourceFile:self.generatedName];
    file.folder = self.project.inputProject.options.userObjectsFolderName;

    [file addCodeWriter:[self userFileHeader]];
    [file addCodeWriter:self];

    return file;
}

@end
