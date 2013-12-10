//
//  FLHttpMessage.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/22/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpMessage.h"
#import "FLCoreFoundation.h"

@implementation FLHttpMessage

@synthesize messageRef = _message;

- (id) init {
    if((self = [super init])) {
        _message = CFHTTPMessageCreateEmpty( kCFAllocatorDefault, TRUE );
    }

    return self;
}

- (id) initWithURL:(NSURL*) url
     httpMethod:(NSString*) httpMethod {
    
    if((self = [super init])) {
        if(!httpMethod || httpMethod.length == 0) {
            httpMethod = @"GET";
        }   
        
        _message = CFHTTPMessageCreateRequest(kCFAllocatorDefault, 
            FLBridge(void*,httpMethod), FLBridge(void*,url), kCFHTTPVersion1_1);
            
        FLConfirmNotNil(_message);    
    }
    return self;
}

- (BOOL) isHeaderComplete {
    return CFHTTPMessageIsHeaderComplete(_message);
}

- (NSData*) bodyData {
    return FLAutorelease(FLBridgeTransfer(NSData*,CFHTTPMessageCopyBody(_message)));
}

- (void) setBodyData:(NSData*) bodyData {
    CFHTTPMessageSetBody(_message, FLBridge(void*,bodyData));
}

- (void) setHeader:(NSString*) header value:(NSString*) value {
    CFHTTPMessageSetHeaderFieldValue(_message, FLBridge(void*,header), FLBridge(void*,value));
}

- (NSString*) valueForHeader:(NSString*) header {
    return FLAutorelease(FLBridgeTransfer(NSString*,
                CFHTTPMessageCopyHeaderFieldValue(_message, FLBridge(void*,header))));
}

- (NSString*) httpVersion {
    return FLAutorelease(FLBridgeTransfer(NSString*,CFHTTPMessageCopyVersion(_message)));
}

- (NSDictionary*) allHeaders {
    return FLAutorelease(FLBridgeTransfer(NSDictionary*,CFHTTPMessageCopyAllHeaderFields(_message)));
}

- (void) dealloc {
    FLReleaseCRef_(_message);
    FLSuperDealloc();
}

- (id) initWithHttpMessageRef:(CFHTTPMessageRef) ref {
    if((self = [super init])) {
        if(!ref) {
            return nil;
        }
        _message = (CFHTTPMessageRef) CFRetain(ref);
    }
    
    return self;
} 

+ (id) httpMessageWithHttpMessageRef:(CFHTTPMessageRef) ref {
    return FLAutorelease([[[self class] alloc] initWithHttpMessageRef:ref]);
}

+ (id) httpMessageWithURL:(NSURL*) url httpMethod:(NSString*) httpMethodOrNil {
    return FLAutorelease([[[self class] alloc] initWithURL:url httpMethod:httpMethodOrNil]);
}

- (id)copyWithZone:(NSZone *)zone {
    CFHTTPMessageRef ref = CFHTTPMessageCreateCopy(kCFAllocatorDefault, _message);
    if(ref) {
        FLHttpMessage* wrapper = [[FLHttpMessage alloc] initWithHttpMessageRef:ref];
        CFRelease(ref);
        return wrapper;
    }
    return nil;
}

- (BOOL) isRequest {
    return CFHTTPMessageIsRequest(_message);
}

- (NSURL*) requestURL {
    return FLAutorelease(FLBridgeTransfer(NSURL*,CFHTTPMessageCopyRequestURL(_message)));
}

- (NSString*) httpMethod {
    return FLAutorelease(FLBridgeTransfer(NSString*,CFHTTPMessageCopyRequestMethod(_message)));
}

- (NSInteger) responseStatusCode {
    return CFHTTPMessageGetResponseStatusCode(_message);
}

- (NSString*) responseStatusLine {
    return FLAutorelease(FLBridgeTransfer(NSString*,CFHTTPMessageCopyResponseStatusLine(_message)));
}

- (void) setHeaders:(NSDictionary*) headers {
    for(NSString* header in headers) {
        [self setHeader:header value:[headers objectForKey:header]];
    }
}

@end
