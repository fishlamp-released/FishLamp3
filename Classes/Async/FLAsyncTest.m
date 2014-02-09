//
//  FLAsyncTest.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAsyncTest.h"
#import "FLTimer.h"
#import "NSError+FLTimeout.h"

@interface FLAsyncTest ()
@property (readwrite, copy, nonatomic) NSError* error;
@end

@implementation FLAsyncTest

@synthesize error =_error;

- (id) init {
    return [self initWithTimeout:FLTimerDefaultCheckTimestampInterval];
}

- (id) initWithTimeout:(NSTimeInterval) timeout {
	self = [super init];
	if(self) {
        _semaphor = dispatch_semaphore_create(0);
        _timer = [[FLTimer alloc] initWithTimeout:timeout];
        _timer.delegate = self;
        [_timer startTimer];
    }
	return self;
}

+ (id) asyncTestWithTimeout:(NSTimeInterval) timeout {
    return FLAutorelease([[[self class] alloc] initWithTimeout:timeout]);
}

+ (id) asyncTest {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) stopTimer {
    if(_timer) {
        [_timer stopTimer];
    }
}

- (void) dealloc {
    [_timer stopTimer];

#if FL_MRC
    [_timer release];
    [_error release];
    if(_semaphor) {
        FLDispatchRelease(_semaphor);
    }
	[super dealloc];
#endif
}

- (void) waitUntilFinished {
    dispatch_semaphore_wait(_semaphor, DISPATCH_TIME_FOREVER);
    FLThrowError(self.error);
}

- (void) timerDidTimeout:(FLTimer*) timer {
    [self setFinishedWithError:[NSError timeoutError]];
}

- (void) verifyAsyncResults:(dispatch_block_t) block {
    @try {
        if(block) {
            block();
        }
    }
    @catch(NSException* ex) {
        [self setFinishedWithError:ex.error];
    }
}

- (void) setFinishedWithBlock:(void (^)()) block {
    @try {
        if(block) {
            block();
        }
        [self setFinished];
    }
    @catch(NSException* ex) {
        [self setFinishedWithError:ex.error];
    }

    if(_semaphor) {
        dispatch_semaphore_signal(_semaphor);
    }
}

- (void) setFinished {
    [self stopTimer];
    if(_semaphor) {
        dispatch_semaphore_signal(_semaphor);
    }
}

- (void) setFinishedWithError:(NSError*) error {
    self.error = error;
    [self setFinished];
}



@end