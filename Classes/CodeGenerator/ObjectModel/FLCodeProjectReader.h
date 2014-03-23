//
//  FLCodeProjectReader.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 3/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FLCodeProjectLocation.h"
@class FLCodeProject;

@protocol FLCodeProjectReader <NSObject>
- (FLCodeProject *) parseProjectFromData:(NSData*) data fromURL:(NSURL*) url;
@end

@interface FLCodeProjectReader : NSObject<FLCodeProjectReader> {
@private
    NSMutableArray* _fileReaders;
}
+ (id) codeProjectReader;

@property (readonly, strong, nonatomic) NSArray* fileReaders;
- (void) addFileReader:(id<FLCodeProjectReader>) fileReader;

- (FLCodeProject *) readProjectFromFileURL:(NSURL*) fileURL;
- (FLCodeProject *) readProjectFromLocation:(FLCodeProjectLocation*) location;

@end
