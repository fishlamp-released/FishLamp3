//
//  FLAbstractAsyncQueue.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAbstractAsyncQueue.h"
#import "FLQueueableAsyncOperation.h"
#import "FLBroadcaster.h"

@interface FLQueueableBlockOperation : NSObject<FLQueueableAsyncOperation> {
@private
    fl_block_t _block;
}
- (id) initWithBlock:(fl_block_t) block;
+ (id) queueableBlockOperation:(fl_block_t) block;
@end

@interface FLQueuableFinisherBlockOperation : NSObject<FLQueueableAsyncOperation> {
@private
    fl_finisher_block_t _block;
}

- (id) initWithFinisherBlock:(fl_finisher_block_t) block;
+ (id) queueableFinisherBlockOperation:(fl_finisher_block_t) block;
@end

@implementation FLAbstractAsyncQueue

- (FLPromise*) queueBlockWithDelay:(NSTimeInterval) delay
                             block:(fl_block_t) block
                        completion:(fl_completion_block_t) completion {

    FLAssertNotNil(block);

    return [self queueOperation:[FLQueueableBlockOperation queueableBlockOperation:block]
                      withDelay:delay
                   withFinisher:[FLFinisher finisherWithBlock:completion]];
}

- (FLPromise*) queueBlockWithDelay:(NSTimeInterval) delay
                             block:(fl_block_t) block {
    FLAssertNotNil(block);

    return [self queueOperation:[FLQueueableBlockOperation queueableBlockOperation:block]
                      withDelay:0
                   withFinisher:[FLFinisher finisher]];
}

- (FLPromise*) queueBlock:(fl_block_t) block {

    FLAssertNotNil(block);

    return [self queueOperation:[FLQueueableBlockOperation queueableBlockOperation:block]
                      withDelay:0
                   withFinisher:[FLFinisher finisher]];
}

- (FLPromise*) queueBlock:(fl_block_t) block
               completion:(fl_completion_block_t) completionOrNil {

    FLAssertNotNil(block);

    return [self queueOperation:[FLQueueableBlockOperation queueableBlockOperation:block]
                      withDelay:0
                   withFinisher:[FLFinisher finisherWithBlock:completionOrNil]];
}

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block
                         completion:(fl_completion_block_t) completionOrNil {

    FLAssertNotNil(block);

    return [self queueOperation:[FLQueuableFinisherBlockOperation queueableFinisherBlockOperation:block]
                      withDelay:0
                   withFinisher:[FLFinisher finisherWithBlock:completionOrNil]];
}

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block {

    FLAssertNotNil(block);

    return [self queueOperation:[FLQueuableFinisherBlockOperation queueableFinisherBlockOperation:block]
                      withDelay:0
                   withFinisher:[FLFinisher finisher]];
}

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) object
                    withDelay:(NSTimeInterval) delay
                   completion:(fl_completion_block_t) completionOrNil {

    FLAssertNotNil(object);

    return [self queueOperation:object
                      withDelay:delay
                   withFinisher:[FLFinisher finisherWithBlock:completionOrNil]];
}

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) object
                   completion:(fl_completion_block_t) completionOrNil {

    FLAssertNotNil(object);

    return [self queueOperation:object
                      withDelay:0
                   withFinisher:[FLFinisher finisherWithBlock:completionOrNil]];
}

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) object {

    FLAssertNotNil(object);

    return [self queueOperation:object
                      withDelay:0
                   withFinisher:[FLFinisher finisher]];
}

- (FLPromisedResult) runBlockSynchronously:(fl_block_t) block {

    FLAssertNotNil(block);

    return [self runSynchronously:[FLQueueableBlockOperation queueableBlockOperation:block]];
}


- (FLPromisedResult) runFinisherBlockSynchronously:(fl_finisher_block_t) block {

    FLAssertNotNil(block);

    return [self runSynchronously:[FLQueuableFinisherBlockOperation queueableFinisherBlockOperation:block]];
}

- (FLPromisedResult) runSynchronously:(id<FLQueueableAsyncOperation>) object {

    FLAssertionFailed(@"required override");

    return nil;
}

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) object
                    withDelay:(NSTimeInterval) delay
                 withFinisher:(FLFinisher*) finisher {

    FLAssertionFailed(@"required override");

    return nil;
}

- (FLPromise*) startOperation:(id<FLQueueableAsyncOperation>) object
                    withDelay:(NSTimeInterval) delay
                 withFinisher:(FLFinisher*) finisher {

    FLAssertNotNil(object);
    FLAssertNotNil(finisher);

    return [self queueOperation:object withDelay: delay withFinisher:finisher];
}

- (FLPromisedResult) runOperationSynchronously:(id<FLQueueableAsyncOperation>) asyncObject {
    return [self runSynchronously:asyncObject];
}


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"

- (FLPromise*) queueTarget:(id) target
                    action:(SEL) action {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);

    __block id theTarget = FLRetain(target);

    return [self queueBlock:^{
        [theTarget performSelector:action];

        FLReleaseWithNil(theTarget);
    }];
}

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);

    __block id theTarget = FLRetain(target);

    return [self queueBlock:^{
        [target performSelector:action withObject:object];

        FLReleaseWithNil(theTarget);
    }];
}

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2 {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);

    __block id theTarget = FLRetain(target);

    return [self queueBlock:^{
        [target performSelector:action withObject:object1 withObject:object2];
        FLReleaseWithNil(theTarget);
    }];
}

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3 {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);
    __block id theTarget = FLRetain(target);

    return [self queueBlock:^{
        [target performSelector_fl:action withObject:object1 withObject:object2 withObject:object3];
        FLReleaseWithNil(theTarget);
    }];

}

- (FLPromise*) queueTarget:(id) target
                    action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3
                withObject:(id) object4 {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);
    __block id theTarget = FLRetain(target);

    return [self queueBlock:^{
        [target performSelector_fl:action withObject:object1 withObject:object2 withObject:object3 withObject:object4];
        FLReleaseWithNil(theTarget);
    }];
}

- (FLPromise*) queueTarget:(id) target
                asyncAction:(SEL) action {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);

    __block id theTarget = FLRetain(target);

    return [self queueFinishableBlock:^(FLFinisher *finisher) {
        [theTarget performSelector:action withObject:finisher];
        FLReleaseWithNil(theTarget);
    }];

}

- (FLPromise*) queueTarget:(id) target
               asyncAction:(SEL) action
                withObject:(id) object {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);

    __block id theTarget = FLRetain(target);

    return [self queueFinishableBlock:^(FLFinisher *finisher) {
        [target performSelector:action withObject:finisher withObject:object];

        FLReleaseWithNil(theTarget);
    }];
}

- (FLPromise*) queueTarget:(id) target
               asyncAction:(SEL) action
                withObject:(id) object1
                withObject:(id) object2 {
    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);

    __block id theTarget = FLRetain(target);

    return [self queueFinishableBlock:^(FLFinisher *finisher) {
        [target performSelector_fl:action withObject:finisher withObject:object1 withObject:object2];
        FLReleaseWithNil(theTarget);
    }];
}

- (FLPromise*) queueTarget:(id) target
               asyncAction:(SEL) action
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3 {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);
    __block id theTarget = FLRetain(target);

    return [self queueFinishableBlock:^(FLFinisher *finisher) {
        [target performSelector_fl:action withObject:finisher withObject:object1 withObject:object2 withObject:object3];
        FLReleaseWithNil(theTarget);
    }];

}

#pragma GCC diagnostic pop

@end

@implementation FLQueueableBlockOperation

- (id) initWithBlock:(fl_block_t) block {
	self = [super init];
	if(self) {
 		_block = [block copy];
	}
	return self;
}

+ (id) queueableBlockOperation:(fl_block_t) block {
    return FLAutorelease([[[self class] alloc] initWithBlock:block]);
}

#if FL_MRC
- (void)dealloc {
	[_block release];
	[super dealloc];
}
#endif

- (void) startAsyncOperationInQueue:(id<FLAsyncQueue>) queue withFinisher:(FLFinisher *)finisher {

    FLAssertNotNil(queue);
    FLAssertNotNil(finisher);

    if(_block) {
        _block();
    }
    FLReleaseBlockWithNil(_block);
    [finisher setFinished];
}

- (void) runSynchronousOperationInQueue:(id<FLAsyncQueue>) queue
                                           withFinisher:(FLFinisher *)finisher {

    FLAssertNotNil(queue);
    FLAssertNotNil(finisher);

    [self startAsyncOperationInQueue:queue withFinisher:finisher];
    [finisher waitUntilFinished];
}

- (void) wasAddedToContext:(id) context {
}

- (void) wasRemovedFromContext:(id) context {
}

@end

@implementation FLQueuableFinisherBlockOperation

- (id) initWithFinisherBlock:(fl_finisher_block_t) block {
	self = [super init];
	if(self) {
		_block = [block copy];
	}
	return self;
}

+ (id) queueableFinisherBlockOperation:(fl_finisher_block_t) block {
    return FLAutorelease([[[self class] alloc] initWithFinisherBlock:block]);
}

#if FL_MRC
- (void)dealloc {
	[_block release];
	[super dealloc];
}
#endif

- (void) startAsyncOperationInQueue:(id<FLAsyncQueue>) queue withFinisher:(FLFinisher*) finisher {

    FLAssertNotNil(queue);
    FLAssertNotNil(finisher);

    if(_block) {
        _block(finisher);
    }
}

- (void) runSynchronousOperationInQueue:(id<FLAsyncQueue>) queue withFinisher:(FLFinisher*) finisher {

    FLAssertNotNil(queue);
    FLAssertNotNil(finisher);

    [self startAsyncOperationInQueue:queue withFinisher:finisher];
    [finisher waitUntilFinished];
}

- (void) wasAddedToContext:(id) context {
}

- (void) wasRemovedFromContext:(id) context {
}

@end