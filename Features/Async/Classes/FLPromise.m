//
//  FLPromise.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/27/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPromise_Internal.h"
#import "NSError+FLFailedResult.h"
#import "FishLampSimpleLogger.h"

@interface FLPromise ()
@property (readwrite, strong) FLPromisedResult result;
@property (readwrite, copy) fl_completion_block_t completion;
@property (readwrite, assign) BOOL isFinished;
@end

#define CHECK_COUNT 0

#if CHECK_COUNT
static NSInteger s_promiseCount = 0;
static NSInteger s_max = 0;
#endif

@implementation FLPromise

@synthesize nextPromise = _nextPromise;
@synthesize result = _result;
@synthesize completion = _completion;
@synthesize isFinished = _isFinished;


- (id) init {
    self = [super init];
    if(self) {
        _semaphore = dispatch_semaphore_create(0);

#if CHECK_COUNT
        NSInteger c = s_promiseCount++;
        if(s_promiseCount > s_max) {
            s_max = s_promiseCount;
        }
        if(c % 10 == 0) {
            FLLog(@"++ promise count: %ld, max: %ld", c, s_max);
        }
        if(c > 2000) {
//            int i = 0;
        }
#endif
    }

    return self;
}

- (id) initWithCompletion:(fl_completion_block_t) completion {
    
    self = [self init];
    if(self) {
        _completion = [completion copy];
    }
    return self;
}

- (id) initWithTarget:(id) target action:(SEL) action {
    self = [self init];
    if(self) {
        _target = target;
        _action = action;
    }
    return self;
}

- (id) initWithPromise:(FLPromise*) promise {	
	self = [self init];
	if(self) {
        self.nextPromise = promise;
    }
	return self;
}

+ (id) promise:(id) target action:(SEL) action {
    return FLAutorelease([[[self class] alloc] initWithTarget:target action:action]);
}


- (void) dealloc {
#if CHECK_COUNT
    NSInteger c = --s_promiseCount;
    if(c % 10 == 0 || s_promiseCount == 0) {
       FLLog(@"-- promise count: %ld, max: %ld", c, s_max);
    }
#endif

    if(_semaphore) {
        FLDispatchRelease(_semaphore);
    }

#if FL_MRC
    [_nextPromise release];
    [_completion release];
    [_result release];
    [super dealloc];
#endif
}

+ (id) promise {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) promise:(fl_completion_block_t) completion {
    return FLAutorelease([[[self class] alloc] initWithCompletion:completion]);
}

- (FLPromiseState) state {
    if(self.isFinished) {
        return [self.result isError] ? FLPromiseStateRejected : FLPromiseStateResolved;
    }

    return FLPromiseStateUnfufilled;
}

- (FLPromisedResult) waitUntilFinished {
    
    FLRetainObject(self);
    
    @try {
        if([NSThread isMainThread]) {
        // this may not work in all cases - e.g. some iOS apis expect to be called in the main thread
        // and this will cause endless blocking, unfortunately. I've seen this is the AssetLibrary sdk.
            while(!self.isFinished) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
            }
        } 
        else {

            FLTrace(@"waiting for semaphore for %X, thread %@", (unsigned int) _semaphore, [NSThread currentThread]);

            dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);

            FLTrace(@"finished waiting for %X", (unsigned int) _semaphore);
        } 
    }
    @finally {
        FLAutoreleaseObject(self);
    }   

    FLAssertNotNil(self.result, @"result should not be nil!!");

    return self.result;
}

- (void) fufillPromiseWithResult:(FLPromisedResult) result {

    FLAssertNonZeroNumber(_semaphore, @"already finished");
    FLAssertNil(self.result, @"should not already have result");

    if(result == nil) {
       result = [NSError failedResultError];
    }

    self.result = result;

    if(_completion) {
        _completion(self.result);
        FLReleaseBlockWithNil(_completion);
    }

    FLPerformSelector1(_target, _action, self.result);
    _target = nil;
    _action = nil;

    FLTrace(@"releasing semaphore for %X, ont thread %@",
                (unsigned int) _semaphore,
                [NSThread currentThread]);

    self.isFinished = YES;
    dispatch_semaphore_signal(_semaphore);
}

- (void) addPromise:(FLPromise*) promise {
    FLPromise* walker = self;
    while(walker.nextPromise) {
        walker = walker.nextPromise;
    }
    walker.nextPromise = promise;
}

- (FLPromise*) addPromise {
    FLPromise* promise = [FLPromise promise];
    [self addPromise:promise];
    return promise;
}

- (FLPromise*) addPromiseWithBlock:(fl_completion_block_t) completion {
    FLPromise* promise = [FLPromise promise:completion];
    [self addPromise:promise];
    return promise;
}

- (FLPromise*) addPromiseWithTarget:(id) target action:(SEL) action {
    FLPromise* promise = [FLPromise promise:target action:action];
    [self addPromise:promise];
    return promise;
}



@end
