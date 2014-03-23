//
//  FLOldOperationQueue.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if 0

#import "FishLampCore.h"
#import "FLOperation.h"
#import "FLDispatchQueues.h"
#import "FLAsyncQueue.h"
#import "FLBroadcaster.h"

@class FLFifoDispatchQueue;
@class FLOperation;

@protocol FLOldOperationQueueOperationFactory;
@protocol FLOldOperationQueueErrorStrategy;

@interface FLOldOperationQueue : FLOperation {
@private
    FLFifoDispatchQueue* _schedulingQueue;
    NSMutableArray* _objectQueue;
    NSMutableArray* _activeQueue;
    NSMutableArray* _operationFactories;
    id<FLOldOperationQueueErrorStrategy> _errorStrategy;

    UInt32 _maxOperationsCount;
    NSInteger _finishedCount;
    NSInteger _totalCount;
    BOOL _processing;
}

// concurrent operations, defaults to 1
@property (readwrite, assign) UInt32 maxConcurrentOperations;

- (id) initWithErrorStrategy:(id<FLOldOperationQueueErrorStrategy>) errorStrategy;

+ (id) operationQueue;
+ (id) operationQueueWithErrorStrategy:(id<FLOldOperationQueueErrorStrategy>) errorStrategy;

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

///    add factory for creating operations to be executed in the operation queue.
- (void) addOperationFactory:(id<FLOldOperationQueueOperationFactory>) factory;


// optional overrides

- (void) willStartOperation:(FLOperation*) operation
            forQueuedObject:(id) object;

- (void) didFinishOperation:(FLOperation*) operation
            forQueuedObject:(id) object
                 withResult:(FLPromisedResult) result;

- (FLOperation*) createOperationForQueuedObject:(id) object;

// normall sends FLSuccessfulResult. Override this for more specific results.
- (id) operationQueueSuccessfullResult;

@end


@protocol FLQueuedObject <NSObject>
@optional
- (FLOperation*) createOperationForOperationQueue:(FLOldOperationQueue*) operationQueue;
@end

@protocol FLOldOperationQueueOperationFactory <NSObject>
- (FLOperation*) createOperationForQueuedObject:(id) object;
@end

@protocol FLOldOperationQueueListener <NSObject>

- (void) operationQueueDidStart:(FLOldOperationQueue*) operationQueue;

- (void) operationQueue:(FLOldOperationQueue*) operationQueue
    didFinishWithResult:(FLPromisedResult) result;

- (void) operationQueue:(FLOldOperationQueue*) operationQueue
      didStartOperation:(FLOperation*) operation
        forQueuedObject:(id) object;

- (void) operationQueue:(FLOldOperationQueue*) operationQueue
     didFinishOperation:(FLOperation*) operation
        forQueuedObject:(id) object
             withResult:(FLPromisedResult) result;
@end


#endif