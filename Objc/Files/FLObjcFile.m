//
//  FLObjcFile.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcFile.h"
#import "FLObjcProject.h"
#import "FLObjcCodeWriter.h"


@interface FLObjcFile ()
@property (readwrite, strong, nonatomic) NSArray* fileElements;
@end

@implementation FLObjcFile

@synthesize fileElements = _fileElements;

- (id) init {	
	return [self initWithFileName:nil];
}

- (id) initWithFileName:(NSString*) name {
    self = [super initWithFileName:name];
    if(self) {
        _fileElements = [[NSMutableArray alloc] init];
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_fileElements release];
    [super dealloc];
}
#endif

- (void) addCodeWriter:(id<FLObjcCodeWriter>) element {
    [_fileElements addObject:element];
}

- (NSString*) counterPartFileName {
//    NSString* ext = [self.fileName pathExtension];
//    if(FLStringsAreEqual(ext, @"h")) {
//        return [[self.fileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"m"];
//    }
//    else if(FLStringsAreEqual(ext, @"m")) {
//        return [[self.fileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"h"];
//    }
//    else {
//        return nil;
//    }

    return nil;
}

- (void) willGenerateFileWithFileManager:(FLObjcFileManager*) fileManager {
}

- (BOOL) isHeaderFile {
    return NO;
}

@end






