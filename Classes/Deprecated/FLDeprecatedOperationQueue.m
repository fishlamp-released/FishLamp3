//
//	FLOperationQueue.m
//	FishLamp
//
//	Created by Mike Fullerton on 9/4/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#if DEPRECATED

#import "FLOperationQueue.h"
#import "FLPerformSelectorOperation.h"
#import "FLCollectionIterator.h"

#if DEBUG
#define LOG 0
#endif
#if LOG
#warning LOG enabled
#endif

@interface FLOperationQueue ()
@property (readwrite, strong, nonatomic) FLOrderedCollection* operations;
@end

@implementation FLOperationQueue

@synthesize operations = _operations;

- (id) init {
    self = [super init];
    if(self) {
        _operations = [[FLOrderedCollection alloc] init];
    }
    return self;

}

+ (FLOperationQueue*) operationQueue {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) dealloc {
#if FL_MRC 
    [_operations release];
    [super dealloc];
#endif
}

- (void) operationWasAdded:(id) operation {
}

- (void) queueOperation:(FLOperation*) operation {
    FLAssertIsNotNil(operation);
    [_operations setObject:operation forKey:operation.identifier];
    [self operationWasAdded:operation];
}

- (void) addOperationsWithArray:(NSArray*) operations {
    for(FLOperation* operation in operations) {
        [self queueOperation:operation];
    }
}

- (void) addOperationWithTarget:(id) target action:(SEL) action {
    [self queueOperation:[FLPerformSelectorOperation performSelectorOperation:target action:action ]];
}

- (id) operationForIdentifier:(id) identifier {
	return [_operations objectForKey:identifier]; 
}

- (id) firstOperation {
	return [_operations firstObject];
}

- (id) lastOperation {
	return [_operations lastObject];
}

- (NSUInteger) count {
	return _operations.count;
}

- (void) removeOperation:(FLOperation*) operation {
    [self removeOperationForIdentifier:operation.identifier];
}

- (void) removeOperationForIdentifier:(id) identifier {
    [_operations removeObjectForKey:identifier];
}

- (void) removeAllOperations {
    self.operations = [FLOrderedCollection orderedCollection];
}

- (id) operationAtIndex:(NSUInteger) index {
    return [_operations objectAtIndex:index];
}

- (void) requestCancel {
    for(id operation in [_operations forwardObjectEnumerator]) {
        [operation requestCancel];
    }
}

- (id) removeFirstOperation {
    return [_operations removeFirstObject];
}

- (id) removeLastOperation {
    return [_operations removeLastObject];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state 
                                  objects:(id __unsafe_unretained [])buffer 
                                    count:(NSUInteger)len {
    return [_operations countByEnumeratingWithState:state objects:buffer count:len];
}

@end



#endif
