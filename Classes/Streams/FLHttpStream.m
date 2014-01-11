//
//  FLHttpStream.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpStream.h"
#import "FLNetworkStream_Internal.h"

@interface FLHttpStream ()
@property (readonly, strong, nonatomic) FLHttpMessage* responseHeaders;
@property (readonly, strong, nonatomic) FLHttpMessage* requestHeaders;
@end

@implementation FLHttpStreamSuccessfulResult

@synthesize responseHttpHeaders = _responseHttpHeaders;
@synthesize responseData = _responseData;

- (id) initWithResponseHeaders:(FLHttpMessage*) header responseData:(id<FLInputSink>) inputSink {
	self = [super init];
	if(self) {
		_responseHttpHeaders = FLRetain(header);
        _responseData = FLRetain(inputSink);
	}
	return self;
}

+ (id) httpStreamSuccessfulResult:(FLHttpMessage*) header responseData:(id<FLInputSink>) inputSink {
    return FLAutorelease([[[self class] alloc] initWithResponseHeaders:header responseData:inputSink]);
}

#if FL_MRC
- (void)dealloc {
	[_responseHttpHeaders release];
    [_responseData release];
    [super dealloc];
}
#endif

@end


@implementation FLHttpStream
@synthesize responseHeaders = _responseHeaders;
@synthesize requestHeaders = _requestHeaders;

- (id) init {
    return [self initWithHttpMessage:nil withBodyStream:nil streamSecurity:FLNetworkStreamSecurityNone inputSink:nil];
}

- (id) initWithHttpMessage:(FLHttpMessage*) request 
            withBodyStream:(NSInputStream*) bodyStream             
            streamSecurity:(FLNetworkStreamSecurity) security
                 inputSink:(id<FLInputSink>) inputSink {

    FLAssertNotNil(request);
    FLAssertNotNil(inputSink);

    self = [super initWithStreamSecurity:security inputSink:inputSink];
    if(self ) {
        _requestHeaders = FLRetain(request);
        _bodyStream = FLRetain(bodyStream);
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_requestHeaders release];
    [_bodyStream release];
    [_responseHeaders release];
    [super dealloc];
}
#endif

- (void) openStream {
    FLReleaseWithNil(_responseHeaders);
    [super openStream];
}


- (NSString*) identifier {
    return _requestHeaders.requestURL.absoluteString;
}

- (CFReadStreamRef) allocReadStreamRef {

#if TRACE
    FLLog(@"connecting to %@", _requestHeaders.requestURL)
#endif

    if(_bodyStream) {
        return CFReadStreamCreateForStreamedHTTPRequest(kCFAllocatorDefault,
            _requestHeaders.messageRef, FLBridge(CFReadStreamRef, _bodyStream));
    }
    
    return CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, _requestHeaders.messageRef);
}

+ (id) httpStream:(FLHttpMessage*) request
   withBodyStream:(NSInputStream*) bodyStream
   streamSecurity:(FLNetworkStreamSecurity) security
        inputSink:(id<FLInputSink>) inputSink {
    
    return FLAutorelease([[[self class] alloc] initWithHttpMessage:request 
                                                    withBodyStream:bodyStream 
                                                    streamSecurity:security 
                                                         inputSink:inputSink]);
}            

- (BOOL) hasResponseHeaders {
    return _responseHeaders != nil;
}

- (FLHttpMessage*) readResponseHeaders {
    if(!_responseHeaders && self.streamRef) {
        CFHTTPMessageRef ref = (CFHTTPMessageRef)CFReadStreamCopyProperty(self.streamRef, kCFStreamPropertyHTTPResponseHeader);
        @try {
            if(ref && CFHTTPMessageIsHeaderComplete(ref)) {
                _responseHeaders = [[FLHttpMessage alloc] initWithHttpMessageRef:ref];
                [self didOpen];
            }
        }
        @finally {
            if(ref) {
                CFRelease(ref);
            }
        }
    }
    return _responseHeaders;
}

- (void) encounteredError:(NSError*) error {
    [self readResponseHeaders];
    [super encounteredError:error];
    [self closeStream];
}

- (void) encounteredEnd {
    [self readResponseHeaders];
    [super encounteredEnd];
}

- (void) encounteredBytesAvailable {
    [self readResponseHeaders];
    [super encounteredBytesAvailable];
}

- (unsigned long) bytesWritten {
    if(self.streamRef) {
        NSNumber* number = FLAutorelease(FLBridgeTransfer(NSNumber*,
            CFReadStreamCopyProperty(self.streamRef, kCFStreamPropertyHTTPRequestBytesWrittenCount)));
        
        return number.unsignedLongValue;
    }
    return 0;
}

- (FLPromisedResult) createSuccessfulResult:(id<FLInputSink>) responseData {
    return [FLHttpStreamSuccessfulResult httpStreamSuccessfulResult:[self readResponseHeaders] responseData:responseData];
}

@end





