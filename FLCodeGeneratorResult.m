//
//  FLCodeGeneratorResult.m
//  Whittle
//
//  Created by Mike Fullerton on 6/16/12.
//  Copyright (c) 2012 GreenTongue Software. All rights reserved.
//

#import "FLCodeGeneratorResult.h"
#import "FLCodeBuilder.h"

@implementation FLCodeGeneratorResult

@synthesize addedFiles = _addedFiles;
@synthesize changedFiles = _changedFiles;
@synthesize unchangedFiles = _unchangedFiles;
@synthesize removedFiles = _removedFiles;
@synthesize project= _project;


- (id) initWithProject:(FLCodeProject*) codeProject {
    self = [super init];
    if(self) {
        _addedFiles = [[NSMutableArray alloc] init];
        _changedFiles = [[NSMutableArray alloc] init];
        _unchangedFiles = [[NSMutableArray alloc] init];
        _removedFiles = [[NSMutableArray alloc] init];
        self.project = codeProject;
    }
    
    return self;
}

+ (FLCodeGeneratorResult*) codeGeneratorResult:(FLCodeProject*) project {
    return FLAutorelease([[FLCodeGeneratorResult alloc] initWithProject:project]);
}

#if FL_MRC 
- (void) dealloc {
    [_project release];
    [_addedFiles release];
    [_changedFiles release];
    [_unchangedFiles release];
    [_removedFiles release];
    [super dealloc];
}
#endif

- (void) addNewFile:(id<FLCodeGeneratorFile>) newFile {
    [_addedFiles addObject:newFile];
}

- (void) addChangedFile:(id<FLCodeGeneratorFile>) changedFile {
    [_changedFiles addObject:changedFile];
}

- (void) addUnchangedFile:(id<FLCodeGeneratorFile>) unchangedFile {
    [_unchangedFiles addObject:unchangedFile];
}

- (void) addRemovedFile:(id<FLCodeGeneratorFile>) removedFile {
    [_removedFiles addObject:removedFile];
}

//- (void) getResultsString:(FLCodeBuilder*) output
//{
//	if(self.addedFiles.count) {
//		for(NSString* file in self.addedFiles){
//			[output appendLineWithFormat:@"New: %@", file];
//		}
//	}
//	if(self.changedFiles.count) {
//		for(NSString* file in self.changedFiles) {
//			[output appendLineWithFormat:@"Updated: %@", file];
//		}
//	}
///*
//	if(self.removedFiles.count)
//	{
//		[output appendLine:@"Removed files:"];
//		for(NSString* file in self.removedFiles)
//		{
//			[output appendLine:file];
//		}
//		[output appendBlankLine];
//	}
//	if(self.unchangedFiles.count)
//	{
//		[output appendLine:@"Unchanged files:"];
//		for(NSString* file in self.unchangedFiles)
//		{
//			[output appendLine:file];
//		}
//		[output appendBlankLine];
//	}
//	
//	[output appendLine:[self.diffs string]];
//*/
//}

       

@end
