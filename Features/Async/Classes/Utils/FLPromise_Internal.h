//
//  FLPromise_Internal.h
//  FishLamp
//
//  Created by Mike Fullerton on 1/5/14.
//  Copyright (c) 2014 Mike Fullerton. All rights reserved.
//

#import "FLPromise.h"

@interface FLPromise ()
- (void) fufillPromiseWithResult:(FLPromisedResult) result;
@property (readwrite, strong) FLPromise* nextPromise;
@end
