//
//  FLOperationQueueErrorStrategy.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLOperationQueueErrorStrategy.h"
#import "FLOperationQueue.h"

@implementation FLSingleErrorOperationQueueStrategy

@synthesize error =_error;

+ (id) singleErrorOperationQueueStrategy {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void)dealloc {
	[_error release];
	[super dealloc];
}
#endif

- (void) operationQueue:(FLOperationQueue*) operationQueue
       encounteredError:(NSError*) error {
    self.error = error;
}

- (BOOL) operationQueueWillHalt:(FLOperationQueue*) operationQueue {
    return self.error != nil;
}
- (NSError*) errorResult {
    return self.error;
}


@end

