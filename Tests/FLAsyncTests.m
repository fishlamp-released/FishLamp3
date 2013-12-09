//
//  FLAsyncTests.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAsyncTests.h"
#import "FLPerformSelectorOperation.h"

#import "FLTestable.h"
#import "FLTimeoutTests.h"

#import "FLAsyncTestGroup.h"
#import "FLDispatchQueue.h"

@implementation FLAsyncTests

+ (Class) testGroupClass {
    return [FLAsyncTestGroup class];
}

+ (void) specifyRunOrder:(id<FLTestableRunOrder>) runOrder {
    [runOrder orderClass:[self class] afterClass:[FLTimeoutTests class]];
}

//- (void) _didExecuteOperation:(FLPerformSelectorOperation*) operation {
//	FLTestLog(self, @"did execute");
//}

- (void) _asyncDone:(FLPerformSelectorOperation*) operation
{
//	[operation finishAsync];
	
//	FLAssertWithComment(operation.isFinished, @"not performed");
//	  FLAssertWithComment(operation.wasStarted, @"not started");
//
//	[[FLTestCase currentTestCase] didCompleteAsyncTest];
}

- (void) testAsyncOperation {
    
//    FLAsyncRunner* async = [FLAsyncRunner asyncRunner];
//    
//    [async start:^{
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//                [async setFinished];
//                });
//        }];
//    
//    [async waitForFinish];
//    
//    FLAssert(async.isFinished);
    
//	FLPerformSelectorOperation* operation = [FLPerformSelectorOperation performSelectorOperation:self action:@selector(_didExecuteOperation:)];
//
//	  [operation startAsync:FLCallbackMake(operation, @selector(_asyncDone:))];
//	  
//	  [testCase blockUntilTestCompletes];
}

- (void) testAsyncTest:(FLTestCase*) testCase {

    [testCase startAsyncTest];

    dispatch_semaphore_t semaphor = dispatch_semaphore_create(0);

    __block BOOL finishedOk = NO;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, nil), ^{

        [testCase finishAsyncTestWithBlock:^{

            @try {
                FLConfirmFalse(finishedOk);
                finishedOk = YES;
            }
            @finally {
                dispatch_semaphore_signal(semaphor);
            }
        }];

    });

    dispatch_semaphore_wait(semaphor, DISPATCH_TIME_FOREVER);

    FLConfirm(finishedOk);
    FLConfirm(testCase.result.passed);
    FLConfirm(testCase.result.started);
    FLConfirm(testCase.result.finished);

    FLDispatchRelease(semaphor);
}

- (void) testAsyncTest2:(FLTestCase*) testCase {

    [testCase startAsyncTest];
    [testCase finishAsyncTest];

//    FLPromise* promise =
//    [FLBackgroundQueue queueBlock:^{
//        FLAssertNotNil(nil);
//    }];
}

@end

