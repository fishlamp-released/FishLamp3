//
//  FLDispatchQueue+SharedQueues.m
//  FishLamp
//
//  Created by Mike Fullerton on 1/4/14.
//  Copyright (c) 2014 Mike Fullerton. All rights reserved.
//

#import "FLDispatchQueues.h"

#import "FLMainThreadDispatchQueue.h"

@implementation FLDispatchQueue (SharedQueues)

+ (FLConcurrentDispatchQueue*) lowPriorityQueue {
    FLReturnStaticObject( [[FLConcurrentDispatchQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)]);
}

+ (FLConcurrentDispatchQueue*) defaultQueue {
    FLReturnStaticObject( [[FLConcurrentDispatchQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)]);
}

+ (FLConcurrentDispatchQueue*) highPriorityQueue {
    FLReturnStaticObject([[FLConcurrentDispatchQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)]);
}

+ (FLConcurrentDispatchQueue*) veryLowPriorityQueue {
    FLReturnStaticObject([[FLConcurrentDispatchQueue alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)]);
}

+ (FLMainThreadDispatchQueue*) mainThreadQueue {
    return [FLMainThreadDispatchQueue instance];
}

+ (FLFifoDispatchQueue*) fifoQueue {
    FLReturnStaticObject([FLFifoDispatchQueue fifoDispatchQueue]);
}

@end
