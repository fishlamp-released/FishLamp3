//
//  FLReadStream.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/27/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampMinimum.h"
#import "FLNetworkStream.h"
#import "FLInputSink.h"

@protocol FLReadStreamDelegate;
@protocol FLReadStreamByteReader;

@interface FLReadStream : FLNetworkStream  {
@private
    CFReadStreamRef _streamRef;
    id<FLInputSink> _inputSink;
    id<FLReadStreamByteReader> _byteReader;
}

- (id) initWithStreamSecurity:(FLNetworkStreamSecurity) security 
                    inputSink:(id<FLInputSink>) inputSink;

// info
@property (readonly, assign, nonatomic) CFReadStreamRef streamRef;
@property (readonly, assign) BOOL hasBytesAvailable;
@property (readonly, assign) unsigned long bytesRead;

// optional overrides
- (CFReadStreamRef) allocReadStreamRef;

- (FLPromisedResult) createSuccessfulResult:(id<FLInputSink>) sink;

// optionally settable
// TODO: abstract this so it's not changeable.

@property (readwrite, strong, nonatomic) id<FLReadStreamByteReader> byteReader;

// utilities
- (NSUInteger) readAvailableBytesIntoBuffer:(uint8_t*) buffer
                        bufferSize:(NSUInteger) bufferSize;

@end

typedef void (^FLReadStreamByteReaderBlock)(UInt8* bytes, CFIndex amount);

@protocol FLReadStreamByteReader <NSObject>

- (void) readAvailableBytesForStream:(FLReadStream*) readStream
                           withBlock:(FLReadStreamByteReaderBlock) block;

@end

@interface FLReadStreamByteReader : NSObject<FLReadStreamByteReader>

// override these
- (uint8_t*) buffer;
- (NSUInteger) bufferSize;

- (BOOL) shouldReadBytesFromStream:(FLReadStream*) stream;

@end


#define FLReadStreamBufferSize 32768

@interface FLDefaultReadStreamByteReader : FLReadStreamByteReader {
@private
    uint8_t _buffer[FLReadStreamBufferSize];
}

@end
