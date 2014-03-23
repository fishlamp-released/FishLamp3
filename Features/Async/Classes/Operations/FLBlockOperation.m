//
//  FLBlockOperation.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLBlockOperation.h"
#import "FLSuccessfulResult.h"

@implementation FLBlockOperation

- (id) initWithBlock:(fl_block_t) block {
	self = [super init];
	if(self) {
		_block = [block copy];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_block release];
	[super dealloc];
}
#endif

+ (id) blockOperation:(fl_block_t) block {
   return FLAutorelease([[[self class] alloc] initWithBlock:block]);
}

- (FLPromisedResult) runSynchronously {
    if(_block) {
        _block();
    }

    return FLSuccessfulResult;
}

@end