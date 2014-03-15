//
//  FLOperationQueue.h
//  Pods
//
//  Created by Mike Fullerton on 2/1/14.
//
//

#import "FishLampCore.h"
#import "FLOperation.h"
#import "FLPromisedResult.h"
#import "FLAsyncBlockTypes.h"
#import "FLOperationQueueState.h"

@protocol FLOperationQueueDelegate;
@class FLFifoDispatchQueue;


@interface FLOperationQueue : NSObject {
@private
    __unsafe_unretained id<FLOperationQueueDelegate> _delegate;
    FLFifoDispatchQueue* _schedulingQueue;
    NSMutableArray* _objectQueue;
    NSMutableArray* _activeQueue;
    UInt64 _processedCount;
    UInt64 _totalCount;
    UInt64 _queuedCount;
    FLOperationQueueState _queueState;
    BOOL _isFinished;

    id _result;
}

@property (readonly, assign) BOOL isFinished;

@property (readonly, assign) FLOperationQueueState queueState;

- (id) initWithDelegate:(id<FLOperationQueueDelegate>) delegate;

+ (id) operationQueue:(id<FLOperationQueueDelegate>) delegate;

- (void) requestCancel;

- (void) setFinishedWithResult:(id) result;

- (void) queueObjectsFromArray:(NSArray*) queuedObjects;

/// an object can be anything
- (void) queueObject:(id) object;

@end

@protocol FLOperationQueueDelegate <NSObject>

@optional

/// handle the queue finishing
/// to process more, just add stuff to the queue.
/// if this is not defined by the delegate, the result (if any)
/// is disregarded and the queue reverts back to an empty
/// state.
- (void) operationQueue:(FLOperationQueue*) operationQueue
    didFinishProcessingWithResult:(FLPromisedResult) result;


/// create an operation for the object. if you've queued operations,
/// this will not be called.
- (FLOperation*) operationQueue:(FLOperationQueue*) operationQueue
 createOperationForQueuedObject:(id) object;

/// if delegate doesn't define this, the operation starts in the default operation context
- (void) operationQueue:(FLOperationQueue*) operationQueue
         startOperation:(FLOperation*) operation
             completion:(fl_completion_block_t) completion;

/// this is called while processing the queue. override this to limit the number
/// of concurrent operations (you can examine queueState), or for throttling the
/// queue in whatever way you need to.
- (BOOL) operationQueueShouldStartAnotherOperation:(FLOperationQueue*) operationQueue;

/// this is just a notification that the operation will begin
- (void) operationQueue:(FLOperationQueue*) operationQueue
     willStartOperation:(FLOperation*) operation
        forQueuedObject:(id) object;

/// this is just a notification that the operation did finish
/// note that you can call [queue setFinishWithResult:result]
/// to halt the queue. All pending operations are cancelled.
- (void) operationQueue:(FLOperationQueue*) operationQueue
     didFinishOperation:(FLOperation*) operation
        forQueuedObject:(id) object
             withResult:(FLPromisedResult) result;

/// called each time the queue is updated or processed.
/// you can add stuff to the queue here for example.
- (void) operationQueueIsProcessing:(FLOperationQueue*) operationQueue;

@end

