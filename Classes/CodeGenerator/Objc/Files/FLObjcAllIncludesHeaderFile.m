//
//  FLObjcAllIncludesHeaderFile.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/14/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcAllIncludesHeaderFile.h"
#import "FLObjcCodeBuilder.h"
#import "FLObjcFileHeader.h"
#import "FLObjcFile.h"
#import "FLObjcFileManager.h"
#import "FLObjcProject.h"
#import "FLCodeProjectLocation.h"
#import "FLCodeProject.h"
#import "FLCodeGeneratorOptions.h"

@interface FLObjcAllIncludesHeaderFile ()
@end

@implementation FLObjcAllIncludesHeaderFile

+ (id) allIncludesHeaderFile:(NSString*) fileName {
    return FLAutorelease([[[self class] alloc] initWithFileName:fileName]);
}

#if FL_MRC
- (void) dealloc {
    [_files release];
	[super dealloc];
}
#endif

- (void) willGenerateFileWithFileManager:(FLObjcFileManager*) fileManager  {

    FLObjcFileHeader* fileHeader = [FLObjcFileHeader objcFileHeader:fileManager.project];
    [fileHeader configureWithInputProject:fileManager.project.inputProject];
    [self addCodeWriter:fileHeader];

    _files = FLRetain(fileManager.publicHeaders);
}

- (void) writeCodeToCodeBuilder:(FLObjcCodeBuilder*) codeBuilder {
    [super writeCodeToCodeBuilder:codeBuilder];

    NSMutableArray* copy = FLMutableCopyWithAutorelease(_files);

    [copy sortUsingComparator:^NSComparisonResult(FLObjcFile* obj1, FLObjcFile* obj2) {
        return [[obj1 fileName] compare:[obj2 fileName]];
    }];

    [codeBuilder appendComment:[NSString stringWithFormat:@"Imported Count: %ld", (long) copy.count]];

    for(FLObjcFile* file in copy) {
        [codeBuilder appendImport:file.fileName];
    }
}

@end
