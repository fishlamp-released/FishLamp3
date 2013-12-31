//
//  FLObjcAllIncludesHeaderFile.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/14/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcGeneratedHeaderFile.h"
@class FLObjcProject;
@class FLCodeProjectLocation;

@interface FLObjcAllIncludesHeaderFile : FLObjcGeneratedHeaderFile {
@private
    NSArray* _files;
}

+ (id) allIncludesHeaderFile:(NSString*) fileName;

@end
