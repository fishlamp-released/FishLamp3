//
//  FLOperationQueueErrorStrategy.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
@class FLOperationQueue;

@protocol FLOperationQueueErrorStrategy <NSObject>
- (void) operationQueue:(FLOperationQueue*) operationQueue
       encounteredError:(NSError*) error;
//- (void) operationQueueWasCancelled:(FLOperationQueue*) queue;
//- (void) operationQueueDidBeginProcessing:(FLOperationQueue*) operationQueue;
- (BOOL) operationQueueWillHalt:(FLOperationQueue*) operationQueue;
- (NSError*) errorResult;
@end

@interface FLSingleErrorOperationQueueStrategy : NSObject<FLOperationQueueErrorStrategy> {
@private
    NSError* _error;
}
@property (readwrite, strong) NSError* error;

+ (id) singleErrorOperationQueueStrategy;

@end
