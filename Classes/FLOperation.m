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
#import "FLDispatchQueue.h"

#import "FishLampSimpleLogger.h"

@interface FLOperation ()
@property (readwrite, assign, getter=wasCancelled) BOOL cancelled;
@property (readwrite, strong) FLFinisher* finisher; 

- (void) finisherDidFinish:(FLFinisher*) finisher
                withResult:(FLPromisedResult) resultOrNil;

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
@synthesize finisher = _finisher;
@synthesize operationStarter = _operationStarter;

- (id) init {
    self = [super init];
    if(self) {
//        self.asyncQueue = [FLDispatchQueue defaultQueue];
    }
    return self;
}

- (void) dealloc {
//    if(_context) {
//        id<FLOperationContext> context = _context;
//        _context = nil;
//        [context removeOperation:self];
//        
//        FLLog(@"Operation last ditch removal from context: %@", [self description]);
//    }

#if FL_MRC
    [_prerequisites release];
    [_operationStarter release];
	[_finisher release];
	[super dealloc];
#endif
}

- (FLPromisedResult) runSynchronously {

    FLLog(@"%@ operation did nothing, you must override startOperation or runSynchronously.", NSStringFromClass([self class]));

    return FLSuccessfulResult;
}

- (void) startOperation:(FLFinisher*) finisher {

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

- (FLFinisher*) createFinisherForBlock:(fl_completion_block_t)block {
    return [[FLOperationFinisher alloc] initWithOperation:self completion:block];
}

- (void) startAsyncOperationInQueue:(id<FLAsyncQueue>) asyncQueue withFinisher:(FLFinisher*) finisher {
    FLAssertNotNil(asyncQueue);
    FLAssertNotNil(finisher);
    [self sendMessageToListeners:@selector(operationWillBegin:) withObject:self];
    [self willStartOperation];
    [self startOperation:finisher];
}

- (void) runSynchronousOperationInQueue:(id<FLAsyncQueue>) asyncQueue withFinisher:(FLFinisher*) finisher  {
    [self startAsyncOperationInQueue:asyncQueue withFinisher:finisher];

    // if the operation is implemented as synchronous, the finisher will be done already, else it will block on the GCD semaphor in the finisher.
    [self.finisher waitUntilFinished];
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

- (id) objectFromResult:(id) result {
    FLAssertNotNil(result);
    FLThrowIfError(result);
    return result;
}

- (void) abortIfCancelled {
    if(self.wasCancelled) {
        FLThrowCancel();
    }
}

- (void) finisherDidFinish:(FLFinisher*) finisher
                withResult:(FLPromisedResult) result {

    FLAssertNotNil(finisher);
    FLAssertNotNil(result);

    [self didFinishWithResult:result];
    [self sendMessageToListeners:@selector(operationDidFinish:withResult:) withObject:self withObject:result];
    self.context = nil;
    self.cancelled = NO;
}

- (void) didFinishWithResult:(FLPromisedResult) result {
}

- (void) addPrerequisite:(id<FLPrerequisite>) prerequisite {
    if(!_prerequisites) {
        _prerequisites = [[NSMutableArray alloc] init];
    }

    [_prerequisites addObject:prerequisite];
}

@end


@implementation FLOperationFinisher

@synthesize operation = _operation;

- (id) initWithOperation:(FLOperation*) operation completion:(fl_completion_block_t) completion {
    FLAssertNotNil(operation);

	self = [super initWithCompletion:completion];
	if(self) {
		_operation = operation;
	}
	return self;
}

- (void) didFinishWithResult:(id)result {
    [_operation finisherDidFinish:self withResult:result];
    _operation = nil;
}
@end
