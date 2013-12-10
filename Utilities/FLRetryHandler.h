//
//  FLRetryHandler.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/20/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"

@protocol FLRetryHandler <NSObject>

@property (readwrite, assign) NSUInteger retryCount;
@property (readwrite, assign) NSUInteger maxRetryCount;
@property (readwrite, assign) NSTimeInterval retryDelay;
@property (readwrite, assign, getter=isDisabled) BOOL disabled;

- (void) resetRetryCount;

@end

@interface FLRetryHandler : NSObject<FLRetryHandler> {
@private
    NSUInteger _retryCount;
    NSUInteger _maxRetryCount;
    BOOL _disabled;
    NSTimeInterval _retryDelay;
}

- (id) initWithMaxRetryCount:(NSUInteger) maxRetryCount
         delayBetweenRetries:(NSTimeInterval) retryDelay;

+ (id) retryHandler:(NSUInteger) maxRetryCount
delayBetweenRetries:(NSTimeInterval) retryDelay;

@end
