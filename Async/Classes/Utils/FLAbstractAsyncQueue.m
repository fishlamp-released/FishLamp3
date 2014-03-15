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
#import "FLFinisher_Internal.h"

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

    FLFinisher* finisher = [FLFinisher finisherWithBlock:completion];
    finisher.asyncQueueBlock = block;

    [self queueOperation:finisher withDelay:delay finisher:finisher];

    return finisher;
}

- (FLPromise*) queueBlockWithDelay:(NSTimeInterval) delay
                             block:(fl_block_t) block {
    return [self queueBlockWithDelay:delay block:block completion:nil];
}


- (FLPromise*) queueBlock:(fl_block_t) block
               completion:(fl_completion_block_t) completionOrNil {

    FLAssertNotNil(block);

    FLFinisher* finisher = [FLFinisher finisherWithBlock:completionOrNil];
    finisher.asyncQueueBlock = block;

    [self queueOperation:finisher withDelay:0 finisher:finisher];

    return finisher;
}

- (FLPromise*) queueBlock:(fl_block_t) block {
    return [self queueBlock:block completion:nil];
}

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block
                         completion:(fl_completion_block_t) completionOrNil {

    FLAssertNotNil(block);

    FLFinisher* finisher = [FLFinisher finisherWithBlock:completionOrNil];
    finisher.asyncQueueFinisherBlock = block;

    [self queueOperation:finisher withDelay:0 finisher:finisher];

    return finisher;
}

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block {
    return [self queueFinishableBlock:block completion:nil];
}

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) object
                    withDelay:(NSTimeInterval) delay
                   completion:(fl_completion_block_t) completionOrNil {

    FLAssertNotNil(object);

    FLFinisher* finisher = [FLFinisher finisherWithBlock:completionOrNil];

    [self queueOperation:object withDelay:delay finisher:finisher];

    return finisher;
}

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) object
                   completion:(fl_completion_block_t) completionOrNil {

    return [self queueOperation:object withDelay:0 completion:completionOrNil];
}

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) object {

    return [self queueOperation:object withDelay:0 completion:nil];
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

- (void) queueOperation:(id<FLQueueableAsyncOperation>) object
                    withDelay:(NSTimeInterval) delay
                     finisher:(FLFinisher*) finisher {

    FLAssertionFailed(@"required override");
}

- (void) queueOperation:(id<FLQueueableAsyncOperation>) object
                     finisher:(FLFinisher*) finisher {

    [self queueOperation:object withDelay:0 finisher:finisher];
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

    __block id blockTarget = FLRetain(target);

    return [self queueBlock:^{
        [blockTarget performSelector:action];

        FLReleaseWithNil(blockTarget);
    }];
}

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);

    __block id blockTarget = FLRetain(target);
    __block id blockObject = FLRetain(object);

    return [self queueBlock:^{
        [blockTarget performSelector:action withObject:blockObject];

        FLReleaseWithNil(blockTarget);
        FLReleaseWithNil(blockObject);
    }];
}

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2 {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);

    __block id blockTarget = FLRetain(target);
    __block id blockObject1 = FLRetain(object1);
    __block id blockObject2 = FLRetain(object2);

    return [self queueBlock:^{
        [blockTarget performSelector:action withObject:blockObject1 withObject:blockObject2];

        FLReleaseWithNil(blockTarget);
        FLReleaseWithNil(blockObject1);
        FLReleaseWithNil(blockObject2);
    }];
}

- (FLPromise*) queueTarget:(id) target
                 action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3 {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);
    __block id blockTarget = FLRetain(target);
    __block id blockObject1 = FLRetain(object1);
    __block id blockObject2 = FLRetain(object2);
    __block id blockObject3 = FLRetain(object3);

    return [self queueBlock:^{
        [blockTarget performSelector_fl:action withObject:blockObject1 withObject:blockObject2 withObject:blockObject3];
        FLReleaseWithNil(blockTarget);
        FLReleaseWithNil(blockObject1);
        FLReleaseWithNil(blockObject2);
        FLReleaseWithNil(blockObject3);
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
    __block id blockTarget = FLRetain(target);
    __block id blockObject1 = FLRetain(object1);
    __block id blockObject2 = FLRetain(object2);
    __block id blockObject3 = FLRetain(object3);
    __block id blockObject4 = FLRetain(object4);

    return [self queueBlock:^{
        [blockTarget performSelector_fl:action withObject:blockObject1 withObject:blockObject2 withObject:blockObject3 withObject:blockObject4];
        FLReleaseWithNil(blockTarget);
        FLReleaseWithNil(blockObject1);
        FLReleaseWithNil(blockObject2);
        FLReleaseWithNil(blockObject3);
        FLReleaseWithNil(blockObject4);
    }];
}

- (FLPromise*) queueTarget:(id) target
                asyncAction:(SEL) action {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);

    __block id blockTarget = FLRetain(target);

    return [self queueFinishableBlock:^(FLFinisher *finisher) {
        [blockTarget performSelector:action withObject:finisher];
        FLReleaseWithNil(blockTarget);
    }];

}

- (FLPromise*) queueTarget:(id) target
               asyncAction:(SEL) action
                withObject:(id) object {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);

    __block id blockTarget = FLRetain(target);
    __block id blockObject = FLRetain(object);

    return [self queueFinishableBlock:^(FLFinisher *finisher) {
        [blockTarget performSelector:action withObject:finisher withObject:blockObject];

        FLReleaseWithNil(blockTarget);
        FLReleaseWithNil(blockObject);
    }];
}

- (FLPromise*) queueTarget:(id) target
               asyncAction:(SEL) action
                withObject:(id) object1
                withObject:(id) object2 {
    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);

    __block id blockTarget = FLRetain(target);
    __block id blockObject1 = FLRetain(object1);
    __block id blockObject2 = FLRetain(object2);

    return [self queueFinishableBlock:^(FLFinisher *finisher) {
        [blockTarget performSelector_fl:action withObject:finisher withObject:blockObject1 withObject:blockObject2];
        FLReleaseWithNil(blockTarget);
        FLReleaseWithNil(blockObject1);
        FLReleaseWithNil(blockObject2);
    }];
}

- (FLPromise*) queueTarget:(id) target
               asyncAction:(SEL) action
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3 {

    FLAssertNotNil(target);
    FLAssertNonNilPointer(action);
    __block id blockTarget = FLRetain(target);
    __block id blockObject1 = FLRetain(object1);
    __block id blockObject2 = FLRetain(object2);
    __block id blockObject3 = FLRetain(object3);

    return [self queueFinishableBlock:^(FLFinisher *finisher) {
        [blockTarget performSelector_fl:action withObject:finisher withObject:blockObject1 withObject:blockObject2 withObject:blockObject3];
        FLReleaseWithNil(blockTarget);
        FLReleaseWithNil(blockObject1);
        FLReleaseWithNil(blockObject2);
        FLReleaseWithNil(blockObject3);
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

- (void) startAsyncOperationInQueue:(id<FLAsyncQueue>) queue finisher:(FLFinisher *)finisher {

    FLAssertNotNil(queue);
    FLAssertNotNil(finisher);

    if(_block) {
        _block();
    }
    FLReleaseBlockWithNil(_block);
    [finisher setFinished];
}

- (void) runSynchronousOperationInQueue:(id<FLAsyncQueue>) queue
                                           finisher:(FLFinisher *)finisher {

    FLAssertNotNil(queue);
    FLAssertNotNil(finisher);

    [self startAsyncOperationInQueue:queue finisher:finisher];
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

- (void) startAsyncOperationInQueue:(id<FLAsyncQueue>) queue finisher:(FLFinisher*) finisher {

    FLAssertNotNil(queue);
    FLAssertNotNil(finisher);

    if(_block) {
        _block(finisher);
    }
}

- (void) runSynchronousOperationInQueue:(id<FLAsyncQueue>) queue finisher:(FLFinisher*) finisher {

    FLAssertNotNil(queue);
    FLAssertNotNil(finisher);

    [self startAsyncOperationInQueue:queue finisher:finisher];
    [finisher waitUntilFinished];
}

- (void) wasAddedToContext:(id) context {
}

- (void) wasRemovedFromContext:(id) context {
}

@end