//
//  FLDispatchQueue.m
//  FLCore
//
//  Created by Mike Fullerton on 10/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDispatchQueue.h"
#import "FLSelectorPerforming.h"
#import "FLFinisher.h"
#import "FLPromisedResult.h"
#import "FLPromise.h"
#import "FLQueueableAsyncOperation.h"
#import "FLOperationStarter.h"
#import "FLExceptionHandler.h"

@interface FLExecuteInQueueProxy : FLRetainedObject {
@private
    FLDispatchQueue* _queue;
}
+ (id) executeInQueueProxy:(id) object queue:(FLDispatchQueue*) queue;
@end

@interface FLMainThreadQueue : FLFifoAsyncQueue
+ (id) mainThreadQueue;
@end

@implementation FLDispatchQueue

@synthesize dispatch_queue_t = _dispatch_queue;
@synthesize label = _label;

- (id) initWithDispatchQueue:(dispatch_queue_t) queue {
    if(!queue) {
        return nil;
    }
    
    self = [super init];
    if(self) {
        _dispatch_queue = queue;
#if !OS_OBJECT_USE_OBJC
        dispatch_retain(_dispatch_queue);
#endif
        _label = [[NSString alloc] initWithCString:dispatch_queue_get_label(_dispatch_queue) encoding:NSASCIIStringEncoding];
    }
    return self;
}

- (id) initWithLabel:(NSString*) label  
                attr:(dispatch_queue_attr_t) attr {

    dispatch_queue_t queue = dispatch_queue_create([label cStringUsingEncoding:NSASCIIStringEncoding], attr);
    if(!queue) {
        return nil;
    }
    @try {
        self = [self initWithDispatchQueue:queue];
    }
    @finally {
        FLDispatchRelease(queue);
    }

    return self;
}

+ (FLDispatchQueue*) dispatchQueue:(dispatch_queue_t) queue {
    return FLAutorelease([[[self class] alloc] initWithDispatchQueue:queue]);
}

+ (FLDispatchQueue*) dispatchQueueWithLabel:(NSString*) label attr:(dispatch_queue_attr_t) attr {
    return FLAutorelease([[[self class] alloc] initWithLabel:label attr:attr]);
}

+ (FLDispatchQueue*) fifoDispatchQueue:(NSString*) label {

#if defined(__MAC_10_6) && !defined(__MAC_10_7)
    return FLAutorelease([[[self class] alloc] initWithLabel:label attr:nil]);
#else
    return FLAutorelease([[[self class] alloc] initWithLabel:label attr:DISPATCH_QUEUE_SERIAL]);
#endif

}

+ (FLDispatchQueue*) concurrentDispatchQueue:(NSString*) label {
#if defined(__MAC_10_6) && !defined(__MAC_10_7)
    // TODO
#else
    return FLAutorelease([[[self class] alloc] initWithLabel:label attr:DISPATCH_QUEUE_CONCURRENT]);
#endif
}


- (void) dealloc {
    if(_dispatch_queue) {
        FLDispatchRelease(_dispatch_queue);
    }

#if FL_MRC
    [_label release];
    [super dealloc];
#endif
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@", [super description], self.label];
}

- (void) addExceptionHandler:(id<FLExceptionHandler>) exceptionHandler {
    if(!_exceptionHandlers) {
        _exceptionHandlers = [[NSMutableArray alloc] init];
    }

    [_exceptionHandlers addObject:exceptionHandler];
}


- (void) handleException:(NSException*) exception {

}

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) operation
                 withDelay:(NSTimeInterval) delay
                completion:(fl_completion_block_t) completion {

    FLAssertNotNil(operation);

    __block id<FLQueueableAsyncOperation> theOperation = FLRetain(operation);
    __block FLDispatchQueue* theQueue = FLRetain(self);
    __block FLPromise* thePromise = nil;

    if(completion) {
        thePromise = FLRetain([[theOperation finisher] addPromiseWithBlock:completion]);
    }

    fl_block_t block = ^{
        @try {
            [theOperation startAsyncOperationInQueue:theQueue];
        }
        @catch(NSException* ex) {

            if(![theOperation finisher].isFinished) {
                [[theOperation finisher] setFinishedWithResult:ex.error];
            }
        }

        FLReleaseWithNil(thePromise);
        FLReleaseWithNil(theOperation);
        FLReleaseWithNil(theQueue);
    };

    if(0.0f != delay) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, FLTimeIntervalToNanoSeconds(delay)), theQueue.dispatch_queue_t, block);
    }
    else {
        dispatch_async(theQueue.dispatch_queue_t, block);
    }

    return thePromise;
}

- (FLPromisedResult) runSynchronously:(id<FLQueueableAsyncOperation>) operation {

    FLAssertNotNil(operation);

    __block FLPromisedResult result = nil;
    __block id<FLQueueableAsyncOperation> theOperation = FLRetain(operation);
    __block FLDispatchQueue* theQueue = FLRetain(self);

    dispatch_sync(self.dispatch_queue_t, ^{
        @try {
            result = FLRetain([theOperation runSynchronousOperationInQueue:theQueue]);
        }
        @catch(NSException* ex) {
            [theOperation.finisher setFinishedWithResult:ex.error];
        }
        FLReleaseWithNil(theQueue);
        FLReleaseWithNil(theOperation);
    });

    return FLAutorelease(result);
}

#if __MAC_10_8
+ (void) sleepForTimeInterval:(NSTimeInterval) seconds {
    
    if([NSThread isMainThread]) {
        NSTimeInterval timeout = [NSDate timeIntervalSinceReferenceDate] + seconds;
        while([NSDate timeIntervalSinceReferenceDate] < timeout) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
        }
    } 
    else {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_semaphore_wait(semaphore, 
                                dispatch_time(0, FLTimeIntervalToNanoSeconds(seconds)));
        FLDispatchRelease(semaphore);
    } 
}    
#endif

- (void) dispatch_async:(dispatch_block_t) block {
    dispatch_async(self.dispatch_queue_t, block);
}

- (void) dispatch_sync:(dispatch_block_t) block {
    dispatch_sync(self.dispatch_queue_t, block);
}

- (void) dispatch_after:(NSTimeInterval) seconds block:(dispatch_block_t) block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, FLTimeIntervalToNanoSeconds(seconds)), self.dispatch_queue_t, block);
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"

- (void) dispatch_target:(id) target action:(SEL) action {

    FLAssertNotNil(target);
    FLAssertNotNil(action);

    __block id theTarget = FLRetain(target);
    [self dispatch_async:^{
        [theTarget performSelector:action];
        FLReleaseWithNil(theTarget);
    }];
}

- (void) dispatch_target:(id) target action:(SEL) action withObject:(id) object {
    FLAssertNotNil(target);
    FLAssertNotNil(action);

    __block id theTarget = FLRetain(target);
    __block id theObject = FLRetain(object);

    [self dispatch_async:^{
        [theTarget performSelector:action withObject:theObject];
        FLReleaseWithNil(theTarget);
        FLReleaseWithNil(theObject);
    }];
}

#pragma GCC diagnostic pop


+ (FLDispatchQueue*) lowPriorityQueue {
    FLReturnStaticObject( [FLDispatchQueue dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)]);
}
+ (FLDispatchQueue*) defaultQueue {
    FLReturnStaticObject( [FLDispatchQueue dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)]);
}
+ (FLDispatchQueue*) highPriorityQueue {
    FLReturnStaticObject([FLDispatchQueue dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)]);
}
+ (FLDispatchQueue*) veryLowPriorityQueue {
    FLReturnStaticObject([FLDispatchQueue dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)]);
}

+ (FLDispatchQueue*) mainThreadQueue {
    FLReturnStaticObject([FLMainThreadQueue mainThreadQueue ]);
}

+ (FLFifoAsyncQueue*) fifoQueue {
    FLReturnStaticObject([FLFifoAsyncQueue fifoAsyncQueue]);
}

//+ (id<FLOperationStarter>) defaultOperationStarter {
//    return [self defaultQueue];
//}

- (id) scheduleListener:(id) listener {
    return [FLExecuteInQueueProxy executeInQueueProxy:listener queue:self];
}

@end

@implementation FLFifoAsyncQueue  

+ (id) fifoAsyncQueue {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {
    static int s_count = 0;
#if __MAC_10_8
    return [super initWithLabel:[NSString stringWithFormat:@"com.fishlamp.queue.fifo%d", s_count++] attr:DISPATCH_QUEUE_SERIAL];
#else 
    return [super initWithLabel:[NSString stringWithFormat:@"com.fishlamp.queue.fifo%d", s_count++] attr:nil];
#endif
}

@end

@implementation FLMainThreadQueue

- (id) init {	
	return [super initWithDispatchQueue:dispatch_get_main_queue()];
}

+ (id) mainThreadQueue {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) scheduleListener:(id) listener {
    return [FLMainThreadObject mainThreadObject:listener];
}
@end

@implementation FLExecuteInQueueProxy

- (id) initWithRetainedObject:(id) object queue:(FLDispatchQueue*) queue {

    self = [super initWithRetainedObject:object];
    if(self) {
        _queue = FLRetain(queue);
        FLAssertNotNil(_queue);
    }
    return self;
}

+ (id) executeInQueueProxy:(id) object queue:(FLDispatchQueue*) queue {
    return FLAutorelease([[[self class] alloc] initWithRetainedObject:object queue:queue]);
}

#if FL_MRC
- (void)dealloc {
	[_queue release];
	[super dealloc];
}
#endif

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    __block id object = [self representedObject];
    FLAssertNotNil(object);
    FLAssertNotNil(_queue);

    if([object respondsToSelector:[anInvocation selector]]) {

        __block NSInvocation* theInvocation = FLRetain(anInvocation);
        [theInvocation retainArguments];

        FLRetainObject(object);

        [_queue dispatch_async: ^{
            [theInvocation invokeWithTarget:object];
            FLReleaseWithNil(theInvocation);
            FLReleaseWithNil(object);
        }];
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

@end