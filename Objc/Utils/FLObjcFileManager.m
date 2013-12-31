//
//  FLObjcFileManager.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/13/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcFileManager.h"
#import "FLCodeProject.h"
#import "FLCodeGeneratorOptions.h"
#import "FLCodeGeneratorResult.h"

#import "FLObjcCodeGeneratorHeaders.h"

@interface FLObjcFileManager ()
@property (readwrite, assign, nonatomic) FLObjcProject* project;
@end

@implementation FLObjcFileManager
@synthesize files = _files;
@synthesize project = _project;
@synthesize publicHeaders = _publicHeaders;

- (id) initWithProject:(FLObjcProject*) project {	
	self = [super init];
	if(self) {
		_files = [[NSMutableArray alloc] init];
        _publicHeaders = [[NSMutableArray alloc] init];

        self.project = project;
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
    [_publicHeaders release];
	[_files release];
	[super dealloc];
}
#endif

+ (id) objcFileManager:(FLObjcProject*) codeProject {
    return FLAutorelease([[[self class] alloc] initWithProject:codeProject]);
}

//- (NSString*) outputFolderPath  {
//
//// TODO: abstract away dependency on inputProject
//    NSString* outPath = self.project.inputProject.projectFolderPath;
//
//	if(FLStringIsNotEmpty(self.project.inputProject.options.objectsFolderName)) { 
//        outPath = [outPath stringByAppendingPathComponent:self.project.inputProject.options.objectsFolderName];
//    }
//
//    return outPath;
//}

- (void) createGeneratedDirectoryIfNeeded:(NSString*) path {
    BOOL isDirectory = NO;
    if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]){
        NSError* err = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
        if(err){
            FLThrowIfError(err);
        }
    }
    else if(!isDirectory){

    // TODO: need to throw an error, not an exception.
        @throw [NSException exceptionWithName:@"Can't create generation folder" reason:@"Folder exists already but is a file" userInfo:nil];
    }
}

- (void) writeFilesToDisk:(FLObjcCodeGenerator*) codeGenerator {

// TODO: refactor this.
	
//	if(_comments && _comments.count) {
//		FLObjcCodeBuilder* builder = [FLObjcCodeBuilder codeDocument];
//		for(FLCodeComment* comment in _comments) {
//			[builder appendLineWithFormat:@"\"%@.%@\" = \"%@\";", comment.object, comment.commentID, [comment.comment stringByReplacingOccurrencesOfString:@"\"" withString:@"\'"]];
//		}
//		
//		FLCodeGeneratorFile* commentsFile = [FLCodeGeneratorFile file];
//		commentsFile.name = [NSString stringWithFormat:@"%@.strings", forProject.projectName];
//		commentsFile.contents = [builder buildString];
//		[_generatedFiles addObject:commentsFile];
//	}

    NSString* folderPath = self.project.inputProject.projectFolderPath;

// TODO: 
// Make this an atomic operation.
// 1. copy changed file to temp folder
// 2. if there's a failure, restore the file.

	for(FLObjcFile* file in _files) {

        NSString* srcPath = folderPath;
        
        if(FLStringIsNotEmpty(file.folder)) {
            srcPath = [srcPath stringByAppendingPathComponent:file.folder];
        }
        
        [self createGeneratedDirectoryIfNeeded:srcPath];

        srcPath = [srcPath stringByAppendingPathComponent:file.fileName];

        FLObjcCodeBuilder* codeBuilder = [FLObjcCodeBuilder objcCodeBuilder];

        [file willGenerateFileWithFileManager:self];
        
        FLCodeGeneratorFileWriteResult writeResult = [file writeFileToPath:srcPath withCodeBuilder:codeBuilder];

        switch(writeResult) {
            case FLCodeGeneratorFileWriteResultUnchanged:
                [codeGenerator sendMessageToListeners:@selector(codeGenerator:didSkipFile:) withObject:codeGenerator withObject:file];

//                [result addUnchangedFile:file];
            break;

            case FLCodeGeneratorFileWriteResultUpdated:
                [codeGenerator sendMessageToListeners:@selector(codeGenerator:didUpdateFile:) withObject:codeGenerator withObject:file];

//                [result addChangedFile:file];
            break;

            case FLCodeGeneratorFileWriteResultNew:
                [codeGenerator sendMessageToListeners:@selector(codeGenerator:didWriteNewFile:) withObject:codeGenerator withObject:file];

//                [result addNewFile:file];
            break;

            case FLCodeGeneratorFileWriteResultRemoved:
                [codeGenerator sendMessageToListeners:@selector(codeGenerator:didRemoveFile:) withObject:codeGenerator withObject:file];

//                [result addRemovedFile:file];
            break;

        }
    }
}

- (void) addFile:(FLObjcFile*) file {
    FLAssertNotNil(file);
    FLAssertStringIsNotEmptyWithComment(file.fileName, @"file has no name");

    [_files addObject:file];
}


- (void) addFilesWithArrayOfCodeElements:(NSArray*) elementList {

    for(FLObjcCodeWriter* element in elementList) {
            
        FLObjcFile* headerFile = [element headerFile];
        if(headerFile) {
            [self addFile:headerFile];

            if(element.includeInAllFiles) {
                [_publicHeaders addObject:headerFile];
            }

        }
        
        FLObjcFile* sourceFile = [element sourceFile];
        if(sourceFile) {
            [self addFile:sourceFile];
        }
    }
}

@end
