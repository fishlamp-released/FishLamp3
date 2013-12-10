//
//  FLRetryHandler.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/20/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLRetryHandler.h"


@interface FLRetryHandler ()
//@property (readwrite, assign) NSUInteger retryCount;
@end

@implementation FLRetryHandler

@synthesize retryCount = _retryCount;
@synthesize maxRetryCount = _maxRetryCount;
@synthesize retryDelay = _retryDelay;
@synthesize disabled = _disabled;

- (id) initWithMaxRetryCount:(NSUInteger) maxRetryCount
         delayBetweenRetries:(NSTimeInterval) retryDelay {

	self = [super init];
	if(self) {
		self.maxRetryCount = maxRetryCount;
        self.retryDelay = retryDelay;
	}
	return self;
}


+ (id) retryHandler:(NSUInteger) maxRetryCount
delayBetweenRetries:(NSTimeInterval) retryDelay {
    return FLAutorelease([[[self class] alloc] initWithMaxRetryCount:maxRetryCount delayBetweenRetries:retryDelay]);
}

//- (BOOL) retryWithBlock:(dispatch_block_t) block {
//
//    FLAssertNotNil(block);
//
//    if(!self.isDisabled && self.retryCount < self.maxRetryCount) {
//        self.retryCount++;
//        
//        FLLog(@"Retrying HTTP Request %@ (%ld of %ld)", self.requestHeaders.requestURL, self.retryCount, self.maxRetryCount);
//
//        if(_retryDelay > 0) {
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_retryDelay * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_current_queue(), FLCopyWithAutorelease(block));
//        }
//        else {
//            dispatch_async(dispatch_get_current_queue(), block);
//        }
//
//        return YES;
//    }
//
//
//    return NO;
//}

- (void) resetRetryCount {
    self.retryCount = 0;
}

@end
