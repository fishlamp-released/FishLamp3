//
//  FLReadStream.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/27/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLReadStream.h"
#import "FLNetworkStream_Internal.h"
#import "FishLampSimpleLogger.h"

@interface FLReadStream ()
@property (readwrite, strong, nonatomic) id<FLInputSink> inputSink;
@end

//#if DEBUG
//CFIndex _FLReadStreamRead(CFReadStreamRef stream, UInt8 *buffer, CFIndex bufferLength) {
//    memset(buffer, bufferLength, 0); 
//    return CFReadStreamRead(stream, buffer, bufferLength); 
//}
//#define CFReadStreamRead _FLReadStreamRead
//#endif

static void ReadStreamClientCallBack(CFReadStreamRef streamRef, CFStreamEventType eventType, void *clientCallBackInfo) {

    FLNetworkStream* stream = FLBridge(FLReadStream*, clientCallBackInfo);
    [stream.eventHandler handleStreamEvent:eventType];
}

@implementation FLReadStream

@synthesize streamRef = _streamRef;
@synthesize inputSink = _inputSink;
@synthesize byteReader = _byteReader;

- (id) initWithStreamSecurity:(FLNetworkStreamSecurity) security 
                    inputSink:(id<FLInputSink>) inputSink {
                    
	self = [super initWithStreamSecurity:security];
	if(self) {
        _byteReader = [[FLDefaultReadStreamByteReader alloc] init];
        _inputSink = FLRetain(inputSink);
	}
	return self;
}

- (void) killStream {
    if(_streamRef) {
        CFReadStreamClose(_streamRef);
        CFReadStreamUnscheduleFromRunLoop(_streamRef, [[self.eventHandler runLoop] getCFRunLoop], FLBridge(void*,self.eventHandler.runLoopMode));
        CFRelease(_streamRef);
        _streamRef = nil;
    }
}

- (void) dealloc {
#if DEBUG
    if(_streamRef) {
        FLLog(@"WARNING: stream not closed in dealloc");
    }
#endif     
    
    [self killStream];
    
#if FL_MRC 
    [_byteReader release];
    [_inputSink release];
    [super dealloc];
#endif
}

- (NSError*) streamError {
    return FLAutorelease(FLBridgeTransfer(NSError*, CFReadStreamCopyError(self.streamRef)));
}

- (CFReadStreamRef) allocReadStreamRef {
    return nil;
}

#define kCFStreamPropertyReadTimeout CFSTR("_kCFStreamPropertyReadTimeout")

- (void) openStream {

    FLAssert([NSThread currentThread] != [NSThread mainThread]);
    
    [self killStream];
     
    _streamRef = [self allocReadStreamRef];         
         
    FLAssertNonNilPointer(_streamRef);

    [self.inputSink openSink];

    CFOptionFlags flags =
            kCFStreamEventOpenCompleted | 
            kCFStreamEventHasBytesAvailable | 
            kCFStreamEventEndEncountered | 
            kCFStreamEventErrorOccurred;

    CFStreamClientContext ctxt = {0, FLBridge(void*, self), NULL, NULL, NULL};
    CFReadStreamSetClient(_streamRef, flags, ReadStreamClientCallBack, &ctxt);

    if(self.streamSecurity == FLNetworkStreamSecuritySSL) {
        CFReadStreamSetProperty(_streamRef, kCFStreamSSLLevel, kCFStreamSocketSecurityLevelNegotiatedSSL);

//        CFReadStreamSetProperty(_streamRef, kCFStreamSSLLevel, kCFStreamSocketSecurityLevelSSLv3);


        NSDictionary *sslSettings = [NSDictionary dictionaryWithObjectsAndKeys:
         (id)kCFBooleanFalse, (id)kCFStreamSSLValidatesCertificateChain, 
         nil];

        CFReadStreamSetProperty(_streamRef,kCFStreamPropertySSLSettings, FLBridge(CFTypeRef, sslSettings));
    }


// this doesn't see to work on 10.8
#if 0
    CFReadStreamSetProperty(_streamRef, 
                            kCFStreamPropertyReadTimeout, 
                            [NSNumber numberWithDouble:[self.delegate networkStreamGetTimeoutInterval:self]*2]);
#endif                            

    CFReadStreamOpen(_streamRef);
    CFReadStreamScheduleWithRunLoop(_streamRef, [[self.eventHandler runLoop] getCFRunLoop], FLBridge(CFStringRef,self.eventHandler.runLoopMode));
}


- (FLPromisedResult) createSuccessfulResult:(id<FLInputSink>) sink {
    return sink;
}


- (void) closeStream {

    FLAssert([NSThread currentThread] != [NSThread mainThread]);

    if(_streamRef) {
        FLPromisedResult result = nil;
        @try {

            if(self.hasError) {
                [self.inputSink closeSinkWithCommit:NO];
                result = FLRetainWithAutorelease(self.error);

                FLLog(@"closed stream with error: %@", self.error);
            }
            else {
                result = [self createSuccessfulResult:self.inputSink];
            }
        }
        @finally {

            if( !result ) {
                result = FLFailedResult;
            }

            [self killStream];
            [self didCloseWithResult:result];

            if(self.inputSink.isOpen) {
                [self.inputSink closeSinkWithCommit:NO];
            }

        }
    }
}

- (BOOL) hasBytesAvailable {
    if(_streamRef) {
        return CFReadStreamHasBytesAvailable(_streamRef) && !self.hasError;
    }
    return NO;
}

- (void) encounteredBytesAvailable {
    [self.byteReader readAvailableBytesForStream:self
                                       withBlock:^(UInt8 *bytes, CFIndex amount) {
        [self.inputSink appendBytes:bytes length:amount];
        FLPerformSelector2(self.delegate, @selector(networkStream:didReadBytes:), self, [NSNumber numberWithUnsignedInteger:amount]);
    }];
}

- (BOOL) readResultIsError:(NSInteger) bytesRead {

    if(bytesRead == 0) {
        // CFReadStreamHasBytesAvailable lied. 
        return YES;
    }

    if(bytesRead < 0) {
    
        NSError* error = [self streamError];
        if(error) {
            [self encounteredError:error];
        }
        else {
            NSString* description = 
                [NSString stringWithFormat:NSLocalizedString(@"Read network bytes failed: %d", nil), bytesRead];
        
            [self encounteredError:[NSError errorWithDomain:(NSString*) kCFErrorDomainCFNetwork 
                                                       code:kCFURLErrorBadServerResponse 
                                       localizedDescription:description]];
        }
    
        return YES;
    }
    
    return NO;
}

- (NSUInteger) readAvailableBytesIntoBuffer:(uint8_t*) buffer
                        bufferSize:(NSUInteger) bufferSize {

    FLAssert([NSThread currentThread] != [NSThread mainThread]);
      
    FLAssertNonNilPointer(_streamRef);
    if(!_streamRef) {
        return 0;
    }

#if DEBUG   
    uint8_t* lastBytePtr = buffer + bufferSize;
#endif
    uint8_t* readPtr = buffer;
    NSUInteger readTotal = 0;
    while(bufferSize > 0 && [self hasBytesAvailable]) {

#if DEBUG
        FLAssert(readPtr + bufferSize <= lastBytePtr, @"buffer overrun!!!! Warning warning warning!!!!");
#endif
        NSInteger bytesRead = CFReadStreamRead(_streamRef, readPtr, bufferSize);
        if([self readResultIsError:bytesRead]) {
            return 0;
            break;
        }
       
        readPtr += bytesRead;
        bufferSize -= bytesRead;
        readTotal += bytesRead;
    }

    return readTotal;
}

- (unsigned long) bytesRead {
    if(_streamRef) {
        NSNumber* number = FLAutorelease(FLBridgeTransfer(NSNumber*,
            CFReadStreamCopyProperty(self.streamRef, kCFStreamPropertyDataWritten)));

        return [number unsignedLongValue];
    }
    return 0;
}

@end

@implementation FLReadStreamByteReader

- (BOOL) shouldReadBytesFromStream:(FLReadStream*) readStream {
    return readStream.hasBytesAvailable && !readStream.hasError;
}

- (void) readAvailableBytesForStream:(FLReadStream*) readStream
                           withBlock:(FLReadStreamByteReaderBlock) block {

    uint8_t* buffer = self.buffer;
    NSUInteger bufferSize = self.bufferSize;

    while([self shouldReadBytesFromStream:readStream]) {
        NSUInteger bytesRead = [readStream readAvailableBytesIntoBuffer:buffer bufferSize:bufferSize];
        if(bytesRead) {
            block(buffer, bytesRead);
        }
    }
}

- (uint8_t*) buffer {
    return nil;
}

- (NSUInteger) bufferSize {
    return 0;
}

@end

#if 0
#define TEST_TIMEOUT 10
#endif

#if TEST_TIMEOUT
static long counter = 0;
#endif

@implementation FLDefaultReadStreamByteReader

#if TEST_TIMEOUT

- (id) init {	
	self = [super init];
	if(self) {
		counter++;
	}
	return self;
}


- (BOOL) shouldReadBytesFromStream:(FLReadStream*) readStream {

    if(counter % TEST_TIMEOUT == 0) {
        NSLog(@"Faking timeout: %ld", counter);
        readStream.timer.timeoutInterval = 2.0f;
        return NO;
    }
    else {
        return [super shouldReadBytesFromStream:readStream];
    }
}
#endif

- (uint8_t*) buffer {
    return _buffer;
}

- (NSUInteger) bufferSize {
    return FLReadStreamBufferSize;
}

@end
