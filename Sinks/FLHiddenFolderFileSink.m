//
//  FLHiddenFolderFileSink.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/31/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHiddenFolderFileSink.h"

@interface FLHiddenFolderFileSink ()
@property (readwrite, strong, nonatomic) NSString* folderPath;
@property (readwrite, strong, nonatomic) NSString* destinationFilePath;
@property (readwrite, strong, nonatomic) NSString* tempFilePath;

@end

@implementation FLHiddenFolderFileSink

@synthesize folderPath = _folderPath;
@synthesize destinationFilePath = _destinationFilePath;
@synthesize tempFilePath = _tempFilePath;

- (id) initWithFilePath:(NSString*) filePath folderPath:(NSString*) folderPath {
    
    NSString* tempFilePath = [folderPath stringByAppendingPathComponent:[filePath lastPathComponent]];

    self = [super initWithFilePath:tempFilePath];
    if(self) {
        self.tempFilePath = tempFilePath;
        self.destinationFilePath = filePath;
        self.folderPath = folderPath;
    }
    return self;
}

+ (id) hiddenFolderFileSink:(NSString*) filePath folderPath:(NSString*) folderPath {
    return FLAutorelease([[[self class] alloc] initWithFilePath:filePath folderPath:folderPath]); 
}

#if FL_MRC
- (void) dealloc {
    [_tempFilePath release];
    [_destinationFilePath release];
    [_folderPath release];
	[super dealloc];
}
#endif

- (void) createDirectoryIfNeeded:(NSString*) path {
    NSError* error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];

    if(error) {
        if([[error domain] isEqualToString:NSCocoaErrorDomain] && error.code == NSFileWriteFileExistsError) {
            return;
        }

        FLThrowError(error);
    }

}

- (void) openSink {
    [self createDirectoryIfNeeded:self.folderPath];
    [super openSink];
}

- (void) closeSinkWithCommit:(BOOL) commit {
    
    [super closeSinkWithCommit:commit];
    
    if(commit) {
        [self createDirectoryIfNeeded:[self.destinationFilePath stringByDeletingLastPathComponent]];
    
        NSError* error = nil;
        [[NSFileManager defaultManager] moveItemAtPath:self.tempFilePath toPath:self.destinationFilePath error:&error];
        
        FLThrowIfError(error);
    }
}

@end
