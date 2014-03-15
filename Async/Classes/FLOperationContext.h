//
//  FLOperationContext.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
//#import "FLAsyncBlockTypes.h"
//#import "FLPromisedResult.h"
//#import "FLBroadcaster.h"
#import "FLAbstractAsyncQueue.h"

@class FLOperation;
@class FLPromise;
@protocol FLOperationStarter;

@protocol FLOperationContext <FLAsyncQueue>

/**
 *  Cancel and remove all the current operations.
 */
- (void) requestCancel;          
@end

@interface FLOperationContext : FLAbstractAsyncQueue<FLOperationContext> {
@private
    NSMutableSet* _operations;
    BOOL _contextOpen;

    id<FLOperationStarter> _operationStarter;
    NSMutableDictionary* _finishers;
}
@property (readonly, assign, getter=isContextOpen) BOOL contextOpen; 
@property (readwrite, strong) id<FLOperationStarter> operationStarter;

+ (id) operationContext;

/**
 *  Open the context. Context's are open by default.
 */
- (void) openContext;

/**
 *  Close the context. This cancels and removes all the operations. Further operations are cancelled and discarded until the context is opened again.
 */
- (void) closeContext;

+ (id) defaultContext;

- (void) addOperation:(id) operation;
- (void) removeOperation:(id) operation;

- (id<FLOperationStarter>) starterForOperation:(id) operation;

- (void) setFinisher:(FLFinisher*) finisher
        forOperation:(id) operation;

- (FLFinisher*) popFinisherForOperation:(id) operation;

@end

@interface FLOperationContext (OptionalOverrides)
- (void) willStartOperation:(id<FLQueueableAsyncOperation>) operation;
- (void) didRemoveOperation:(id<FLQueueableAsyncOperation>) operation;
@end

@protocol FLContextualOperation <FLQueueableAsyncOperation>


- (id) context;
- (void) setContext:(id) context;
- (void) removeContext:(id) context;

- (void) requestCancel;
@end