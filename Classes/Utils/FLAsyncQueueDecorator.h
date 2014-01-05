//
//  FLAsyncQueueDecorator.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAbstractAsyncQueue.h"

@interface FLAsyncQueueDecorator : FLAbstractAsyncQueue {
@private
    id<FLAsyncQueue> _nextQueue;
}
@property (readwrite, strong) id<FLAsyncQueue> nextQueue;

- (id) initWithNextQueue:(id<FLAsyncQueue>) queue;
+ (id) asyncQueueDecorator:(id<FLAsyncQueue>) queue;

@end


