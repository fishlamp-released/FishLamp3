//
//  FLDecoratedAsyncQueue.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLDecoratedAsyncQueue.h"
#import "FLAsyncQueueDecorator.h"

@implementation FLDecoratedAsyncQueue

@synthesize asyncQueue = _asyncQueue;

- (id) init {	
	self = [super init];
	if(self) {
		_decorators = [[NSMutableArray alloc] init];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_decorators release];
    [_asyncQueue release];
	[super dealloc];
}
#endif

- (void) rebuildChain {
    FLAsyncQueueDecorator* last = self;
    for(FLAsyncQueueDecorator* decorator in _decorators) {
        last.nextQueue = decorator;
        last = decorator;
    }
    last.nextQueue = self.asyncQueue;
}

- (void) addDecorator:(FLAsyncQueueDecorator*) decorator {
    [_decorators addObject:decorator];
    [self rebuildChain];
}

- (void) pushDecorator:(FLAsyncQueueDecorator*) decorator {
    [_decorators insertObject:decorator atIndex:0];
    [self rebuildChain];
}

- (void) removeDecorator:(FLAsyncQueueDecorator*) decorator {
    [_decorators removeObject:decorator];
    [self rebuildChain];
}

- (void) setAsyncQueue:(id<FLAsyncQueue>) asyncQueue {
    FLSetObjectWithRetain(_asyncQueue, asyncQueue);
    [self rebuildChain];
}


@end
