//
//  FLCodeProjectReader.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 3/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeProjectReader.h"
#import "FLObjectDescriber.h"
#import "FLCodeProjectLocation.h"
#import "FLCodeProject.h"
#import "FLCodeInputType.h"
#import "FLCodeImport.h"
#import "FLCodeProjectInfo.h"
#import "FLCodeGeneratorOptions.h"
#import "FLCodeObject.h"
#import "FLCodeProperty.h"
#import "FLCodeGeneratorErrors.h"

@interface FLCodeProjectReader ()
@property (readwrite, strong) NSArray* fileReaders;
@end

@implementation FLCodeProjectReader

@synthesize fileReaders = _fileReaders;

- (id) init {
    self = [super init];
    if(self) {
        _fileReaders = [[NSMutableArray alloc]init];
    }
    return self;
}

+ (id) codeProjectReader {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void)addFileReader:(id<FLCodeProjectReader>)fileReader {
    [_fileReaders addObject:fileReader];
}

- (FLCodeProject *) readProjectFromFileURL:(NSURL*) fileURL {
    FLCodeProjectLocation* projectLocation = [FLCodeProjectLocation codeProjectLocation:fileURL
                                                                           resourceType:FLCodeProjectLocationTypeFile];

    return [self readProjectFromLocation:projectLocation];
}

- (FLCodeProject *) parseProjectFromData:(NSData*) data fromURL:(NSURL*) url {
    return nil;
}

- (FLCodeProject *) readProjectFromLocation:(FLCodeProjectLocation*) location {
    FLAssertNotNil(_fileReaders);
    FLAssert(_fileReaders.count > 0);

    NSData* data = [location loadDataInResource];

    for(id<FLCodeProjectReader> reader in _fileReaders) {
        FLCodeProject* project = [reader parseProjectFromData:data fromURL:location.URL];
        if(project) {
            [project didLoadFromLocation:location withProjectReader:self];
            return project;
        }
    }

    FLThrowCodeGeneratorError(FLCodeGeneratorErrorImportNotLoaded, @"import not loaded for location: %@", location.URL);

    return nil;
}
@end
