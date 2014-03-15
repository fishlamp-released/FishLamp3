//
//  NSError+FLCancel.h
//  FishLampCore
//
//  Created by Mike Fullerton on 3/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"
#import "FishLampExceptions.h"

extern NSString* const FLCancelExceptionName;

@interface NSError (FLCancelling)
+ (NSError*) cancelError;
@property (readonly, nonatomic, assign) BOOL isCancelError;
@end

#define FLThrowCancel() \
            FLThrowErrorCode(FLErrorDomain, FLErrorCodeCancel, @"Cancelled")

