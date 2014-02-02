//
//  FLOperationQueue.m
//  Pods
//
//  Created by Mike Fullerton on 2/1/14.
//
//
#import "FLOperationQueue.h"
#import "FLFifoDispatchQueue.h"
#import "FLOperation.h"
#import "FishLampSimpleLogger.h"

typedef void (^FLOperationQueueBlock)(FLOperationQueue* operationQueue);

@interface FLOperationQueue ()

// referenced by others, so must be atomic
@property (readwrite, assign) NSInteger totalCount;
@property (readwrite, assign) NSInteger processedCount;


// our stuff is pumped through queue, so doesn't need to be atomic
@property (readonly, strong, nonatomic) NSMutableArray* activeQueue;
@property (readonly, strong, nonatomic) NSMutableArray* objectQueue;
@property (readonly, strong, nonatomic) FLFifoDispatchQueue* schedulingQueue;
@property (readonly, assign, nonatomic) id<FLOperationQueueDelegate> delegate;

@property (readwrite, strong) id result;

- (void) processQueue;

@end

@implementation FLOperationQueue

@synthesize result = _result;
@synthesize delegate = _delegate;
@synthesize activeQueue = _activeQueue;
@synthesize objectQueue = _objectQueue;
@synthesize schedulingQueue = _schedulingQueue;
@synthesize totalCount = _totalCount;
@synthesize processedCount = _processedCount;

- (id) initWithDelegate:(id<FLOperationQueueDelegate>) delegate {
	self = [super init];
	if(self) {
        _delegate = delegate;
        _schedulingQueue = [[FLFifoDispatchQueue alloc] init];
        _activeQueue = [[NSMutableArray alloc] init];
        _objectQueue = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (id) operationQueue:(id<FLOperationQueueDelegate>) delegate {
    return FLAutorelease([[[self class] alloc] initWithDelegate:delegate]);
}

#if FL_MRC 
- (void) dealloc {
    [_result release];
    [_schedulingQueue release];
    [_objectQueue release];
    [_activeQueue release];
    [super dealloc];
}
#endif


- (void) queueBlock:(FLOperationQueueBlock) block {

    FLAssertNotNil(block);

    __block FLOperationQueue* blockSelf = FLRetain(self);

    [_schedulingQueue queueBlock:^{
        if(block) {
            block(blockSelf);
        }

        FLReleaseWithNil(blockSelf);
    }];
}

- (void) queueObjectsFromArray:(NSArray*) array {

    FLAssertNotNil(array);

    if(array) {
        [self queueBlock:^(FLOperationQueue* operationQueue) {

            [operationQueue.objectQueue addObjectsFromArray:array];
            operationQueue.totalCount += array.count;
            [operationQueue processQueue];
        }];
    }
}

- (void) queueObject:(id) object {

    FLAssertNotNil(object);

    if(object) {
        [self queueBlock:^(FLOperationQueue* operationQueue) {

            [operationQueue.objectQueue addObject:object];
            operationQueue.totalCount++;
            [operationQueue processQueue];
        }];
    }
}

- (void) requestCancel {
    [self queueBlock:^(FLOperationQueue* operationQueue) {

        for(FLOperation* operation in operationQueue.activeQueue) {
            FLTrace(@"operation queue cancelled: %@", [operation description]);
            [operation requestCancel];
        }
        FLTrace(@"cancelled %ld queued operations", (long) operationQueue.objectQueue.count);
    }];
}

- (void) startOperationForObject:(id) object {

    FLOperation* operation = [_delegate operationQueue:self 
                        createOperationForQueuedObject:object];

    if(operation) {

        [_activeQueue addObject:operation];

        [_delegate operationQueue:self willStartOperation:operation forQueuedObject:object];

        [self queueBlock:^(FLOperationQueue* operationQueue) {

            [operationQueue.delegate operationQueue:operationQueue startOperation:operation completion:^(FLPromisedResult result) {

                [operationQueue queueBlock:^(FLOperationQueue* operationQueue) {

                    operationQueue.processedCount++;

                    [operationQueue.activeQueue removeObject:operation];

                    [operationQueue.delegate operationQueue:self
                                         didFinishOperation:operation
                                            forQueuedObject:object
                                                 withResult:result];

                    [operationQueue processQueue];
                }];
            }];
        }];
    }
}

- (BOOL) shouldStartOperation {
    return  _result == nil &&
            _objectQueue.count > 0 &&
            [_delegate operationQueue:self shouldStartAnotherOperation:_activeQueue.count];
}

- (BOOL) willFinish {
    return  _activeQueue.count == 0 && _objectQueue.count == 0;
}

- (void) setFinishedWithResult:(id) result {
    self.result = result;
    [self requestCancel];
}

- (void) processQueue {

    while([self shouldStartOperation]) {

        id obj = FLRetainWithAutorelease([_objectQueue objectAtIndex:0]);
        [_objectQueue removeObjectAtIndex:0];

        [self startOperationForObject:obj];
    }

    if([self willFinish]) {
        id result = FLRetainWithAutorelease(_result);
        self.result = nil;
        [_delegate operationQueue:self didFinishProcessingWithResult:result];
    }
}

@end



#if 0
#import "FLOperationQueue.h"
#import "FLOperationQueue.h"

@implementation FLOperationQueue

@synthesize maxConcurrentOperations = _maxConcurrentOperations;

- (id) init {	
	self = [super init];
	if(self) {
		_operationQueue = [[FLOperationQueue alloc] initWithDelegate:self];
	}
	return self;
}

- (void)dealloc {
    [_operationQueue requestCancel];

#if FL_MRC
	[_operationQueue release];
	[super dealloc];
#endif
}

- (FLOperation*) createOperationForQueuedObject:(id) object {

/*
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
*/

    return operation;
}

- (void) queueEncounteredError:(NSError*) error {

}

- (void) requestCancel {
    FLAssertNotNil(self.context);

    [super requestCancel];
    [self.schedulingQueue queueTarget:self action:@selector(respondToCancelEvent)];
}

- (void) startProcessing:(FLFinisher*) finisher {

    FLAssertNotNil(self.context);
    FLAssert(self.maxConcurrentOperations > 1);
    FLAssertNotNil(self.schedulingQueue);
    FLAssert(self.processing == NO);
    FLAssertNotNil(self.objectQueue);
    FLAssertNotNil(self.activeQueue);
    FLAssertNotNil(self.context);

    [self.context setFinisher:finisher forOperation:self];

    self.processing = YES;
    [self processQueue];
}

- (void) stopProcessing {
    FLAssertNotNil(self.context);
    self.processing = NO;
}

- (void) queueObjectsFromArray:(NSArray*) queuedObjects {
    [self.operationQueue queueObjectsFromArray:queuedObjects];
}

- (void) queueObject:(id) object {
    [self.operationQueue queueObject:object];
}

- (void) queueOperation:(FLOperation*) operation {
    [self.operationQueue queueObject:operation];
}

- (void) startOperation:(FLOperation*) operation completion:(fl_completion_block_t) completion {

}

- (BOOL) shouldStartAnotherOperation:(NSInteger) processingCount {

        FLAssert(self.delegate.maxConcurrentOperations > 0, @"zero max concurrent operations");
        FLTrace(@"max connections: %d", self.delegate.maxConcurrentOperations);

    return  self.error != nil &&
            processingCount < self.maxConcurrentOperations;
}

- (id) operationQueueSuccessfullResult {
    return FLSuccessfulResult;
}

- (void) willStartOperation:(FLOperation*) operation
            forQueuedObject:(id) object {

    FLTrace(@"starting operation: %@, queued object: %@",
        NSStringFromClass([operation class]),
        [object description]);

    FLAssertNotNil(self.context);

}


- (void) didFinishProcessingObjectsInQueue:(FLOperationQueue*) operationQueue {

    id result = [self.errorStrategy errorResult];
    if(!result) {
        result = [self operationQueueSuccessfullResult];
    }

    FLFinisher* finisher = [self.context popFinisherForOperation:self];
    FLAssertNotNil(finisher);

    [finisher setFinishedWithResult:result];

}



- (void) didFinishOperation:(FLOperation*) operation
            forQueuedObject:(id) object
                 withResult:(FLPromisedResult) result {

    if([result isError]) {
        [self.errorStrategy operationQueue:self encounteredError:result];
    }

    FLTrace(@"finished operation: %@ withResult: %@",
            operation,
            [result isError] ? result : @"OK");

}


@end
#endif