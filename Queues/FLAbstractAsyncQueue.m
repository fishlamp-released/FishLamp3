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

@interface FLQueueableBlockOperation : FLFinisher<FLQueueableAsyncOperation> {
@private
    fl_block_t _block;
}
- (id) initWithBlock:(fl_block_t) block;
+ (id) queueableBlockOperation:(fl_block_t) block;
@end

@interface FLQueuableFinisherBlockOperation : FLFinisher<FLQueueableAsyncOperation> {
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

    return [self queueOperation:[FLQueueableBlockOperation queueableBlockOperation:block] withDelay:delay completion:completion];
}

- (FLPromise*) queueBlockWithDelay:(NSTimeInterval) delay
                             block:(fl_block_t) block {
    return [self queueOperation:[FLQueueableBlockOperation queueableBlockOperation:block] withDelay:0 completion:nil];
}

- (FLPromise*) queueBlock:(fl_block_t) block {
    return [self queueOperation:[FLQueueableBlockOperation queueableBlockOperation:block] withDelay:0 completion:nil];
}

- (FLPromise*) queueBlock:(fl_block_t) block
               completion:(fl_completion_block_t) completionOrNil {
    return [self queueOperation:[FLQueueableBlockOperation queueableBlockOperation:block] withDelay:0 completion:completionOrNil];
}

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block
                         completion:(fl_completion_block_t) completionOrNil {
    return [self queueOperation:[FLQueuableFinisherBlockOperation queueableFinisherBlockOperation:block] withDelay:0 completion:completionOrNil];
}

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block {
    return [self queueOperation:[FLQueuableFinisherBlockOperation queueableFinisherBlockOperation:block] withDelay:0 completion:nil];
}

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) object
                completion:(fl_completion_block_t) completionOrNil {
    FLAssertNotNil(object);

    return [self queueOperation:object withDelay:0 completion:completionOrNil];
}

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) object {
    FLAssertNotNil(object);

    return [self queueOperation:object withDelay:0 completion:nil];
}

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) object
                 withListener:(id) listener {

    FLAssertNotNil(object);
    FLAssert([object respondsToSelector:@selector(addListener:)]);

    [((id)object) addListener:listener];

    return [self queueOperation:object withDelay:0 completion:nil];
}


- (FLPromisedResult) runBlockSynchronously:(fl_block_t) block {
    return [self runSynchronously:[FLQueueableBlockOperation queueableBlockOperation:block]];
}

- (FLPromisedResult) runFinisherBlockSynchronously:(fl_finisher_block_t) block {
    return [self runSynchronously:[FLQueuableFinisherBlockOperation queueableFinisherBlockOperation:block]];
}

- (FLPromisedResult) runSynchronously:(id<FLQueueableAsyncOperation>) object {
    return nil;
}


- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) object
                 withDelay:(NSTimeInterval) delay
                completion:(fl_completion_block_t) completionOrNil {
    FLAssertNotNil(object);

    return nil;
}

- (FLPromise*) startOperation:(id<FLQueueableAsyncOperation>) object
                 withDelay:(NSTimeInterval) delay
                completion:(fl_completion_block_t) completionOrNil {
    FLAssertNotNil(object);

    return [self queueOperation:object withDelay: delay completion:completionOrNil];
}

- (FLPromisedResult) runOperationSynchronously:(id<FLQueueableAsyncOperation>) asyncObject {
    return [self runSynchronously:asyncObject];
}


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"

- (FLPromise*) queueTarget:(id) target
                    action:(SEL) action {

    FLAssertNotNil(target);
    FLAssertNotNil(action);

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
    FLAssertNotNil(action);

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
    FLAssertNotNil(action);

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
    FLAssertNotNil(action);
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
    FLAssertNotNil(action);
    __block id theTarget = FLRetain(target);

    return [self queueBlock:^{
        [target performSelector_fl:action withObject:object1 withObject:object2 withObject:object3 withObject:object4];
        FLReleaseWithNil(theTarget);
    }];
}

- (FLPromise*) queueTarget:(id) target
                asyncAction:(SEL) action {

    FLAssertNotNil(target);
    FLAssertNotNil(action);

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
    FLAssertNotNil(action);

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
    FLAssertNotNil(action);

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
    FLAssertNotNil(action);
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

- (void) startAsyncOperationInQueue:(id<FLAsyncQueue>) queue {
    if(_block) {
        _block();
    }
    FLReleaseBlockWithNil(_block);
    [self setFinished];
}

- (FLPromisedResult) runSynchronousOperationInQueue:(id<FLAsyncQueue>) queue {
    [self startAsyncOperationInQueue:queue];
    return self.result;
}

- (FLFinisher*) finisher {
    return self;
}

- (void) wasAddedToContext:(id) context {
}

- (void) wasRemovedFromContext:(id) context {
}

@end

@implementation FLQueuableFinisherBlockOperation

- (FLFinisher*) finisher {
    return self;
}

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

- (void) startAsyncOperationInQueue:(id<FLAsyncQueue>) queue {
    if(_block) {
        _block(self);
    }
    FLReleaseBlockWithNil(_block);
}

- (FLPromisedResult) runSynchronousOperationInQueue:(id<FLAsyncQueue>) queue {
    [self startAsyncOperationInQueue:queue];
    return self.result;
}

- (void) wasAddedToContext:(id) context {
}

- (void) wasRemovedFromContext:(id) context {
}

@end