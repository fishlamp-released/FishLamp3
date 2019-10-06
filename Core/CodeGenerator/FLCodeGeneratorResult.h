//
//  FLCodeGeneratorResult.h
//  Whittle
//
//  Created by Mike Fullerton on 6/16/12.
//  Copyright (c) 2012 GreenTongue Software. All rights reserved.
//

#import "FishLampCore.h"

@protocol FLCodeGeneratorFile;
@class FLCodeProject;

@interface FLCodeGeneratorResult : NSObject {
@private
	NSMutableArray* _addedFiles;
	NSMutableArray* _changedFiles;
	NSMutableArray* _unchangedFiles;
	NSMutableArray* _removedFiles;

    FLCodeProject* _project;
}

@property (readwrite, strong, nonatomic) FLCodeProject* project;

@property (readonly, strong, nonatomic) NSArray* addedFiles;
@property (readonly, strong, nonatomic) NSArray* changedFiles;
@property (readonly, strong, nonatomic) NSArray* unchangedFiles;
@property (readonly, strong, nonatomic) NSArray* removedFiles;

+ (FLCodeGeneratorResult*) codeGeneratorResult:(FLCodeProject*) project;

- (void) addNewFile:(id<FLCodeGeneratorFile>) newFile;
- (void) addChangedFile:(id<FLCodeGeneratorFile>) changedFile;
- (void) addUnchangedFile:(id<FLCodeGeneratorFile>) unchangedFile;
- (void) addRemovedFile:(id<FLCodeGeneratorFile>) removedFile;

@end

