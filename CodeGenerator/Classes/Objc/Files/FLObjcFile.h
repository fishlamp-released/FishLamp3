//
//  FLObjcFile.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeGeneratorFile.h"

@protocol FLObjcCodeWriter;
@class FLCodeSession;
@class FLObjcFileManager;
@class FLCodeProject;

@interface FLObjcFile : FLCodeGeneratorFile {
@private

    NSMutableArray* _fileElements;
}

@property (readonly, strong, nonatomic) NSArray* fileElements;


- (void) addCodeWriter:(id<FLObjcCodeWriter>) element;

- (NSString*) counterPartFileName;
                           
- (void) willGenerateFileWithFileManager:(FLObjcFileManager*) fileManager  ;

- (BOOL) isHeaderFile; 

@end









