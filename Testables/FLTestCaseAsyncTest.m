//
//  FLTestCaseAsyncTest.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestCaseAsyncTest.h"
#import "FLTimer.h"
#import "FLTestCase.h"

@implementation FLTestCaseAsyncTest
@synthesize finishedBlock = _finishedBlock;
@synthesize finishedStarting = _finishedStarting;

+ (id) testCaseAsyncTest:(FLTestCase*) operation timeout:(NSTimeInterval) timeout{
    return FLAutorelease([[[self class] alloc] initWithOperation:operation timeout:timeout]);
}

- (id) initWithOperation:(FLTestCase*) operation
                 timeout:(NSTimeInterval) timeout{
	self = [super init];
	if(self) {
        _operation = FLRetain(operation);

        _timer = [[FLTimer alloc] initWithTimeout:timeout];
        _timer.delegate = self;
        [_timer startTimer];
	}
	return self;
}

- (void) stopTimer {
    if(_timer) {
        [_timer stopTimer];
    }
}
- (void)dealloc {
    [_timer stopTimer];

#if FL_MRC
    [_timer release];
    [_finishedBlock release];
	[_operation release];
	[super dealloc];
#endif
}

- (void) setTestCaseStarted {
    @synchronized(self) {
        self.finishedStarting = YES;
        if(self.finishedBlock) {
            self.finishedBlock();
            self.finishedBlock = nil;
        }
    }
}

- (void) setFinishedWithFinishedBlock:(dispatch_block_t) finishedBlock {
    @synchronized(self) {
        if(self.finishedStarting) {
            if(finishedBlock) {
                finishedBlock();
            }
        }
        else {
            self.finishedBlock = finishedBlock;
        }
    }
}

- (void) setFinishedWithBlock:(void (^)()) finishBlock {
    FLPrepareBlockForFutureUse(finishBlock);

    __block FLTestCase* testCase = _operation;

    [self setFinishedWithFinishedBlock:^{
        @try {
            if(finishBlock) {
                finishBlock();
            }
            [testCase setFinished];
        }
        @catch(NSException* ex) {
            [testCase setFinishedWithResult:ex.error];
        }
    }];
}

- (void) waitUntilFinished {
//    dispatch_semaphore_wait(_semaphor, DISPATCH_TIME_FOREVER); \
//    FLThrowError(self.error);
}

- (void) setFinished {
    __block FLTestCase* testCase = _operation;

    [self setFinishedWithFinishedBlock:^{
        [testCase setFinished];
    }];
}

- (void) setFinishedWithError:(NSError*) error {
    __block FLTestCase* testCase = _operation;

    [self setFinishedWithFinishedBlock:^{
        [testCase setFinishedWithResult:error];
    }];
}

- (void) timerDidTimeout:(FLTimer*) timer {
    FLLog(@"Test timed out: %@", [_operation testCaseName]);
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

@end