//
//  FLFinisher.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFinisher.h"
#import "FLPromise_Internal.h"
#import "NSError+FLFailedResult.h"
#import "FLSuccessfulResult.h"

#import "FishLampSimpleLogger.h"

#import "FLFinisher_Internal.h"

@interface FLFinisher ()
@end

@implementation FLFinisher

@synthesize asyncQueueBlock =_asyncQueueBlock;
@synthesize asyncQueueFinisherBlock = _asyncQueueFinisherBlock;
@synthesize delegate = _delegate;

#if DEBUG
- (id) init {
    self = [super init];
    if(self) {
        _birth = [NSDate timeIntervalSinceReferenceDate];
    }
    return self;
}
#endif

+ (id) finisher {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) finisherWithBlock:(fl_completion_block_t) completion {
    return FLAutorelease([[[self class] alloc] initWithCompletion:completion]);
}

+ (id) finisherWithTarget:(id) target action:(SEL) action {
    return FLAutorelease([[[self class] alloc] initWithTarget:target action:action]);
}

+ (id) finisherWithPromise:(FLPromise*) promise {
    return FLAutorelease([[[self class] alloc] initWithPromise:promise]);
}

#if FL_MRC
- (void) dealloc {
//#if DEBUG
//    FLLog(@"finisher lifespan: %0.2f", [NSDate timeIntervalSinceReferenceDate] - _birth);
//#endif

    [_asyncQueueBlock release];
    [_asyncQueueFinisherBlock release];

	[super dealloc];
}
#endif

- (void) setFinishedWithResult:(FLPromisedResult) aResult {

    @try {
        id result = nil;

        if(_delegate) {
            result = [_delegate finisher:self didFinishWithResult:aResult];
        }
        else {
            result = aResult;
        }

        if(!result) {
            result = FLFailedResult;
        }

        FLPromise* promise = FLRetainWithAutorelease(self);
        while(promise) {

            FLPromise* nextPromise = FLRetainWithAutorelease(promise.nextPromise);
            promise.nextPromise = nil;

            [promise fufillPromiseWithResult:result];

            promise = nextPromise;
        }
    }
    @catch(NSException* ex) {
        FLLog(@"%@", [ex description]);
    }
}

- (void) setFinished {
    [self setFinishedWithResult:FLSuccessfulResult];
}

- (void) setFinishedWithCancel {
    [self setFinishedWithResult:[NSError cancelError]];
}

- (void) startAsyncOperationInQueue:(id<FLAsyncQueue>) queue finisher:(FLFinisher *)finisher {

    @try {
        FLAssertNotNil(queue);
        FLAssertNotNil(finisher);

        if(_asyncQueueBlock) {
            _asyncQueueBlock();
            [finisher setFinished];
        }
        else if (_asyncQueueFinisherBlock) {
            _asyncQueueFinisherBlock(finisher);
        }
        else {
            [finisher setFinished];
        }
    }
    @finally {
        FLReleaseBlockWithNil(_asyncQueueBlock);
        FLReleaseBlockWithNil(_asyncQueueFinisherBlock);
    }
}

- (void) runSynchronousOperationInQueue:(id<FLAsyncQueue>) queue
                               finisher:(FLFinisher *)finisher {

    FLAssertNotNil(queue);
    FLAssertNotNil(finisher);

    [self startAsyncOperationInQueue:queue finisher:finisher];
    [finisher waitUntilFinished];
}


@end

@implementation FLAutoFinisher

- (id) init {	
	self = [super init];
	if(self) {
        [self determineCallbackThread];
	}
	return self;
}

- (void) determineCallbackThread {
    _finishOnMainThread = [NSThread isMainThread];
}

- (void) setFinishedWithResult:(FLPromisedResult) result {

    if(_finishOnMainThread && ![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(setFinishedWithResult:)
                               withObject:result
                            waitUntilDone:NO];
        return;
    }

    [super setFinishedWithResult:result];
}

@end

@implementation FLMainThreadFinisher

- (void) setFinishedWithResult:(FLPromisedResult) result {

    if(![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(setFinishedWithResult:)
                               withObject:result
                            waitUntilDone:NO];
        return;
    }

    [super setFinishedWithResult:result];
}
@end