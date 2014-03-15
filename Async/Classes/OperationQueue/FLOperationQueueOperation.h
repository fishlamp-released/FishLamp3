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
    UInt32 _maxConcurrentOperations;
    NSMutableArray* _objects;
}

// this is queried live, so changing it while operation is running is supported
// and queue will adjust.
@property (readwrite, assign) UInt32 maxConcurrentOperations;

- (void) queueObjectsFromArray:(NSArray*) array;
- (void) queueObject:(id) object;

@end


@interface FLOperationQueueOperation (GlobalDefault)

+ (void) setDefaultMaxConcurrentOperations:(UInt32) threadCount;

+ (UInt32) defaultMaxConcurrentOperations;
@end
