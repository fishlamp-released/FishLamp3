//
//  FLFinisherBlockOperation.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLFinisherBlockOperation.h"
#import "NSError+FLFailedResult.h"

@implementation FLFinisherBlockOperation

- (id) initWithFinisherBlock:(fl_finisher_block_t) block {
	self = [super init];
	if(self) {
		_finisherBlock = [block copy];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_finisherBlock release];
	[super dealloc];
}
#endif

+ (id) finisherBlockOperation:(fl_finisher_block_t) block {
   return FLAutorelease([[[self class] alloc] initWithFinisherBlock:block]);
}

- (void) startOperation {
    if(_finisherBlock) {
        _finisherBlock(self.finisher);
    }
    else {
        [self setFinishedWithResult:FLFailedResult];
    }
}

@end