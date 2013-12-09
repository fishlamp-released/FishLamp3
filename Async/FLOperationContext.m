//
//  FLOperationContext.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOperationContext.h"
#import "FLAsyncQueue.h"
#import "FishLampAsync.h"
#import "FLDispatchQueue.h"
#import "FLAsyncQueue.h"
#import "FLOperation.h"
#import "FLOperationStarter.h"

//#define TRACE 1

#define OperationInQueue(op) op

typedef void (^FLOperationVisitor)(id operation, BOOL* stop);

@interface FLOperationContext ()
@property (readwrite, assign, getter=isContextOpen) BOOL contextOpen; 

- (void) visitOperations:(FLOperationVisitor) visitor;
@end

@implementation FLOperationContext

@synthesize contextOpen = _contextOpen;
@synthesize operationStarter = _operationStarter;

- (id) init {
    self = [super init];
    if(self) {
        _operations = [[NSMutableSet alloc] init];
        _contextOpen = YES;
        self.operationStarter = [FLDispatchQueue defaultQueue];
    }
    
    return self;
}

- (void) dealloc {
#if FL_MRC
    [_operationStarter release];
    [_operations release];
    [super dealloc];
#endif
}

+ (id) operationContext {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) defaultContext {
    FLReturnStaticObject([FLOperationContext operationContext]);
}

- (void) visitOperations:(FLOperationVisitor) visitor {

    FLAssertNotNil(visitor);

    @synchronized(self) {
        BOOL stop = NO;
        for(id operation in _operations) {
            visitor(OperationInQueue(operation), &stop);
            
            if(stop) {
                break;
            }
        }
    }
    
}

- (void) requestCancel {

    @synchronized(self) {

        // the reason we need a copy is because the set is likely going
        // to change out from under us as we iterate it and cancel the operations
        // (which then remove themselves from the context).
        NSSet* copy = FLCopyWithAutorelease(_operations);
        for(id operation in copy) {
#if TRACE
            FLLog(@"cancelled %@", [operation description]);
#endif
        
            FLPerformSelector0(OperationInQueue(operation), @selector(requestCancel));
        }
    }
}

- (void) openContext {
    self.contextOpen = YES;
}

- (void) closeContext {
    [self requestCancel];
    self.contextOpen = NO;
}

- (void) willStartOperation:(id<FLOperationContext>) operation {
}

- (void) didRemoveOperation:(id<FLOperationContext>) operation {
}

- (void) addOperation:(id) operation  {

    FLAssertNotNil(operation);

    @synchronized(self) {
    
#if TRACE
        FLLog(@"Operation added to context: %@", [operation description]);
#endif
        [_operations addObject:operation];

        if([operation respondsToSelector:@selector(setContext:)]) {
            [operation setContext:self];
        }
    }

    if(!self.isContextOpen) {
        [operation requestCancel];
    }

    [self willStartOperation:operation];
}

- (void) removeOperation:(id) operation {

    FLAssertNotNil(operation);

    @synchronized(self) {
    
#if TRACE
        FLLog(@"Operation removed from context: %@", [operation description]);
#endif

        [_operations removeObject:FLRetainWithAutorelease(operation)];

        if([operation respondsToSelector:@selector(removeContext:)]) {
            [operation removeContext:self];
        }
    }
    
    [self didRemoveOperation:operation];
}

- (id<FLOperationStarter>) starterForOperation:(id) operation {

    id<FLOperationStarter> starter = nil;

    if([operation respondsToSelector:@selector(operationStarter)]) {
        starter = [operation operationStarter];
    }

    return starter ? starter : self.operationStarter;
}

- (FLPromisedResult) runSynchronously:(id<FLQueueableAsyncOperation>) operation {
    FLAssertNotNil(operation);

    [self addOperation:operation];

// TODO: provide way to specify queue
    return [[self starterForOperation:operation] runOperationSynchronously:operation];
}


- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) operation
                 withDelay:(NSTimeInterval) delay
                completion:(fl_completion_block_t) completion {

    FLAssertNotNil(operation);
    [self addOperation:operation];
    [self willStartOperation:operation];

// TODO: provide way to specify queue
    return [[self starterForOperation:operation] startOperation:operation withDelay:delay completion:completion];
}

@end



