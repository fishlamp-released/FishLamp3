//
//  FLAbstractDispatcher.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLAsyncBlockTypes.h"
#import "FLPromisedResult.h"
#import "FLOperationStarter.h"

@class FLFinisher;
@class FLPromise;

@protocol FLQueueableAsyncOperation;

@protocol FLAsyncQueue <NSObject, FLOperationStarter>

- (FLPromise*) queueBlockWithDelay:(NSTimeInterval) delay
                             block:(fl_block_t) block
                        completion:(fl_completion_block_t) completionOrNil;

- (FLPromise*) queueBlockWithDelay:(NSTimeInterval) delay
                             block:(fl_block_t) block;

- (FLPromise*) queueBlock:(fl_block_t) block
               completion:(fl_completion_block_t) completionOrNil;

- (FLPromise*) queueBlock:(fl_block_t) block;

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block
                         completion:(fl_completion_block_t) completionOrNil;

- (FLPromise*) queueFinishableBlock:(fl_finisher_block_t) block;

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) operation
                    withDelay:(NSTimeInterval) delay
                   completion:(fl_completion_block_t) completionOrNil;

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) operation
                   completion:(fl_completion_block_t) completionOrNil;

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) operation
                 withListener:(id) listener;

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) operation;

- (FLPromisedResult) runBlockSynchronously:(fl_block_t) block;

- (FLPromisedResult) runFinisherBlockSynchronously:(fl_finisher_block_t) block;

- (FLPromisedResult) runSynchronously:(id<FLQueueableAsyncOperation>) asyncObject;

/*!
 *   sync target/action
 */

 - (FLPromise*) queueTarget:(id) target
                    action:(SEL) action;

- (FLPromise*) queueTarget:(id) target
                    action:(SEL) action
                withObject:(id) object;

- (FLPromise*) queueTarget:(id) target
                    action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2;

- (FLPromise*) queueTarget:(id) target
                    action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3;

- (FLPromise*) queueTarget:(id) target
                    action:(SEL) action
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3
                withObject:(id) object4;

 /*!
  *  Queue a target
  *  
  *  @param target an object
  *  @param action selector with first parameter of FLFinisher.
  *  
  *  @return a Promise
  */
- (FLPromise*) queueTarget:(id) target
                asyncAction:(SEL) action;

- (FLPromise*) queueTarget:(id) target
               asyncAction:(SEL) action
                withObject:(id) object;

- (FLPromise*) queueTarget:(id) target
               asyncAction:(SEL) action
                withObject:(id) object1
                withObject:(id) object2;

- (FLPromise*) queueTarget:(id) target
               asyncAction:(SEL) action
                withObject:(id) object1
                withObject:(id) object2
                withObject:(id) object3;

@end




