//
//  FLBatchOperationQueue.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLBatchOperationQueue.h"

@implementation FLBatchOperationQueue : FLOperationQueue

static UInt32 s_threadCount = FLBatchOperationQueueMaxOperations;

- (UInt32) maxConcurrentOperations {
    return s_threadCount;
}

+ (void) setDefaultConnectionLimit:(UInt32) threadCount {
    FLAtomicSetInteger(s_threadCount, threadCount);
}

+ (UInt32) defaultConnectionLimit {
    return FLAtomicGetInteger(s_threadCount);
}

@end
