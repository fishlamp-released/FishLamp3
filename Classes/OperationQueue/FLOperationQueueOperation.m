//
//  FLOperationQueueOperation.m
//  Pods
//
//  Created by Mike Fullerton on 2/1/14.
//
//

#import "FLOperationQueueOperation.h"
#import "FLOperationContext.h"

@interface FLOperationQueueOperation ()
@property (readwrite, strong) FLOperationQueue* operationQueue;
@property (readwrite, strong, nonatomic) NSArray* objects;
@end

@implementation FLOperationQueueOperation

static UInt32 s_defaultMaxConcurrentOperations = FLDefaultConconcurrentOperationCount;

@synthesize operationQueue = _operationQueue;
@synthesize objects = _objects;

#if FL_MRC
- (void)dealloc {
    [_objects release];
	[_operationQueue release];
	[super dealloc];
}
#endif

- (void) willStartWithOperationQueue:(FLOperationQueue*) queue {

}


- (NSMutableArray*) objectsArray {
    if(!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    return _objects;
}

- (NSArray*) popQueuedObjects {

    NSArray* outArray = nil;
    @synchronized(self) {
        outArray = FLRetainWithAutorelease(_objects);
        self.objects = nil;
    }

    return outArray;
}

- (void) queueObjectsFromArray:(NSArray*) array {

    @synchronized(self) {
        [[self objectsArray] addObjectsFromArray:array];
    }
}

- (void) queueObject:(id) object {
    @synchronized(self) {
        [[self objectsArray] addObject:object];
    }
}

- (void) startOperation:(FLFinisher *)finisher {

    FLAssert(self.maxConcurrentOperations >= 1);
    [self.context setFinisher:finisher forOperation:self];

    self.operationQueue = [FLOperationQueue operationQueue:self];
    [self.operationQueue queueObjectsFromArray:[self popQueuedObjects]];
}

- (void) operationQueue:(FLOperationQueue*) operationQueue
         startOperation:(FLOperation*) operation
             completion:(fl_completion_block_t) completion {

    FLAssertNotNil(self.context);
    [self.context queueOperation:operation completion:completion];
}

- (BOOL) operationQueueShouldStartAnotherOperation:(FLOperationQueue*) operationQueue {

    BOOL result = operationQueue.queueState.currentCount <= self.maxConcurrentOperations;

    return result;
}

- (void) operationQueueIsProcessing:(FLOperationQueue*) operationQueue {

    NSArray* objects = [self popQueuedObjects];

    if(objects) {
        [operationQueue queueObjectsFromArray:objects];
    }
}

- (FLOperation*) operationQueue:(FLOperationQueue*) operationQueue
 createOperationForQueuedObject:(id) object {

    return object;
}

- (void) operationQueue:(FLOperationQueue*) operationQueue
     willStartOperation:(FLOperation*) operation
        forQueuedObject:(id) object {

    [operation.events addListener:self sendEventsOnMainThread:NO];
}

- (void) operationQueue:(FLOperationQueue*) operationQueue
     didFinishOperation:(FLOperation*) operation
        forQueuedObject:(id) object
             withResult:(FLPromisedResult) result {

    [operation removeListener:self];

    if([result isError]) {
        [operationQueue setFinishedWithResult:result];
    }
}

- (void) setFinishedWithResult:(id) result {
    FLFinisher* finisher = [self.context popFinisherForOperation:self];
    FLAssertNotNil(finisher);
    [finisher setFinishedWithResult:result];
}

- (void) operationQueue:(FLOperationQueue*) operationQueue
    didFinishProcessingWithResult:(FLPromisedResult) result {

    [self setFinishedWithResult:result];
}

- (void) setMaxConcurrentOperations:(UInt32)maxConcurrentOperations {
    FLAtomicSetInt32(_maxConcurrentOperations, maxConcurrentOperations);
}

- (UInt32) maxConcurrentOperations {
    UInt32 count = FLAtomicGetInt32(_maxConcurrentOperations);
    return count != 0 ? count : [[self class] defaultMaxConcurrentOperations];
}

+ (void) setDefaultMaxConcurrentOperations:(UInt32) threadCount {
    FLAtomicSetInt32(s_defaultMaxConcurrentOperations, threadCount);
}

+ (UInt32) defaultMaxConcurrentOperations {
    return FLAtomicGetInt32(s_defaultMaxConcurrentOperations);
}

@end
