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
#import "FLDispatchQueues.h"
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
        _finishers = [[NSMutableDictionary alloc] init];

        _contextOpen = YES;
        self.operationStarter = [FLDispatchQueue defaultQueue];
    }
    
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_finishers release];
    [_operationStarter release];
    [_operations release];
    [super dealloc];
}
#endif

+ (id) operationContext {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) defaultContext {
    FLReturnStaticObject([FLOperationContext operationContext]);
}

- (void) visitOperations:(FLOperationVisitor) visitor {

    FLAssertNotNil(visitor);

    if(visitor) {
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
    
}

- (void) requestCancel {

    NSSet* copy = nil;
    @try {
        @synchronized(self) {
            copy = [_operations copy];
        }

        for(id operation in copy) {
#if TRACE
            FLDebugLog(@"cancelled %@", [operation description]);
#endif

            [operation requestCancel];
        }
    }
    @finally {
        FLReleaseWithNil(copy);
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
        FLDebugLog(@"Operation added to context: %@", [operation description]);
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
        FLDebugLog(@"Operation removed from context: %@", [operation description]);
#endif

        [_operations removeObject:FLRetainWithAutorelease(operation)];

        if([operation respondsToSelector:@selector(removeContext:)]) {
            [operation removeContext:self];
        }

        if(operation) {
            [_finishers removeObjectForKey:operation];
        }
    }

    [self didRemoveOperation:operation];
}

- (id<FLOperationStarter>) starterForOperation:(id) operation {

    id<FLOperationStarter> starter = nil;

    if([operation respondsToSelector:@selector(operationStarter)]) {
        starter = [operation operationStarter];
    }

    if(!starter) {
        starter = self.operationStarter;
    }

    FLAssertNotNil(starter);

    return starter;
}

- (FLPromisedResult) runSynchronously:(id<FLQueueableAsyncOperation>) operation {
    FLAssertNotNil(operation);

    [self addOperation:operation];

// TODO: provide way to specify queue
    return [[self starterForOperation:operation] runOperationSynchronously:operation];
}


- (void) queueOperation:(id<FLQueueableAsyncOperation>) operation
              withDelay:(NSTimeInterval) delay
               finisher:(FLFinisher*) finisher {

    FLAssertNotNil(operation);
    [self addOperation:operation];
    [self willStartOperation:operation];

// TODO: provide way to specify queue
    id<FLOperationStarter> starter = [self starterForOperation:operation];
    FLAssertNotNil(starter);

    [starter queueOperation:operation withDelay:delay finisher:finisher];
}

- (void) setFinisher:(FLFinisher*) finisher
        forOperation:(id) operation {

    FLAssertNotNil(finisher);
    FLAssertNotNil(operation);
    FLAssertNotNil(_finishers);

    if(finisher) {
        @synchronized(self) {
            [_finishers setObject:finisher
                           forKey:[NSValue valueWithNonretainedObject:operation]];
        }
    }
}

- (FLFinisher*) popFinisherForOperation:(id) operation {

    FLAssertNotNil(operation);
    FLAssertNotNil(_finishers);

    FLFinisher* finisher = nil;
    id key = [NSValue valueWithNonretainedObject:operation];

    @synchronized(self) {
        finisher = FLRetainWithAutorelease([_finishers objectForKey:key]);
        [_finishers removeObjectForKey:key];
    }

    return finisher;
}


@end



