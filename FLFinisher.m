//
//  FLFinisher.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/18/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFinisher.h"
#import "FLPromise.h"
#import "NSError+FLFailedResult.h"
#import "FLSuccessfulResult.h"

#import "FLLog.h"

@interface FLPromise ()
- (void) fufillPromiseWithResult:(FLPromisedResult) result;
@property (readwrite, strong) FLPromise* nextPromise;
@end

@interface FLFinisher ()
- (id) initWithPromise:(FLPromise*) promise;
@end

@implementation FLFinisher 

- (id) init {	
    return [self initWithPromise:nil];
}

- (id) initWithPromise:(FLPromise*) promise {	
	self = [super init];
	if(self) {
        self.nextPromise = promise;

#if DEBUG
        _birth = [NSDate timeIntervalSinceReferenceDate];
#endif
	}
	return self;
}

+ (id) finisher {
    return FLAutorelease([[[self class] alloc] initWithPromise:nil]);
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
	[super dealloc];
}
#endif

- (void) willFinishWithResult:(FLPromisedResult) result {
}

- (void) didFinishWithResult:(FLPromisedResult) result {
}

- (void) setFinishedWithResult:(FLPromisedResult) result {

    @try {
        if(!result) {
            result = FLFailedResult;
        }
        
        [self willFinishWithResult:result];

        FLPromise* promise = FLRetainWithAutorelease(self);
        while(promise) {

            FLPromise* nextPromise = FLRetainWithAutorelease(promise.nextPromise);
            promise.nextPromise = nil;

            [promise fufillPromiseWithResult:result];

            promise = nextPromise;
        }


        [self didFinishWithResult:result];
    }
    @catch(NSException* ex) {
        FLLog(@"%@", [ex description])
    }
}

- (void) setFinished {
    [self setFinishedWithResult:FLSuccessfulResult];
}

- (void) setFinishedWithCancel {
    [self setFinishedWithResult:[NSError cancelError]];
}

@end

@implementation FLForegroundFinisher

- (void) setFinishedWithResult:(FLPromisedResult) result {
    if([NSThread isMainThread]) {
        [super setFinishedWithResult:result];
    }
    else {
        [self performSelectorOnMainThread:@selector(setFinishedWithResult:) withObject:result waitUntilDone:NO];
    }
}

@end
