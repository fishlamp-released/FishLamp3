//
//  FLAsyncTest.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

@class FLTimer;

#define FLAsyncTestDefaultTimeout 2.0f

@protocol FLAsyncTest <NSObject>
- (void) waitUntilFinished;

- (void) verifyAsyncResults:(dispatch_block_t) block;

- (void) setFinishedWithBlock:(void (^)()) finishBlock;
- (void) setFinished;
- (void) setFinishedWithError:(NSError*) error;
@end

@interface FLAsyncTest : NSObject<FLAsyncTest> {
@private
    dispatch_semaphore_t _semaphor;
    NSError* _error;
    FLTimer* _timer;
}

@property (readonly, copy, nonatomic) NSError* error;

+ (id) asyncTest;
+ (id) asyncTestWithTimeout:(NSTimeInterval) timeout;
- (id) initWithTimeout:(NSTimeInterval) timeout;

- (void) waitUntilFinished;

- (void) verifyAsyncResults:(dispatch_block_t) block;

- (void) setFinishedWithBlock:(void (^)()) finishBlock;
- (void) setFinished;
- (void) setFinishedWithError:(NSError*) error;

@end

