//
//  FLAbstractAsyncQueue.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAsyncQueue.h"
#import "FLPromise.h"
#import "FLFinisher.h"
#import "FLBroadcaster.h"

@interface FLAbstractAsyncQueue : FLBroadcaster<FLAsyncQueue>

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) operation
                 withDelay:(NSTimeInterval) delay
                completion:(fl_completion_block_t) completionOrNil;

- (FLPromisedResult) runSynchronously:(id<FLQueueableAsyncOperation>) asyncObject;
@end
