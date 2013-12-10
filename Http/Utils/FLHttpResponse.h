//
//  FLHttpResponse.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/23/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLInputSink.h"
#import "FLHttpErrors.h"

@class FLHttpRequestByteCount;
@class FLHttpMessage;

@interface FLHttpResponse : NSObject {
@private
    NSURL* _requestURL;
    NSInteger _responseStatusCode;
    NSString* _responseStatusLine;
    NSDictionary* _responseHeaders;
    FLHttpResponse* _redirectedFrom;
    id<FLInputSink> _inputSink;
    NSError* _error;
    FLHttpRequestByteCount* _byteCount;
}
@property (readonly, strong, nonatomic) NSURL* requestURL;
@property (readonly, strong, nonatomic) NSDictionary* responseHeaders;
@property (readonly, strong, nonatomic) NSString* responseStatusLine;
@property (readonly, assign, nonatomic) NSInteger responseStatusCode;

@property (readonly, strong, nonatomic) NSError* error;

@property (readonly, assign, nonatomic) BOOL isSuccess;
@property (readonly, assign, nonatomic) BOOL isError;
@property (readonly, assign, nonatomic) BOOL isServerError;
@property (readonly, assign, nonatomic) BOOL isClientError;

// has redirect status code and a "location" header
@property (readonly, assign, nonatomic) BOOL wantsRedirect; 
@property (readonly, assign, nonatomic) BOOL isRedirect;
@property (readonly, strong, nonatomic) FLHttpResponse* redirectedFrom;
@property (readonly, strong, nonatomic) NSURL* redirectURL;

@property (readonly, strong, nonatomic) FLHttpRequestByteCount* byteCount;


+ (id) httpResponse:(NSURL*) requestURL 
            headers:(FLHttpMessage*) headers 
     redirectedFrom:(FLHttpResponse*) redirectedFrom
          inputSink:(id<FLInputSink>) inputSink;

- (id<FLInputSink>) responseData;

- (NSString*) valueForHeader:(NSString*) header;
@end

