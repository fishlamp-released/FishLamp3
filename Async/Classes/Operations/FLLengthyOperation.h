//
//  FLLengthyOperation.h
//  Pods
//
//  Created by Mike Fullerton on 2/17/14.
//
//

#import "FLOperation.h"

@class FLTimer;

@interface FLLengthyOperation : FLOperation {
@private
    FLTimer* _timer;
}

@property (readwrite, assign) NSTimeInterval timeoutInterval;

- (void) updateActivityTimestamp;

- (void) startTimeoutTimer;
- (void) stopTimeoutTimer;

// optional override
- (void) operationDidTimeout;

@end
