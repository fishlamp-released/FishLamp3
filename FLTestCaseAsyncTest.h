//
//  FLTestCaseAsyncTest.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAsyncTest.h"

@class FLTestCase;

@interface FLTestCaseAsyncTest : NSObject<FLAsyncTest> {
@private
    __unsafe_unretained FLTestCase* _operation;
    dispatch_block_t _finishedBlock;
    BOOL _finishedStarting;
    FLTimer* _timer;
}
@property (readwrite, copy) dispatch_block_t finishedBlock;
@property (readwrite, assign) BOOL finishedStarting;

+ (id) testCaseAsyncTest:(FLTestCase*) operation
                 timeout:(NSTimeInterval) timeout;

- (id) initWithOperation:(FLTestCase*) operation
                 timeout:(NSTimeInterval) timeout;


- (void) setTestCaseStarted;
@end
