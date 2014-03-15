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

- (void) queueOperation:(id<FLQueueableAsyncOperation>) object
                    withDelay:(NSTimeInterval) delay
                     finisher:(FLFinisher*) finisher;

- (FLPromisedResult) runSynchronously:(id<FLQueueableAsyncOperation>) asyncObject;

@end
