//
//  FLOperationQueue.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOperationQueue.h"
#import "FLDispatchQueue.h"
#import "FLLog.h"
#import "FLSuccessfulResult.h"
#import "FLOperation.h"
#import "FLOperationContext.h"
#import "FLOperationQueueErrorStrategy.h"

// #import "FLTrace.h"

@interface FLOperationQueue ()
@property (readwrite, assign) NSInteger finishedCount;
@property (readwrite, assign) NSInteger totalCount;
@property (readwrite, assign) BOOL processing;
@property (readonly, strong) NSMutableArray* operationFactories;
@property (readonly, strong) NSMutableArray* activeQueue;
@property (readonly, strong) NSMutableArray* objectQueue;
@property (readonly, strong) FLFifoAsyncQueue* schedulingQueue;
@property (readwrite, assign) UInt32 maxOperationsCount;

@property (readonly, strong) id<FLOperationQueueErrorStrategy> errorStrategy;


@end

@interface FLOperationQueue (SchedulingQueue)
- (void) respondToProcessQueueEvent;
- (void) respondToCancelEvent;
- (void) respondToAddObjectArrayEvent:(NSArray*) array;
- (void) respondToAddObjectEvent:(id) object;
@end

@implementation NSObject (FLOperationQueue)
- (FLOperation*) createOperationForOperationQueue:(FLOperationQueue*) operationQueue {
    return nil;
}
@end

@implementation FLOperation (FLOperationQueue)
- (FLOperation*) createOperationForOperationQueue:(FLOperationQueue*) operationQueue {
    return self;
}
@end

@implementation FLOperationQueue

@synthesize maxOperationsCount = _maxOperationsCount;
@synthesize finishedCount = _finishedCount;
@synthesize totalCount = _totalCount;
@synthesize processing = _processing;
@synthesize activeQueue = _activeQueue;
@synthesize objectQueue = _objectQueue;
@synthesize schedulingQueue = _schedulingQueue;
@synthesize errorStrategy = _errorStrategy;

FLSynthesizeLazyGetter(operationFactories, NSMutableArray*, _operationFactories, NSMutableArray);

- (id) initWithErrorStrategy:(id<FLOperationQueueErrorStrategy>) errorStrategy {
	self = [super init];
	if(self) {
        _schedulingQueue = [[FLFifoAsyncQueue alloc] init];
        _activeQueue = [[NSMutableArray alloc] init];
        _objectQueue = [[NSMutableArray alloc] init];
        _maxOperationsCount = INT_MAX;

        if(errorStrategy) {
            _errorStrategy = FLRetain(errorStrategy);
        }
        else {
            _errorStrategy = [[FLSingleErrorOperationQueueStrategy alloc] init];
        }
	}
	return self;
}

- (id) init {
    return [self initWithErrorStrategy:nil];
}

+ (id) operationQueue {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) operationQueueWithErrorStrategy:(id<FLOperationQueueErrorStrategy>) errorStrategy {
    return FLAutorelease([[[self class] alloc] initWithErrorStrategy:errorStrategy]);
}

- (void) addOperationFactory:(id<FLOperationQueueOperationFactory>)factory {
    FLAssertNotNil(factory);
    FLAssert(self.processing == NO, @"can't add a factory while processing");

    [self.operationFactories addObject:factory];
}

- (void) startOperation {
    [self startProcessing];
}

- (UInt32) maxConcurrentOperations {
    return self.maxOperationsCount;
}

- (void) setMaxConcurrentOperations:(UInt32) max {
    self.maxOperationsCount = max;

    if(self.processing) {
        [self processQueue];
    }
}

- (void) willStartOperation:(FLOperation*) operation
            forQueuedObject:(id) object {


    [FLBackgroundQueue queueBlock:^{
        [self sendMessageToListeners:@selector(operationQueue:didStartOperation:forQueuedObject:)
                          withObject:self
                          withObject:operation
                          withObject:object];
        
//          operationQueue:self
//                           didStartOperation:operation
//                             forQueuedObject:object];
        }];
}

- (void) didFinishOperation:(FLOperation*) operation
            forQueuedObject:(id) object
                 withResult:(FLPromisedResult) result {

        [self sendMessageToListeners:@selector(operationQueue:didFinishOperation:forQueuedObject:withResult:)
                          withObject:self
                          withObject:operation
                          withObject:object
                          withObject:result];


//    [FLBackgroundQueue queueBlock:^{
//        [self.notify operationQueue:self
//                           didFinishOperation:operation
//                             forQueuedObject:object
//                                   withResult:result];
//    }];
}

- (void) setFinishedWithResult:(FLPromisedResult) result {
    [super setFinishedWithResult:result];
    self.processing = NO;
    [self sendMessageToListeners:@selector(operationQueue:didFinishWithResult:) withObject:self withObject:self];
    
//        operationQueue:self
//                      didFinishWithResult:result];
}

- (void) processQueue {
    [self.schedulingQueue queueTarget:self action:@selector(respondToProcessQueueEvent)];
}

- (void) queueObjectsInArray:(NSArray*) queuedObjects {
    [self.schedulingQueue queueTarget:self action:@selector(respondToAddObjectArrayEvent:) withObject:queuedObjects];
}

- (void) queueObject:(id) object {
    [self.schedulingQueue queueTarget:self action:@selector(respondToAddObjectEvent:) withObject:object];
}

- (void) queueOperation:(FLOperation*) operation {
    [self.schedulingQueue queueTarget:self action:@selector(respondToAddObjectEvent:) withObject:operation];
}

- (void) startProcessing {

    FLAssertNotNil(self.context);
    FLAssert(self.maxConcurrentOperations > 1);
    FLAssertNotNil(self.schedulingQueue);
    FLAssert(self.processing == NO);
    FLAssertNotNil(self.objectQueue);
    FLAssertNotNil(self.activeQueue);
    FLAssertNotNil(self.context);

    self.processing = YES;
    [self processQueue];
}

- (void) stopProcessing {
    FLAssertNotNil(self.context);
    self.processing = NO;
}

- (void) requestCancel {
    FLAssertNotNil(self.context);

    [super requestCancel];
    [self.schedulingQueue queueTarget:self action:@selector(respondToCancelEvent)];
}

#if FL_MRC 
- (void) dealloc {
    [_schedulingQueue release];
    [_objectQueue release];
    [_activeQueue release];
    [_operationFactories release];
    [_errorStrategy release];
    [super dealloc];
}
#endif

- (void) sendCancelRequests {
    for(FLOperation* operation in self.activeQueue) {
        FLTrace(@"operation queue cancelled: %@", [operation description]);
        [operation requestCancel];
    }
    FLTrace(@"cancelled %ld queued operations", (long) _objectQueue.count);
}

- (void) respondToCancelEvent {
    [self sendCancelRequests];
    [self respondToProcessQueueEvent];
}

- (void) respondToAddObjectArrayEvent:(NSArray*) array {
    [_objectQueue addObjectsFromArray:array];
    self.totalCount += array.count;
    [self processQueue];
}

- (void) respondToAddObjectEvent:(id) object {
    [_objectQueue addObject:object];
    self.totalCount ++;
    [self processQueue];
}

- (void) respondToOperationFinished:(FLOperation*) operation
                    forQueuedObject:(id) queuedObject
                         withResult:(FLPromisedResult) result {

    self.finishedCount++;

    if([result isError]) {
        [self.errorStrategy operationQueue:self encounteredError:result];
    }

    FLTrace(@"finished operation: %@ withResult: %@",
            operation,
            [result isError] ? result : @"OK");

    [self didFinishOperation:operation forQueuedObject:queuedObject withResult:result];

    [_activeQueue removeObject:operation];
    [self respondToProcessQueueEvent];
}

- (FLOperation*) createOperationForQueuedObject:(id) object {

    FLOperation* operation = [object createOperationForOperationQueue:self];

    if(!operation) {
        for(id<FLOperationQueueOperationFactory> factory in _operationFactories) {
            operation = [factory createOperationForQueuedObject:object];

            if(operation) {
                break;
            }
        }
    }

    FLAssertNotNil(operation, @"no operation created for queue for: %@", [object description]);

    return operation;
}

- (void) startOperationForObject:(id) object {
    FLOperation* operation = [self createOperationForQueuedObject:object];
    [operation addListener:self];

    [_activeQueue addObject:operation];

    [self willStartOperation:operation forQueuedObject:object];
    
    FLTrace(@"starting operation: %@, queued object: %@",
        NSStringFromClass([operation class]),
        [object description]);

    FLAssertNotNil(self.context);

// TODO: give operations chance to run in whatever queue they want?
    [self.context queueOperation:operation
                        completion:^(FLPromisedResult result) {

        [self.schedulingQueue queueBlock: ^{
            [self respondToOperationFinished:operation forQueuedObject:object withResult:result];
        }];
    }];
}

- (BOOL) shouldStartAnotherOperation {
    return  self.processing &&
            !self.wasCancelled &&
            ![self.errorStrategy operationQueueWillHalt:self] &&
            _activeQueue.count < self.maxConcurrentOperations &&
            _objectQueue.count > 0;
}

- (BOOL) shouldFinish {
    return  _activeQueue.count == 0 && _objectQueue.count == 0;
}

- (void) respondToProcessQueueEvent {
    if(self.processing) {
        FLAssert(self.maxConcurrentOperations > 0, @"zero max concurrent operations");
        FLTrace(@"max connections: %d", self.maxConcurrentOperations);

        while([self shouldStartAnotherOperation]) {

            id obj = FLRetainWithAutorelease([_objectQueue objectAtIndex:0]);
            [_objectQueue removeObjectAtIndex:0];

            [self startOperationForObject:obj];
        }

        if([self shouldFinish]) {

            id result = [self.errorStrategy errorResult];
            if(!result) {
                result = FLSuccessfulResult;
            }

            [self setFinishedWithResult:result];
        }
    }
}
@end

