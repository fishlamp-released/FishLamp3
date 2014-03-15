//
//  FLBatchOperation.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 8/25/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//
#if REFACTOR

#import "FishLampCore.h"
#import "FLOperation.h"
#import "FLOperationQueue.h"

@interface FLBatchOperation : FLOperation {
@private
    FLOperationQueue* _operationQueue;
}
@property (readonly, strong) FLOperationQueue* operationQueue;

- (id) initWithQueuedObjects:(NSArray*) objects; 
+ (id) batchOperation:(NSArray*) queuedObjects;

@end
#endif