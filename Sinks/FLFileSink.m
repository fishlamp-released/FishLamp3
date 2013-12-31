//
//  FLFileSink.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/31/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFileSink.h"

@interface FLFileSink ()
@property (readwrite, strong, nonatomic) NSOutputStream* outputStream;
@property (readwrite, strong, nonatomic) NSString* filePath;
@property (readwrite, strong, nonatomic) NSString* outputPath;
@end

@implementation FLFileSink

@synthesize outputStream = _outputStream;
@synthesize filePath = _filePath;
@synthesize outputPath = _outputPath;
@synthesize open = _open;

- (id) initWithFilePath:(NSString*) filePath {
    self = [super init];
    if(self) {
        self.outputPath = filePath;
    }
    return self;
}

+ (id) fileSink:(NSString*) filePath {
    return FLAutorelease([[[self class] alloc] initWithFilePath:filePath]);
}

- (void) openSink {
    FLAssert(self.outputStream == nil);
    _open = YES;
    self.filePath = nil;
}

- (void) appendBytes:(const void *)bytes length:(NSUInteger)length {
    
    FLAssertNotNil(self.outputPath);
    FLAssert(_open);

    // don't create the file until we actually get bytes. This prevents
    // an empty file on error or redirect or whatever.
    if(!self.outputStream) {
    
        NSError* error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:[self.outputPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error];
        FLThrowIfError(error);
    
        self.outputStream = [NSOutputStream outputStreamWithURL:[NSURL fileURLWithPath:self.outputPath] append:NO];
        [self.outputStream open];
        
        FLThrowIfError(self.outputStream.streamError);
    }

    NSInteger amountWritten = [self.outputStream write:bytes maxLength:length];
    FLAssert(amountWritten == length);
}

- (void) deleteFile {
    NSError* fileError = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.outputPath error:&fileError];
}

- (void) closeSinkWithCommit:(BOOL) commit {

    [self.outputStream close];
    self.outputStream = nil;
    _open = NO;
    
    if(commit) {
        self.filePath = self.outputPath;
    }
    else {
        self.filePath = nil;
    
        [self deleteFile];
// todo: do what with error?

//        return FLAutorelease(fileError);
    }
}

- (void) dealloc {

    if(_outputStream) {
        [_outputStream close];
        [self deleteFile];
    }

#if FL_MRC
    [_filePath release];
    [_outputPath release];
    [_outputStream release];
    [super dealloc];
#endif
}


- (NSData*) data {
    
    FLConfirmationFailedWithComment(@"Can't get data from a fileSink");
    
//    FLConfirmWithComment(_outputStream == nil, @"can't get data from an open receiver");
//    
//    NSError* error = nil;
//    NSData* data = [NSData dataWithContentsOfString:self.filePath options:nil error:&error];
//    FLThrowIfError(error);
//    
//    return data;
    return nil;
}


@end
