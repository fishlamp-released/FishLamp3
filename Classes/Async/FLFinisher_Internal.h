//
//  FLFinisher_Internal.h
//  Pods
//
//  Created by Mike Fullerton on 1/25/14.
//
//

#import "FLFinisher.h"

@protocol FLAsyncQueue;

@interface FLFinisher ()

// this is an optimization to only create one object per execution
@property (readwrite, copy, nonatomic) fl_block_t asyncQueueBlock;
@property (readwrite, copy, nonatomic) fl_finisher_block_t asyncQueueFinisherBlock;

- (void) startAsyncOperationInQueue:(id<FLAsyncQueue>) queue
                           finisher:(FLFinisher *)finisher;

- (void) runSynchronousOperationInQueue:(id<FLAsyncQueue>) queue
                               finisher:(FLFinisher *)finisher;

@end
