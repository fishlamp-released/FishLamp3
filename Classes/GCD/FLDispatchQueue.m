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

#if EXPERIMENTAL
#import "FLExceptionHandler.h"
#import "FLProxies.h"
@interface FLExecuteInQueueProxy : FLRetainedObject {
@private
    FLDispatchQueue* _queue;
}
+ (id) executeInQueueProxy:(id) object queue:(FLDispatchQueue*) queue;
@end
#endif

void FLRunSynchronousOperation(id<FLQueueableAsyncOperation> operation, FLDispatchQueue* queue, FLFinisher* finisher);
void FLQueueOperation(id<FLQueueableAsyncOperation> operation, NSTimeInterval delay, FLDispatchQueue* queue, FLFinisher* finisher);

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

#if EXPERIMENTAL
- (void) addExceptionHandler:(id<FLExceptionHandler>) exceptionHandler {
    if(!_exceptionHandlers) {
        _exceptionHandlers = [[NSMutableArray alloc] init];
    }

    [_exceptionHandlers addObject:exceptionHandler];
}


- (void) handleException:(NSException*) exception {

}
#endif

- (void) queueOperation:(id<FLQueueableAsyncOperation>) operation
                    withDelay:(NSTimeInterval) delay
                 finisher:(FLFinisher*) finisher {

    FLAssertNotNil(operation);
    FLAssertNotNil(finisher);
    FLAssertNonZeroNumber(self.dispatch_queue_t);

    FLQueueOperation(operation, delay, self, finisher);
}

- (FLPromisedResult) runSynchronously:(id<FLQueueableAsyncOperation>) operation {

    FLAssertNotNil(operation);
    FLAssertNonZeroNumber(self.dispatch_queue_t);

    FLFinisher* finisher = [FLFinisher finisher];
    FLRunSynchronousOperation(operation, self, finisher);

    return finisher.result;
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
    FLAssertNonZeroNumber(action);
    FLAssertNonZeroNumber(self.dispatch_queue_t);

    __block id theTarget = FLRetain(target);
    [self dispatch_async:^{
        [theTarget performSelector:action];
        FLReleaseWithNil(theTarget);
    }];
}

- (void) dispatch_target:(id) target action:(SEL) action withObject:(id) object {
    FLAssertNotNil(target);
    FLAssertNonZeroNumber(action);
    FLAssertNonZeroNumber(self.dispatch_queue_t);

    __block id theTarget = FLRetain(target);
    __block id theObject = FLRetain(object);

    [self dispatch_async:^{
        [theTarget performSelector:action withObject:theObject];
        FLReleaseWithNil(theTarget);
        FLReleaseWithNil(theObject);
    }];
}

#pragma GCC diagnostic pop

#if EXPERIMENTAL
- (id) scheduleListener:(id) listener {
    return [FLExecuteInQueueProxy executeInQueueProxy:listener queue:self];
}
#endif

@end

void FLQueueOperation(id<FLQueueableAsyncOperation> operation, NSTimeInterval delay, FLDispatchQueue* queue, FLFinisher* finisher) {
// using a c function here to be clear about tightly constraining references. We don't want an accidently reference to self.

    FLCAssertNotNil(operation);
    FLCAssertNotNil(queue);
    FLCAssertNotNil(queue.dispatch_queue_t);
    FLCAssertNotNil(finisher);

    __block id<FLQueueableAsyncOperation> blockOperation = FLRetain(operation);
    __block FLDispatchQueue* blockQueue = FLRetain(queue);
    __block FLFinisher* blockFinisher = FLRetain(finisher);

    FLCAssertNotNil(blockFinisher);

    fl_block_t block = ^{
        @try {
            [blockOperation startAsyncOperationInQueue:blockQueue finisher:blockFinisher];
        }
        @catch(NSException* ex) {

            if(!blockFinisher.isFinished) {
                [blockFinisher setFinishedWithResult:ex.error];
            }
        }

        FLReleaseWithNil(blockFinisher);
        FLReleaseWithNil(blockOperation);
        FLReleaseWithNil(blockQueue);
    };

    if(queue) {
        if(0.0f != delay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, FLTimeIntervalToNanoSeconds(delay)), queue.dispatch_queue_t, block);
        }
        else {
            dispatch_async(queue.dispatch_queue_t, block);
        }
    }
}

void FLRunSynchronousOperation(id<FLQueueableAsyncOperation> operation, FLDispatchQueue* queue, FLFinisher* finisher) {
// using a c function here to be clear about tightly constraining references. We don't want an accidently reference to self.

    FLCAssertNotNil(operation);
    FLCAssertNotNil(queue);
    FLCAssertNotNil(queue.dispatch_queue_t);
    FLCAssertNotNil(finisher);

    __block id<FLQueueableAsyncOperation> blockOperation = FLRetain(operation);
    __block FLDispatchQueue* blockQueue = FLRetain(queue);
    __block FLFinisher* blockFinisher = FLRetain(finisher);

// this prevents bogus Clang warning.
    if(queue) {
        dispatch_queue_t queue_t = queue.dispatch_queue_t;
        dispatch_sync(queue_t, ^{
            @try {
                [blockOperation runSynchronousOperationInQueue:blockQueue finisher:blockFinisher];
            }
            @catch(NSException* ex) {
                [blockFinisher setFinishedWithResult:ex.error];
            }
            FLReleaseWithNil(blockQueue);
            FLReleaseWithNil(blockOperation);
            FLReleaseWithNil(blockFinisher);
        });
    }
}

#if EXPERIMENTAL
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
#endif