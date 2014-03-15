//
//  FLAssertionFailureErrorDomain.h
//  FishLampSync
//
//  Created by Mike Fullerton on 11/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"
#import "FLErrorDomainInfo.h"
#import "FishLampCoreErrorDomain.h"

extern NSString* const FLAssertionFailureErrorDomain;

typedef enum {
    FLAssertionFailureNone,
    FLAssertionFailureCondition,
    FLAssertionFailureAreEqual,
    FLAssertionFailureAreNotEqual,
    FLAssertionFailureIsNil,
    FLAssertionFailureIsNotNil,
    FLAssertionFailureIsEmpty,
    FLAssertionFailureIsNotEmpty,
    FLAssertionFailureIsTrue,
    FLAssertionFailureIsFalse,
    FLAssertionFailureIsWrongType,

// logic
    FLAssertionFailureUnsupportedInit,
    FLAssertionFailureNotImplemented,
    FLAssertionFailureFixMe,
    FLAssertionFailureBug,
    FLAssertionFailureRequiredOverride
} FLAssertionFailure;

