//
//  FLOperation.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/29/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOperation.h"
#import "FLAsyncQueue.h"

#import "FLFinisher.h"
#import "NSError+FLFailedResult.h"
#import "FLSuccessfulResult.h"
#import "FLOperationContext.h"

#import "FishLampSimpleLogger.h"

@interface FLOperation ()
@property (readwrite, assign, getter=wasCancelled) BOOL cancelled;
@end

@interface FLOperationContext (Protected)
- (void) removeOperation:(FLOperation*) operation;
@end

@interface FLOperationFinisher : FLFinisher {
@private
    __unsafe_unretained FLOperation* _operation;
}
@property (readwrite, assign, nonatomic) FLOperation* operation;

- (id) initWithOperation:(FLOperation*) operation completion:(fl_completion_block_t) completion;

@end

@implementation FLOperation
@synthesize context = _context;
@synthesize cancelled = _cancelled;
@synthesize operationStarter = _operationStarter;

#if FL_MRC
- (void) dealloc {
#if EXPERIMENTAL
    [_prerequisites release];
#endif
	[super dealloc];
}
#endif

- (FLPromisedResult) runSynchronously {

    FLLog(@"%@ operation did nothing, you must override startOperation or runSynchronously.", NSStringFromClass([self class]));

    return FLSuccessfulResult;
}

- (void) startOperation:(FLFinisher*) finisher {

    FLAssertNotNil(finisher);

    id result = nil;

    @try {
        [self abortIfNeeded];
        result = [self runSynchronously];
    }
    @catch(NSException* ex) {
        result = ex.error;
        FLAssertNotNil(result);
    }
    
    if(self.wasCancelled) {
        result = [NSError cancelError];
    }
    
    if(!result) {
        result = [NSError failedResultError];
    }
    
    [finisher setFinishedWithResult:result];
}

- (id) willFinishWithResult:(id) result {
    return result;
}

- (void) didFinishWithResult:(FLPromisedResult) result {
}

- (id) finisher:(FLFinisher*) finisher didFinishWithResult:(id) result {

    id newResult = [self willFinishWithResult:result];

    [self didFinishWithResult:newResult];
    self.context = nil;
    self.cancelled = NO;

    return newResult;
}

- (void) startAsyncOperationInQueue:(id<FLAsyncQueue>) asyncQueue
                           finisher:(FLFinisher*) finisher {

    @try {
        FLAssertNotNil(asyncQueue);
        FLAssertNotNil(finisher);

        finisher.delegate = self;

        if(self.wasCancelled) {
            [finisher setFinishedWithResult:[NSError cancelError]];
        }
        else {
            [self willStartOperation];
            [self startOperation:finisher];
        }
    }
    @catch(NSException* ex) {
        [finisher setFinishedWithResult:ex.error];
    }
}

- (void) runSynchronousOperationInQueue:(id<FLAsyncQueue>) asyncQueue
                           finisher:(FLFinisher*) finisher  {

    FLAssertNotNil(asyncQueue);
    FLAssertNotNil(finisher);

    [self startAsyncOperationInQueue:asyncQueue finisher:finisher];

    // if the operation is implemented as synchronous, the finisher will be done already, else it will block on the GCD semaphor in the finisher.
    [finisher waitUntilFinished];
}

- (void) abortIfNeeded {
    if(self.abortNeeded) {
        FLThrowError([NSError cancelError]);
    }
}

- (BOOL) abortNeeded {
    return self.wasCancelled;
}

- (void) requestCancel {
    self.cancelled = YES;
}

- (void) removeContext:(id) context {
    FLAssertNotNil(context);

    if(_context && context == _context) {
        _context = nil;
        [context removeOperation:self];
        [self wasRemovedFromContext:context];
    }
}

- (void) setContext:(id) context {

    if(context != _context) {

        if(_context) {
            [self removeContext:_context];
        }

        _context = context;

        if(_context) {
            [self wasAddedToContext:_context];
        }
    }
}

- (void) willStartOperation {
}

- (void) wasAddedToContext:(id) context {
}

- (void) wasRemovedFromContext:(id) context {
}

- (void) abortIfCancelled {
    if(self.wasCancelled) {
        FLThrowCancel();
    }
}


#if EXPERIMENTAL
- (void) addPrerequisite:(id<FLPrerequisite>) prerequisite {
    if(!_prerequisites) {
        _prerequisites = [[NSMutableArray alloc] init];
    }

    [_prerequisites addObject:prerequisite];
}
#endif

@end

