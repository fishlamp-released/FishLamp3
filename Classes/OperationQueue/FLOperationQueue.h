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

@protocol FLOperationQueueDelegate;
@class FLFifoDispatchQueue;


@interface FLOperationQueue : NSObject {
@private
    __unsafe_unretained id<FLOperationQueueDelegate> _delegate;
    FLFifoDispatchQueue* _schedulingQueue;
    NSMutableArray* _objectQueue;
    NSMutableArray* _activeQueue;
    NSInteger _finishedCount;
    NSInteger _totalCount;
    id _result;
}

@property (readonly, assign) NSInteger totalCount;
@property (readonly, assign) NSInteger processedCount;

- (id) initWithDelegate:(id<FLOperationQueueDelegate>) delegate;

+ (id) operationQueue:(id<FLOperationQueueDelegate>) delegate;

- (void) requestCancel;

- (void) setFinishedWithResult:(id) result;

- (void) queueObjectsFromArray:(NSArray*) queuedObjects;
- (void) queueObject:(id) object;

@end

@protocol FLOperationQueueDelegate <NSObject>

- (void) operationQueue:(FLOperationQueue*) operationQueue
         startOperation:(FLOperation*) operation
             completion:(fl_completion_block_t) completion;

- (BOOL) operationQueue:(FLOperationQueue*) operationQueue
shouldStartAnotherOperation:(NSInteger) activeOperatinCount;

- (FLOperation*) operationQueue:(FLOperationQueue*) operationQueue
 createOperationForQueuedObject:(id) object;

- (void) operationQueue:(FLOperationQueue*) operationQueue
     willStartOperation:(FLOperation*) operation
        forQueuedObject:(id) object;

- (void) operationQueue:(FLOperationQueue*) operationQueue
     didFinishOperation:(FLOperation*) operation
        forQueuedObject:(id) object
             withResult:(FLPromisedResult) result;

- (void) operationQueue:(FLOperationQueue*) operationQueue
    didFinishProcessingWithResult:(FLPromisedResult) result;

@end




#if 0
#import "FLFinisher.h"
#import "FLOperationQueue.h"
@class FLOperationQueue;
@interface FLOperationQueue : NSObject<FLOperationQueueDelegate> {
@private
    FLOperationQueue* _processor;
    UInt32 _maxConcurrentOperations;
}

// concurrent operations, defaults to 1
@property (readwrite, assign) UInt32 maxConcurrentOperations;

// info
@property (readonly, assign) NSInteger finishedCount;

@property (readonly, assign) NSInteger totalCount;

///    objects that are queued will attempt to create an operation when it is their turn to execute.
///    Will try to get operation in following order
///    1. [object createOperationForOperationQueue];
///    2. iterate through operationQueue's factory list.
- (void) queueObject:(id) object;

///    see queueOperation comment.
///    Note it is more efficient to send in an array than individual objects.
- (void) queueObjectsInArray:(NSArray*) queuedObjects;

///    operations that are queued don't get sent through factories.
- (void) queueOperation:(FLOperation*) operation;

///    start the queue.
- (void) startProcessing:(FLFinisher*) finisher;

///    tell the queue to stop.
///    Note the currently executing operations will finish before it stops.
- (void) stopProcessing;

///    cancel all the operations and stop processing
- (void) requestCancel;


- (void) willStartOperation:(FLOperation*) operation
            forQueuedObject:(id) object;

- (void) didFinishOperation:(FLOperation*) operation
            forQueuedObject:(id) object
                 withResult:(FLPromisedResult) result;

- (FLOperation*) createOperationForQueuedObject:(id) object;

// normall sends FLSuccessfulResult. Override this for more specific results.
- (id) operationQueueSuccessfullResult;

- (void) startOperation:(FLOperation*) operation completion:(fl_completion_block_t) completion;

- (BOOL) shouldStartAnotherOperation:(NSInteger) processingCount;

@end
#endif