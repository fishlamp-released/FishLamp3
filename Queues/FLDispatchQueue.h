//
//  FLDispatchQueue.h
//  FLCore
//
//  Created by Mike Fullerton on 10/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <dispatch/dispatch.h>

#import "FLAbstractAsyncQueue.h"

@class FLFifoAsyncQueue;
@protocol FLOperationStarter;
@protocol FLExceptionHandler;

@interface FLDispatchQueue : FLAbstractAsyncQueue {
@private
    dispatch_queue_t _dispatch_queue;
    NSString* _label;

    NSMutableArray* _exceptionHandlers;
}

// 
// Info
//

#if OS_OBJECT_USE_OBJC
@property (readonly, strong) dispatch_queue_t dispatch_queue_t;
#else
@property (readonly, assign) dispatch_queue_t dispatch_queue_t;
#endif

@property (readonly, strong) NSString* label;

// 
// constructors
//

- (id) initWithLabel:(NSString*) label  
                attr:(dispatch_queue_attr_t) attr;

- (id) initWithDispatchQueue:(dispatch_queue_t) queue;

+ (FLDispatchQueue*) fifoDispatchQueue:(NSString*) label;

+ (FLDispatchQueue*) concurrentDispatchQueue:(NSString*) label;

+ (FLDispatchQueue*) dispatchQueue:(dispatch_queue_t) queue;

+ (FLDispatchQueue*) dispatchQueueWithLabel:(NSString*) label 
                                       attr:(dispatch_queue_attr_t) attr;


- (void) addExceptionHandler:(id<FLExceptionHandler>) exceptionHandler;

// 
// Utils
//

/*!
 *  Sleep the current queue
 *  note this allows the main run loop to continue processing events.
 *
 *  @param sleep for how many seconds
 *  
 */
+ (void) sleepForTimeInterval:(NSTimeInterval) milliseconds;

// same as GCD functions, just here for convienience so you don't have to get the dispatch_block_t
// for those. Also these

- (void) dispatch_async:(dispatch_block_t) block;

- (void) dispatch_sync:(dispatch_block_t) block;

- (void) dispatch_after:(NSTimeInterval) seconds block:(dispatch_block_t) block;

- (void) dispatch_target:(id) target action:(SEL) action;

- (void) dispatch_target:(id) target action:(SEL) action withObject:(id) object;

@end

@interface FLDispatchQueue (SharedQueues)

// See Helper Macros below

// 
// Shared Concurrent Queues
//

+ (FLDispatchQueue*) veryLowPriorityQueue;

+ (FLDispatchQueue*) lowPriorityQueue;

+ (FLDispatchQueue*) defaultQueue;

+ (FLDispatchQueue*) highPriorityQueue;

//
// Shared FIFO Queues
//

+ (FLDispatchQueue*) mainThreadQueue; // note this is a fifo queue.

/*!
 *  Returns the shared FIFO queue
 *  Note that this queue runs in the main thread so it's safe to do UI in it.
 *  
 *  @return the fifoQueue
 */
+ (FLFifoAsyncQueue*) fifoQueue;

- (id) scheduleListener:(id) listener;
@end

#define FLForegroundQueue       [FLDispatchQueue mainThreadQueue]
#define FLBackgroundQueue       [FLDispatchQueue defaultQueue]
#define FLFifoQueue             [FLDispatchQueue fifoQueue]
#define FLDefaultQueue          [FLDispatchQueue defaultQueue]

@interface FLFifoAsyncQueue : FLDispatchQueue
+ (id) fifoAsyncQueue;
@end

#define FLTimeIntervalToNanoSeconds(TIME_INTERVAL) (TIME_INTERVAL * NSEC_PER_SEC)



