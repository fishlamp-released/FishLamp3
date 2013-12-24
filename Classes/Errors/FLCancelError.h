//
//  FLCancelError.h
//  FishLampCore
//
//  Created by Mike Fullerton on 3/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"
#import "FLErrorException.h"
#import "FLExceptions.h"

extern NSString* const FLCancelExceptionName;

//@interface FLCancelError : NSError
//+ (id) cancelError;
//@end
//
//@interface FLCancelException : FLErrorException
//+ (id) cancelException;
//@end

@interface NSError (FLCancelling)
+ (NSError*) cancelError;
@property (readonly, nonatomic, assign) BOOL isCancelError;
@end

#define FLThrowCancel() \
            FLThrowErrorCodeWithComment(FLErrorDomain, FLErrorCodeCancel, @"Cancelled")

