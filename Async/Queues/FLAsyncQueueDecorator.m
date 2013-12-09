//
//  FLAsyncQueueDecorator.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAsyncQueueDecorator.h"

@implementation FLAsyncQueueDecorator

@synthesize nextQueue = _nextQueue;

#if FL_MRC
- (void)dealloc {
	[_nextQueue release];
	[super dealloc];
}
#endif

- (id) initWithNextQueue:(id<FLAsyncQueue>) queue {

    self = [super init];
    if(self) {
        _nextQueue = FLRetain(queue);
    }

    return self;
}

- (id) init {	
    return [self initWithNextQueue:nil];
}

+ (id) asyncQueueDecorator:(id<FLAsyncQueue>) queue {
    return FLAutorelease([[[self class] alloc] initWithNextQueue:queue]);
}

- (FLPromise*) queueOperation:(id<FLQueueableAsyncOperation>) event
                         withDelay:(NSTimeInterval) delay
                        completion:(fl_completion_block_t) completion {

    return [self.nextQueue queueOperation:event withDelay:delay completion:completion];
}

- (FLPromisedResult) runSynchronously:(id<FLQueueableAsyncOperation>) event {
    return [self.nextQueue runSynchronously:event];
}

@end
