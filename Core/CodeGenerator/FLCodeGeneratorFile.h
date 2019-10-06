//
//  FLCodeGeneratorFile.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 1/6/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeBuilder.h"

typedef enum {
    FLCodeGeneratorFileWriteResultUnchanged,
    FLCodeGeneratorFileWriteResultUpdated,
    FLCodeGeneratorFileWriteResultNew,
    FLCodeGeneratorFileWriteResultRemoved
} FLCodeGeneratorFileWriteResult;

@protocol FLCodeGeneratorFile <NSObject>
- (NSString*) folder;
- (NSString*) fileName;

- (NSString*) relativePathToProject;
@end

@interface FLCodeGeneratorFile : NSObject<FLCodeGeneratorFile> {
@private
    NSString* _fileName;
    NSString* _folder;
}

@property (readwrite, strong, nonatomic) NSString* folder;
@property (readwrite, strong, nonatomic) NSString* fileName;

- (id) initWithFileName:(NSString*) fileName;

+ (id) codeGeneratorFile:(NSString*) name;
+ (id) codeGeneratorFile;

- (FLCodeGeneratorFileWriteResult) writeFileToPath:(NSString*) path 
                                   withCodeBuilder:(FLCodeBuilder*) codeBuilder;

- (void) writeCodeToCodeBuilder:(FLCodeBuilder*) codeBuilder;

- (BOOL) canUpdateExistingFile;

@end
