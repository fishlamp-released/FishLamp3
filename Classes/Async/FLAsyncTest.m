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
@property (readwrite, assign) BOOL isFinished;
@property (readwrite, assign) BOOL isStarted;
@property (readwrite, assign) NSTimer* timer;
@property (readwrite, copy) FLAsyncTestTimedOutBlock timedOutBlock;
@property (readwrite, copy) FLAsyncTestBlock finishValidator;
@end

@implementation FLAsyncTest

@synthesize error =_error;
@synthesize isFinished = _isFinished;
@synthesize timer =_timer;
@synthesize isStarted = _isStarted;
@synthesize timedOutBlock = _timedOutBlock;
@synthesize finishValidator = _finishValidator;

//@synthesize delegate = _delegate;


- (id) init {
    return [self initWithTimeout:0 timedOutBlock:nil];
}

- (id) initWithTimeout:(NSTimeInterval) timeout timedOutBlock:(FLAsyncTestTimedOutBlock) timeoutBlock {
	self = [super init];
	if(self) {
        _semaphor = dispatch_semaphore_create(0);
        _timeout = timeout;

        if(timeoutBlock) {
            _timedOutBlock = [timeoutBlock copy];
        }
    }
	return self;
}

+ (id) asyncTestWithTimeout:(NSTimeInterval) timeout timedOutBlock:(FLAsyncTestTimedOutBlock) timeoutBlock {
    return FLAutorelease([[[self class] alloc] initWithTimeout:timeout timedOutBlock:timeoutBlock]);
}

+ (id) asyncTest {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) stopTimer {
    if(_timer) {
        [_timer invalidate];
    }
    self.timer = nil;
}

- (void) dealloc {
    [_timer invalidate];

#if FL_MRC
    [_finishValidator release];
    [_timedOutBlock release];
    [_timer release];
    [_error release];
    if(_semaphor) {
        FLDispatchRelease(_semaphor);
    }
	[super dealloc];
#endif
}

- (void) timerTimedOut:(NSTimer*) timer {
    @synchronized(self) {
        self.error = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorTimedOut userInfo:nil];
    }
}

- (void) start {
    @synchronized(self) {
        if(!self.isStarted) {
            self.isStarted = YES;
            if(_timeout > 0) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeout
                                                              target:self
                                                            selector:@selector(timerTimedOut:)
                                                            userInfo:nil
                                                             repeats:NO];
            }
        }
    }
}

- (void) waitUntilFinished {

    if([NSThread isMainThread]) {
    // this may not work in all cases - e.g. some iOS apis expect to be called in the main thread
    // and this will cause endless blocking, unfortunately. I've seen this is the AssetLibrary sdk.
        while(!self.isFinished) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
        }
    }
    else if(_semaphor) {
        dispatch_semaphore_wait(_semaphor, DISPATCH_TIME_FOREVER);
    }
}

- (void) timerDidTimeout:(FLTimer*) timer {
    @synchronized(self) {
        if(self.timedOutBlock) {
            self.timedOutBlock(self);
        }
        else {
            self.error = [NSError timeoutError];
        }
    }
}

- (void) verifyAsyncResults:(FLAsyncTestBlock) block {
    @try {
        if(block) {
            block();
        }
    }
    @catch(NSException* ex) {
        [self setFinishedWithError:ex.error];
    }
}

- (void) didFinish {
    [self stopTimer];
    self.isFinished = YES;

//        [self.delegate asyncTestDidFinish:self];

    if(!self.error && self.finishValidator) {
        @try {
            self.finishValidator();
        }
        @catch(NSException* ex) {
            self.error = ex.error;
        }

    }

    if(_semaphor) {
        dispatch_semaphore_signal(_semaphor);
    }

}

- (void) validateResultsWhenFinished:(FLAsyncTestBlock) finishedValidator {
    self.finishValidator = finishedValidator;
}

- (void) setFinishedWithBlock:(FLAsyncTestBlock) block {

    @synchronized(self) {
        @try {
            if(block) {
                block();
            }
        }
        @catch(NSException* ex) {
            self.error = ex.error;
        }

        [self didFinish];
    }
}

- (void) setFinished {
    @synchronized(self) {
        [self didFinish];
    }
}

- (void) setFinishedWithError:(NSError*) error {
    @synchronized(self) {
        self.error = error;
        [self didFinish];
    }
}

@end