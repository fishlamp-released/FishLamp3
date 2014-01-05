//
//  FLDispatchQueue+SharedQueues.h
//  FishLamp
//
//  Created by Mike Fullerton on 1/4/14.
//  Copyright (c) 2014 Mike Fullerton. All rights reserved.
//

#import "FLDispatchQueue.h"
#import "FLFifoDispatchQueue.h"
#import "FLConcurrentDispatchQueue.h"
#import "FLMainThreadDispatchQueue.h"

@interface FLDispatchQueue (SharedQueues)

// See Helper Macros below

// 
// Shared Concurrent Queues
//

+ (FLConcurrentDispatchQueue*) veryLowPriorityQueue;

+ (FLConcurrentDispatchQueue*) lowPriorityQueue;

+ (FLConcurrentDispatchQueue*) defaultQueue;

+ (FLConcurrentDispatchQueue*) highPriorityQueue;

//
// Shared FIFO Queues
//

+ (FLMainThreadDispatchQueue*) mainThreadQueue;

/*!
 *  Returns the shared FIFO queue
 *  Note that this queue runs in the main thread so it's safe to do UI in it.
 *  
 *  @return the fifoQueue
 */
+ (FLFifoDispatchQueue*) fifoQueue;

@end

#define FLForegroundQueue       [FLDispatchQueue mainThreadQueue]
#define FLBackgroundQueue       [FLDispatchQueue defaultQueue]
#define FLFifoQueue             [FLDispatchQueue fifoQueue]
#define FLDefaultQueue          [FLDispatchQueue defaultQueue]
