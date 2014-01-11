//
//  FLTestable+Utils.m
//  FishLampCore
//
//  Created by Mike Fullerton on 10/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestable+Utils.h"

@implementation FLTestable (Utils)

- (NSString*) loadTestFile:(NSString*) testFileName
                fromBundle:(NSBundle*) bundle {

    if(!bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    NSString* pathToFile = [bundle pathForResource:[testFileName stringByDeletingPathExtension] ofType:[testFileName pathExtension]];

    NSError* error = nil;
    NSString* contents = [NSString stringWithContentsOfFile:pathToFile encoding:NSUTF8StringEncoding error:&error];

    FLThrowIfError(error);

    return contents;
}

@end
