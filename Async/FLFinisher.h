//
//  FLFinisher.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLAsyncBlockTypes.h"
#import "FLPromisedResult.h"
#import "FLPromise.h"

@protocol FLFinisherDelegate;

@interface FLFinisher : FLPromise {
@private
#if DEBUG
    NSTimeInterval _birth;
#endif
}

+ (id) finisher;
+ (id) finisherWithBlock:(fl_completion_block_t) completion;
+ (id) finisherWithTarget:(id) target action:(SEL) action;

// notify finished
- (void) setFinishedWithResult:(FLPromisedResult) result;

// convienience methods - these call setFinishedWithResult:error
- (void) setFinished;
- (void) setFinishedWithCancel;

// oprtional overrides
- (void) willFinishWithResult:(FLPromisedResult) result;
- (void) didFinishWithResult:(FLPromisedResult) result;
@end

@interface FLForegroundFinisher : FLFinisher
@end
