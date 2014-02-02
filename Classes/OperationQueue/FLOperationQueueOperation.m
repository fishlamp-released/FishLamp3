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
@end

@implementation FLOperationQueueOperation

@synthesize operationQueue = _operationQueue;
@synthesize maxConcurrentOperations = _maxConcurrentOperations;

- (id) init {	
	self = [super init];
	if(self) {
		self.maxConcurrentOperations = FLDefaultConconcurrentOperationCount;
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_operationQueue release];
	[super dealloc];
}
#endif

- (void) willStartWithOperationQueue:(FLOperationQueue*) queue {

}

- (void) startOperation:(FLFinisher *)finisher {

    self.operationQueue = [FLOperationQueue operationQueue:self];

    [self willStartWithOperationQueue:self.operationQueue];

    FLAssert(self.maxConcurrentOperations >= 1);

    [self.context setFinisher:finisher forOperation:self];
}

- (void) operationQueue:(FLOperationQueue*) operationQueue
         startOperation:(FLOperation*) operation
             completion:(fl_completion_block_t) completion {

    FLAssertNotNil(self.context);
    [self.context queueOperation:operation completion:completion];
}

- (BOOL) operationQueue:(FLOperationQueue*) operationQueue
shouldStartAnotherOperation:(NSInteger) activeOperationCount {

    return activeOperationCount < self.maxConcurrentOperations;
}

- (FLOperation*) operationQueue:(FLOperationQueue*) operationQueue
 createOperationForQueuedObject:(id) object {
    return nil;
}

- (void) operationQueue:(FLOperationQueue*) operationQueue
     willStartOperation:(FLOperation*) operation
        forQueuedObject:(id) object {
}

- (void) operationQueue:(FLOperationQueue*) operationQueue
     didFinishOperation:(FLOperation*) operation
        forQueuedObject:(id) object
             withResult:(FLPromisedResult) result {

    if([result isError]) {
        [operationQueue setFinishedWithResult:result];
    }
}

// normall sends FLSuccessfulResult. Override this for more specific results.
- (id) operationQueueSuccessfullResult {
    return FLSuccessfulResult;
}

- (void) operationQueue:(FLOperationQueue*) operationQueue
    didFinishProcessingWithResult:(FLPromisedResult) result {

    FLFinisher* finisher = [self.context popFinisherForOperation:self];
    FLAssertNotNil(finisher);

    if([result isError]) {
        [finisher setFinishedWithResult:result];
    }
    else {
        [finisher setFinishedWithResult:[self operationQueueSuccessfullResult]];
    }

    self.operationQueue = nil;
}

@end
