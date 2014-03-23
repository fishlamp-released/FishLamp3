//
//  FLHttpErrors.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/17/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

extern NSString* const FLHttpServerErrorDomain;

// http://www.w3schools.com/tags/ref_httpmessages.asp 
// http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html

typedef enum {
    FLHttpServerResponseCodeContinue = 100,
    FLHttpServerResponseCodeSwitchingProtocols = 101,
    FLHttpServerResponseCodeCheckpoint = 103,
} FLHttpServerResponseCodeInfo;    
    
typedef enum {
    FLHttpServerResponseCodeSuccessful = 200,
    FLHttpServerResponseCodeCreated = 201,
    FLHttpServerResponseCodeAccepted = 202,
    FLHttpServerResponseCodeNonAuthoritiveInformation = 203,
    FLHttpServerResponseCodeNoContent = 204,
    FLHttpServerResponseCodeResetContent = 205,
    FLHttpServerResponseCodePartialContent = 206,
} FLHttpServerResponseCodeSuccess;    
    
typedef enum {
    FLHttpServerResponseCodeRedirectMultipleChoices = 300,
    FLHttpServerResponseCodeRedirectMovedPermanently = 301,
    FLHttpServerResponseCodeRedirectFound = 302,
    FLHttpServerResponseCodeRedirectSeeOther = 303,
    FLHttpServerResponseCodeRedirectNotModified = 304,
    FLHttpServerResponseCodeRedirectSwitchProxy = 306,
    FLHttpServerResponseCodeRedirectTemporary = 307,
    FLHttpServerResponseCodeRedirectResumeIncomplete = 308,
} FLHttpServerResponseCodeRedirect;    
    
typedef enum {
    FLHttpServerResponseCodeBadRequest = 400,
    FLHttpServerResponseCodeUnauthorized = 401,
    FLHttpServerResponseCodePaymentRequired = 402,
    FLHttpServerResponseCodeForbidden = 403,
    FLHttpServerResponseCodeNotFound = 404,
    FLHttpServerResponseCodeMethodNotAllowed = 405,
    FLHttpServerResponseCodeNotAcceptable = 406,
    FLHttpServerResponseCodeProxyAuthorizationRequired = 407,
    FLHttpServerResponseCodeRequestTimeout = 408,
    FLHttpServerResponseCodeConflict = 409,
    FLHttpServerResponseCodeGone = 410,
    FLHttpServerResponseCodeLengthRequired = 411,
    FLHttpServerResponseCodePreconditionFailed = 412,
    FLHttpServerResponseCodeRequestEntryTooLarge = 413,
    FLHttpServerResponseCodeRequestURITooLong = 414,
    FLHttpServerResponseCodeUnsupportedMediaType = 415,
    FLHttpServerResponseCodeRequestRangeNotSatisfiable = 416,
    FLHttpServerResponseCodeExpectationFailed = 417,
} FLHttpServerResponseCodeClientError;    
    
typedef enum {    
    FLHttpServerResponseCodeInternalServerError = 500,
    FLHttpServerResponseCodeNotImplemented = 501,
    FLHttpServerResponseCodeBadGateway = 502,
    FLHttpServerResponseCodeServiceUnavailable = 503,
    FLHttpServerResponseCodeGatewayTimeout = 504,
    FLHttpServerResponseCodeHttpVersionNotSupported = 505,
    FLHttpServerResponseCodeNetworkAuthenticationRequired = 511
} FLHttpServerResponseCodeServerError;

NS_INLINE BOOL __FLCodeIsInRange(NSInteger code, NSInteger low, NSInteger range) {
    return code >= low && code < (low + range);
}

#define FLHttpServerResponseCodeIsSuccess(__CODE__) \
    __FLCodeIsInRange(__CODE__, FLHttpServerResponseCodeSuccessful, 100)

#define FLHttpServerResponseCodeIsRedirect(__CODE__) \
    __FLCodeIsInRange(__CODE__, FLHttpServerResponseCodeRedirectMultipleChoices, 100)

#define FLHttpServerResponseCodeIsClientError(__CODE__) \
    __FLCodeIsInRange(__CODE__, FLHttpServerResponseCodeBadRequest, 100)

#define FLHttpServerResponseCodeIsServerError(__CODE__) \
    __FLCodeIsInRange(__CODE__, FLHttpServerResponseCodeInternalServerError, 100)
    
#define FLHttpServerResponseCodeIsError(__CODE__) \
    __FLCodeIsInRange(__CODE__, FLHttpServerResponseCodeBadRequest, 200)

//extern NSString* FLStringFromHttpServerStatusResponseCode(NSInteger responseCode);
//    
    
@interface NSError (FLHttpServerResponseCode)
+ (NSError*) httpServerError:(NSInteger) responseCode statusLine:(NSString*) statusLine;
- (BOOL) isHttpServerError;
@end    