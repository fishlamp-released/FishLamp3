//
//  FLBatchOperation.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 8/25/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLBatchOperation.h"
#import "FLOperationQueue.h"

#if REFACTOR

@implementation FLBatchOperation

@synthesize operationQueue = _operationQueue;

- (id) initWithQueuedObjects:(NSArray*) objects {
    self = [super init];
    if(self) {
		_operationQueue = [[FLBatchOperationQueue alloc] init];
        [_operationQueue addListener:self];
///        [_operationQueue addListener:self.observers.nonretained_fl];

        if(objects) {
            [_operationQueue queueObjectsInArray:objects];
        }
    }

    return self;
}

+ (id) batchOperation:(NSArray*) queuedObjects {
    return FLAutorelease([[[self class] alloc] initWithQueuedObjects:queuedObjects]);
}

- (id) init {	
	return [self initWithQueuedObjects:nil];
}

- (void) operationQueue:(FLOperationQueue*) operationQueue
didFinishFinishWithResult:(FLPromisedResult) result {
    [self setFinishedWithResult:result];
}

- (void) startOperation {
    [self.operationQueue startProcessing];
}

- (void) requestCancel {
    [super requestCancel];
    [self.operationQueue requestCancel];
}
@end

#endif