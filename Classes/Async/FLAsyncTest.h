//
//  FLAsyncTest.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

#define FLAsyncTestDefaultTimeout 2.0f

//@protocol FLAsyncTestDelegate;
@class FLAsyncTest;

typedef void (^FLAsyncTestBlock)();

typedef void (^FLAsyncTestTimedOutBlock)(FLAsyncTest* test);

@interface FLAsyncTest : NSObject{
@private
    dispatch_semaphore_t _semaphor;
    NSError* _error;
    NSTimer* _timer;
    BOOL _isFinished;
    BOOL _isStarted;
    NSTimeInterval _timeout;
    FLAsyncTestTimedOutBlock _timedOutBlock;
}

@property (readonly, assign) BOOL isFinished;

@property (readonly, copy, nonatomic) NSError* error;

//@property (readwrite, assign) id<FLAsyncTestDelegate> delegate;

+ (id) asyncTest;
+ (id) asyncTestWithTimeout:(NSTimeInterval) timeout timedOutBlock:(FLAsyncTestTimedOutBlock) timeoutBlock;
- (id) initWithTimeout:(NSTimeInterval) timeout timedOutBlock:(FLAsyncTestTimedOutBlock) timeoutBlock;

- (void) start;

- (void) setFinishedWithBlock:(FLAsyncTestBlock) finishBlock;
- (void) setFinished;
- (void) setFinishedWithError:(NSError*) error;

// utils
// it's okay to thow
- (void) verifyAsyncResults:(FLAsyncTestBlock) block;

- (void) validateResultsWhenFinished:(FLAsyncTestBlock) finishedValidator;

- (void) waitUntilFinished;

@end

//@protocol FLAsyncTestDelegate <NSObject>
//- (void) asyncTestDidFinish:(FLAsyncTest*) asyncTest;
//@end

