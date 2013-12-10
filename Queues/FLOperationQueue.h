//
//  FLOperationQueue.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLOperation.h"
#import "FLDispatchQueue.h"
#import "FLAsyncQueue.h"
#import "FLBroadcaster.h"

@class FLFifoAsyncQueue;
@class FLOperation;

@protocol FLOperationQueueOperationFactory;
@protocol FLOperationQueueErrorStrategy;

@interface FLOperationQueue : FLOperation {
@private
    FLFifoAsyncQueue* _schedulingQueue;
    NSMutableArray* _objectQueue;
    NSMutableArray* _activeQueue;
    NSMutableArray* _operationFactories;
    id<FLOperationQueueErrorStrategy> _errorStrategy;

    UInt32 _maxOperationsCount;
    NSInteger _finishedCount;
    NSInteger _totalCount;
    BOOL _processing;
}

// concurrent operations, defaults to 1
@property (readwrite, assign) UInt32 maxConcurrentOperations;

- (id) initWithErrorStrategy:(id<FLOperationQueueErrorStrategy>) errorStrategy;

+ (id) operationQueue;
+ (id) operationQueueWithErrorStrategy:(id<FLOperationQueueErrorStrategy>) errorStrategy;

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
- (void) startProcessing;

///    tell the queue to stop.
///    Note the currently executing operations will finish before it stops.
- (void) stopProcessing;

///    cancel all the operations and stop processing
- (void) requestCancel;

///    add factory for creating operations to be executed in the operation queue.
- (void) addOperationFactory:(id<FLOperationQueueOperationFactory>) factory;


// optional overrides

- (void) willStartOperation:(FLOperation*) operation
            forQueuedObject:(id) object;

- (void) didFinishOperation:(FLOperation*) operation
            forQueuedObject:(id) object
                 withResult:(FLPromisedResult) result;

- (FLOperation*) createOperationForQueuedObject:(id) object;
@end


@protocol FLQueuedObject <NSObject>
@optional
- (FLOperation*) createOperationForOperationQueue:(FLOperationQueue*) operationQueue;
@end

@protocol FLOperationQueueOperationFactory <NSObject>
- (FLOperation*) createOperationForQueuedObject:(id) object;
@end

@protocol FLOperationQueueListener <NSObject>

- (void) operationQueueDidStart:(FLOperationQueue*) operationQueue;

- (void) operationQueue:(FLOperationQueue*) operationQueue
    didFinishWithResult:(FLPromisedResult) result;

- (void) operationQueue:(FLOperationQueue*) operationQueue
      didStartOperation:(FLOperation*) operation
        forQueuedObject:(id) object;

- (void) operationQueue:(FLOperationQueue*) operationQueue
     didFinishOperation:(FLOperation*) operation
        forQueuedObject:(id) object
             withResult:(FLPromisedResult) result;
@end


