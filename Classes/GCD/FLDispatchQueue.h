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

@class FLFifoDispatchQueue;
@protocol FLOperationStarter;
@protocol FLExceptionHandler;

@interface FLDispatchQueue : FLAbstractAsyncQueue {
@private
    dispatch_queue_t _dispatch_queue;
    NSString* _label;

#if EXPERIMENTAL
    NSMutableArray* _exceptionHandlers;
#endif
}

#if OS_OBJECT_USE_OBJC
@property (readonly, strong) dispatch_queue_t dispatch_queue_t;
#else
@property (readonly, assign) dispatch_queue_t dispatch_queue_t;
#endif

@property (readonly, strong) NSString* label;

- (id) initWithLabel:(NSString*) label  
                attr:(dispatch_queue_attr_t) attr;

- (id) initWithDispatchQueue:(dispatch_queue_t) queue;


#if EXPERIMENTAL
- (void) addExceptionHandler:(id<FLExceptionHandler>) exceptionHandler;
#endif

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
// for those.

- (void) dispatch_async:(dispatch_block_t) block;

- (void) dispatch_sync:(dispatch_block_t) block;

- (void) dispatch_after:(NSTimeInterval) seconds block:(dispatch_block_t) block;

- (void) dispatch_target:(id) target action:(SEL) action;

- (void) dispatch_target:(id) target action:(SEL) action withObject:(id) object;

@end

#define FLTimeIntervalToNanoSeconds(TIME_INTERVAL) (TIME_INTERVAL * NSEC_PER_SEC)


