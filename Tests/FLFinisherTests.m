//
//  FLNotifierSanityCheck.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFinisherTests.h"
#import "FLTimeoutTests.h"
#import "FishLampAsync.h"
#import "FLAsyncTestGroup.h"
#import "FLAsyncTest.h"

@interface FLPromise (Testing)
@property (readonly, strong) FLPromise* nextPromise;
@end

@implementation FLFinisherTests

+ (Class) testGroupClass {
    return [FLAsyncTestGroup class];
}

+ (void) specifyRunOrder:(id<FLTestableRunOrder>) runOrder {
    [runOrder orderClass:[self class] afterClass:[FLTimeoutTests class]];
}

- (void) testSingleCount {
    
    __block BOOL fired = NO;
    
    FLFinisher* finisher = [FLFinisher finisherWithBlock:^(FLPromisedResult result) {
        fired = YES; 
    }];
    
    FLPromise* promise = [finisher addPromise];
    
    FLConfirm(!promise.isFinished);
    FLConfirm(fired == NO);
    [finisher setFinished];
    FLConfirm(promise.isFinished);
    FLConfirm(fired == YES);
}

- (void) willTestDoubleCount:(FLTestCase*) testCase {
    [testCase setDisabledWithReason:@"problem with exception propagation"];
}

/*
- (void) testDoubleCount:(FLTestCase*) testCase {

//    __block BOOL fired = NO;
//    
//    FLFinisher* finisher = [FLFinisher finisherWithBlock:^(FLPromisedResult result) { 
//        fired = YES; 
//    }];
//    
//    FLPromise* promise = [finisher addPromise];
//
//    FLConfirm(!promise.isFinished);
//    FLConfirm(fired);
//    [finisher setFinished];
//    FLConfirm(promise.isFinished);
//
//    BOOL gotError = NO;
//    @try {
//        [finisher setFinished];
//        
//    }
//    @catch(NSException* expected) {
//        gotError = YES;
//    }
//    
//    FLConfirmWithComment(gotError == YES, @"expecting an error");
}
*/

- (void) testBasicFinisher:(FLTestCase*) testCase {

    FLTestLog(testCase, @"async self test");

    [testCase startAsyncTest];

    __block FLPromisedResult resultFromBlock = nil;

    FLFinisher* finisher = [FLFinisher finisherWithBlock:^(FLPromisedResult result) {
        resultFromBlock = result;
    }];
    FLConfirmFalse(finisher.isFinished);

    __block BOOL finishedOk = NO;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, nil), ^{
        [testCase finishAsyncTestWithBlock:^{
            finishedOk = YES;
            FLTestLog(testCase, @"done in thread");
            [finisher setFinishedWithResult:@"Hello"];
        }];
    });

    FLPromisedResult result = [finisher waitUntilFinished];
    FLConfirmTrue(finisher.isFinished);
    FLConfirmNotError(result);
    FLConfirmTrue(finishedOk);
    FLConfirmNotNil(result);
    FLConfirmNotNil(resultFromBlock);
    FLConfirm([result isEqualToString:@"Hello"]);
    FLConfirm([resultFromBlock isEqualToString:result]);

    [testCase waitUntilAsyncTestIsFinished];
}

- (void) testPromiseAdding {
    FLPromise* promise = [FLPromise promise];
    FLConfirmNotNil(promise);
    FLConfirmNil(promise.nextPromise);

    NSMutableArray* array = [NSMutableArray array];
    [array addObject:promise];

    for(int i = 0; i < 5; i++) {
        FLPromise* anotherPromise = [FLPromise promise];
        [array addObject:anotherPromise];

        [promise addPromise:anotherPromise];
    }

    FLPromise* walker = promise;
    FLConfirm(walker == [array objectAtIndex:0]);

    int i = 0;
    while(walker) {
        FLConfirm(walker == [array objectAtIndex:i++]);
        walker = walker.nextPromise;
    }
}


@end

