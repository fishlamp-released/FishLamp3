//
//  FLWriteStream.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/27/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLWriteStream.h"
#import "FLNetworkStream_Internal.h"

@interface FLWriteStream ()
@property (readwrite, assign, nonatomic) CFWriteStreamRef streamRef;
@end

static void WriteStreamClientCallBack(CFWriteStreamRef writeStream, 
                                      CFStreamEventType eventType, 
                                      void *clientCallBackInfo) {
    
    FLNetworkStream* stream = FLBridge(FLWriteStream*, clientCallBackInfo);
    [stream.eventHandler handleStreamEvent:eventType];
}

@implementation FLWriteStream

@synthesize streamRef = _streamRef;

- (id) initWithWriteStream:(CFWriteStreamRef) streamRef {
    
    if(!streamRef) {
        return nil;
    }
    
    self = [super initWithStreamSecurity:FLNetworkStreamSecurityNone];
    if(self) {
        CFRetain(streamRef);
        _streamRef = streamRef;
        if(_streamRef) {
            CFOptionFlags flags =
                    kCFStreamEventOpenCompleted | 
                    kCFStreamEventCanAcceptBytes |
                    kCFStreamEventEndEncountered | 
                    kCFStreamEventErrorOccurred;

            CFStreamClientContext ctxt = {0, FLBridge(void*,self), NULL, NULL, NULL};
            CFWriteStreamSetClient(_streamRef, flags, WriteStreamClientCallBack, &ctxt);
        }
    }

    return self;
}

+ (id) writeStream:(CFWriteStreamRef) streamRef {
    return FLAutorelease([[[self class] alloc] initWithWriteStream:streamRef]);
}

- (void) dealloc {
    FLAssertNotNil(_streamRef);

    if(_streamRef) {
        CFWriteStreamSetClient(_streamRef, kCFStreamEventNone, NULL, NULL);
        CFRelease(_streamRef);
        _streamRef = nil;
    }
    
#if FL_MRC
    [super dealloc];
#endif    
}

- (void) setStreamRef:(CFWriteStreamRef) streamRef {
    if(streamRef != _streamRef) {
        if(_streamRef) {
            CFRelease(_streamRef);
        }
        
        _streamRef = streamRef;
        
        if(_streamRef) {
            CFRetain(_streamRef);
        }
    }
}

- (NSError*) streamError {
    return FLAutorelease(FLBridgeTransfer(NSError*,CFWriteStreamCopyError(self.streamRef)));
}

- (void) openStream {
    FLAssertIsNotNil(_streamRef);
    CFWriteStreamScheduleWithRunLoop(_streamRef, [[self.eventHandler runLoop] getCFRunLoop], FLBridge(void*,self.eventHandler.runLoopMode));
    CFWriteStreamOpen(_streamRef);
}

- (void) closeStream {
    FLAssertIsNotNil(_streamRef);
    CFWriteStreamUnscheduleFromRunLoop(_streamRef, [[self.eventHandler runLoop] getCFRunLoop], FLBridge(void*,self.eventHandler.runLoopMode));
    CFWriteStreamClose(_streamRef);
    [self didCloseWithResult:FLSuccessfulResult];
}

- (BOOL) canAcceptBytes {
    return CFWriteStreamCanAcceptBytes(_streamRef);
}

- (void) writeBytes:(const uint8_t*) bytes length:(unsigned long) length {
    FLAssertIsNotNil(_streamRef);

    const uint8_t *buffer = bytes;
    while(length > 0) {
        CFIndex amt = CFWriteStreamWrite(_streamRef, buffer, length);
        if(amt <= 0) {   
            FLThrowErrorCodeWithComment((NSString*) kCFErrorDomainCFNetwork, kCFURLErrorBadServerResponse, NSLocalizedString(@"writing networkbytes failed: %d", result));
        }
        
        length -= amt;
        buffer += amt;
    }
    
    FLPerformSelector2(self.delegate, @selector(networkStream:didWriteBytes:), self, [NSNumber numberWithUnsignedLong:length]);
}

- (void) writeData:(NSData*) data {
    [self writeBytes:data.bytes length:data.length];
}

- (unsigned long) bytesWritten {
    NSNumber* number = FLAutorelease(FLBridgeTransfer(NSNumber*,
        CFWriteStreamCopyProperty(self.streamRef, kCFStreamPropertyDataWritten)));
    return [number unsignedLongValue];
}



@end
