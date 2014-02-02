//
//  FLLimitedOperationQueueOperation.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLOperationQueueOperation.h"

#define FLBatchOperationQueueMaxOperations 2

@interface FLLimitedOperationQueueOperation : FLOperationQueueOperation
+ (void) setDefaultConnectionLimit:(UInt32) threadCount;
+ (UInt32) defaultConnectionLimit;
@end