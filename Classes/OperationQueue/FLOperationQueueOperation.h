//
//  FLOperationQueueOperation.h
//  Pods
//
//  Created by Mike Fullerton on 2/1/14.
//
//

#import "FLOperation.h"
#import "FLOperationQueue.h"

#define FLDefaultConconcurrentOperationCount 2

@interface FLOperationQueueOperation : FLOperation<FLOperationQueueDelegate> {
@private
    FLOperationQueue* _operationQueue;
    UInt32 _macConcurrentOperations;
}

// this is queried live.
@property (readwrite, assign) UInt32 maxConcurrentOperations;

- (void) willStartWithOperationQueue:(FLOperationQueue*) queue;

// required overrides
- (FLOperation*) operationQueue:(FLOperationQueue*) operationQueue
 createOperationForQueuedObject:(id) object;

// optional overrides
- (void) operationQueue:(FLOperationQueue*) operationQueue
     willStartOperation:(FLOperation*) operation
        forQueuedObject:(id) object;

- (void) operationQueue:(FLOperationQueue*) operationQueue
     didFinishOperation:(FLOperation*) operation
        forQueuedObject:(id) object
             withResult:(FLPromisedResult) result;

@end
