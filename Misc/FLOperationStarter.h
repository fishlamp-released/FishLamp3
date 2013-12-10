//
//  FLOperationStarter.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/5/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FLPromisedResult.h"

@class FLPromise;
@protocol FLQueueableAsyncOperation;

@protocol FLOperationStarter <NSObject>
- (FLPromisedResult) runOperationSynchronously:(id<FLQueueableAsyncOperation>) asyncObject;

- (FLPromise*) startOperation:(id<FLQueueableAsyncOperation>) operation
                    withDelay:(NSTimeInterval) delay
                   completion:(fl_completion_block_t) completionOrNil;

@end
