//
//  FLObjcFileManager.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/13/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcFile.h"

@class FLObjcTypeRegistry;
@class FLObjcProject;
@class FLCodeGeneratorResult;
@class FLObjcFile;
@class FLObjcCodeGenerator;

@interface FLObjcFileManager : NSObject {
@private
    NSMutableArray* _files;
    NSMutableArray* _publicHeaders;

    __unsafe_unretained FLObjcProject* _project;
}
@property (readonly, strong, nonatomic) NSArray* files;
@property (readonly, strong, nonatomic) NSArray* publicHeaders;
@property (readonly, assign, nonatomic) FLObjcProject* project;

+ (id) objcFileManager:(FLObjcProject*) codeProject;

- (void) addFilesWithArrayOfCodeElements:(NSArray*) elementList;

- (void) addFile:(FLObjcFile*) file;

- (void) writeFilesToDisk:(FLObjcCodeGenerator*) codeGenerator;

@end
