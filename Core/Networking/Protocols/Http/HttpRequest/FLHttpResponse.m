//
//  FLHttpResponse.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/23/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpResponse.h"
#import "FLHttpMessage.h"
#import "FLHttpRequestByteCount.h"

@interface FLHttpResponse ()
@property (readwrite, strong, nonatomic) NSDictionary* responseHeaders;
@property (readwrite, assign, nonatomic) NSInteger responseStatusCode;
@property (readwrite, strong, nonatomic) NSString* responseStatusLine;
@property (readwrite, strong, nonatomic) FLHttpResponse* redirectedFrom;
@property (readwrite, strong, nonatomic) NSURL* requestURL;
@property (readwrite, strong, nonatomic) id<FLInputSink> responseData;
@property (readwrite, strong, nonatomic) NSError* error;
@property (readwrite, strong, nonatomic) FLHttpRequestByteCount* byteCount;
@end

@implementation FLHttpResponse

@synthesize responseStatusCode = _responseStatusCode;
@synthesize responseHeaders = _responseHeaders;
@synthesize responseStatusLine = _responseStatusLine;
@synthesize requestURL = _requestURL;
@synthesize redirectedFrom = _redirectedFrom;
@synthesize responseData = _inputSink;
@synthesize error = _error;
@synthesize byteCount = _byteCount;

- (id) initWithRequestURL:(NSURL*) url 
                  headers:(FLHttpMessage*) headers 
           redirectedFrom:(FLHttpResponse*) redirectedFrom 
                inputSink:(id<FLInputSink>) inputSink {

    if((self = [super init])) {
        self.requestURL = url;
        self.redirectedFrom = redirectedFrom;
        self.responseHeaders = headers.allHeaders;
        self.responseStatusLine = headers.responseStatusLine;
        self.responseStatusCode = headers.responseStatusCode;
        self.responseData = inputSink;
        
        NSInteger statusCode = self.responseStatusCode;
        if(FLHttpServerResponseCodeIsError(statusCode)) {
            self.error = [NSError httpServerError:statusCode statusLine:self.responseStatusLine];
        }
    }
    
    return self;
}

+ (id) httpResponse:(NSURL*) requestURL 
            headers:(FLHttpMessage*) headers 
     redirectedFrom:(FLHttpResponse*) redirectedFrom 
                inputSink:(id<FLInputSink>) inputSink {

    return FLAutorelease([[[self class] alloc] initWithRequestURL:requestURL 
                                                          headers:(FLHttpMessage*) headers 
                                                   redirectedFrom:redirectedFrom 
                                                        inputSink:inputSink]);
}

#if FL_MRC
- (void) dealloc {
    [_byteCount release];
    [_inputSink release];
    [_redirectedFrom release];
    [_requestURL release];
    [_responseStatusLine release];
    [_responseHeaders release];
    [_error release];
    [super dealloc];
}
#endif

- (NSString*) valueForHeader:(NSString*) header {
    return [_responseHeaders objectForKey:header];
}

- (NSString*) description {
//    NSMutableString* string = [self headers]
    
    NSMutableString* desc = [NSMutableString stringWithFormat:@"%@\r\n", [super description]];
    [desc appendFormat:@"request URL:%@\r\n",  [_requestURL description]];
    [desc appendFormat:@"response status line: \"%@\"\r\nresponse code: %d\r\n", _responseStatusLine, (int)_responseStatusCode];
    [desc appendFormat:@"response headers: %@\r\n",  [_responseHeaders description]];
    
    if(self.redirectedFrom) {
        [desc appendFormat:@"redirected from: %@\r\n", [self.redirectedFrom description]];
    }

    return desc;
}

- (BOOL) isRedirect {
    return FLHttpServerResponseCodeIsRedirect(self.responseStatusCode);
}        

- (BOOL) isSuccess {
    return FLHttpServerResponseCodeIsSuccess(self.responseStatusCode);
}

- (BOOL) isError {
    return FLHttpServerResponseCodeIsError(self.responseStatusCode);
}

- (BOOL) isServerError {
    return FLHttpServerResponseCodeIsServerError(self.responseStatusCode);
}

- (BOOL) isClientError {
    return FLHttpServerResponseCodeIsClientError(self.responseStatusCode);
}

- (BOOL) wantsRedirect {
    return self.isRedirect && FLStringIsNotEmpty([self valueForHeader:@"Location"]); 
}

- (NSURL*) redirectURL {
    return [NSURL URLWithString:[self valueForHeader:@"Location"] relativeToURL:self.requestURL];
}
@end
