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

@implementation FLFinisher

- (id) init {
    self = [super init];
    if(self) {
#if DEBUG
        _birth = [NSDate timeIntervalSinceReferenceDate];
#endif

        _finishOnMainThread = [NSThread isMainThread];
    }
    return self;
}

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

#if DEBUG
#if FL_MRC
- (void) dealloc {
//#if DEBUG
//    FLLog(@"finisher lifespan: %0.2f", [NSDate timeIntervalSinceReferenceDate] - _birth);
//#endif
	[super dealloc];
}
#endif
#endif

- (void) setFinishedWithResult:(FLPromisedResult) result {

    @try {

        if(_finishOnMainThread && ![NSThread isMainThread]) {
            [self performSelectorOnMainThread:@selector(setFinishedWithResult:)
                                   withObject:result
                                waitUntilDone:NO];
            return;
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

@end

