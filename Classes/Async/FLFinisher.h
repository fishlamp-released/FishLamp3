//
//  FLFinisher.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLAsyncBlockTypes.h"
#import "FLPromisedResult.h"
#import "FLPromise.h"
#import "FLQueueableAsyncOperation.h"

@protocol FLFinisherDelegate;

// finisher callback fire on the main thread IF the finisher was created on the main thread.
// otherwise they fire in whatever thread setFinished is called on.

@interface FLFinisher : FLPromise<FLQueueableAsyncOperation> {
@private
#if DEBUG
    NSTimeInterval _birth;
#endif
    FL_WEAK id<FLFinisherDelegate> _delegate;
}

@property (readwrite, assign) id<FLFinisherDelegate> delegate;

+ (id) finisher;
+ (id) finisherWithBlock:(fl_completion_block_t) completion;
+ (id) finisherWithTarget:(id) target action:(SEL) action;

// notify finished
- (void) setFinishedWithResult:(FLPromisedResult) result;

// convienience methods - these call setFinishedWithResult:error
- (void) setFinished;
- (void) setFinishedWithCancel;
@end

@interface FLAutoFinisher : FLFinisher {
@private
    BOOL _finishOnMainThread;
}

// this is called at init time, but you can call it later if needed to override initial finding.
- (void) determineCallbackThread;

@end

// will always fire on main thread
@interface FLMainThreadFinisher : FLFinisher
@end


@protocol FLFinisherDelegate <NSObject>
- (id) finisher:(FLFinisher*) finisher didFinishWithResult:(id) result;
@end