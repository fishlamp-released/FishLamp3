//
//  FLFailureErrorDomain.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLErrorDomainInfo.h"

extern NSString* const FLErrorDomain;

typedef NS_ENUM(NSInteger, FLErrorDomainError) {
    FLErrorCodeCancel = kCFURLErrorCancelled,
    FLErrorCodeTimedOut = kCFURLErrorTimedOut,
    
    FLErrorCodeNone = noErr,
    FLAbortErrorCode,
    FLErrorEmptyStringErrorCode,
    FLErrorUnexpectedNilObject,
    FLErrorInvalidFolder,
    FLErrorInvalidName,
    FLErrorNoDataToSave,
    FLErrorDuplicateItemErrorCode,
    FLErrorUnknownEnumValue,
    FLErrorConditionFailed,
    FLErrorTooManyEnumsErrorCode,
	FLActionErrorCodeConfigScope,
	FLActionErrorCodeInvalidContext,
    FLErrorResultFailed,
    FLUnhandledServiceRequestErrorCode,
    FLUnknownExceptionErrorCode
} FLErrorCode;

//@interface FLFrameworkErrorDomainInfo : NSObject<FLErrorDomainInfo>
//+ (id) frameworkErrorDomainInfo;
//@end


/*
// sdk files with error codes:
https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ErrorHandlingCocoa/ErrorObjectsDomains/ErrorObjectsDomains.html

errno.h
MacErrors.h
CFNetworkErrors.h
NSErrors.h
FoundationErrors.h
SecureTransport.h
kern_return.h
*/
