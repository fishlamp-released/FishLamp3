//
//  FLDecoratedAsyncQueue.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAsyncQueueDecorator.h"

@interface FLDecoratedAsyncQueue : FLAsyncQueueDecorator {
@private
    NSMutableArray* _decorators;
    id<FLAsyncQueue> _asyncQueue;
}

// none of these are thread safe. so set up your chain before using using it.

@property (readwrite,strong, nonatomic) id<FLAsyncQueue> asyncQueue;

- (void) addDecorator:(FLAsyncQueueDecorator*) decorator;
- (void) pushDecorator:(FLAsyncQueueDecorator*) decorator;
- (void) removeDecorator:(FLAsyncQueueDecorator*) decorator;
@end
