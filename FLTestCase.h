//
//  FLTestCase.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/27/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLSelector.h"
#import "FLStringFormatter.h"
#import "FLAsyncTest.h"
#import "FLOperation.h"

typedef void (^FLAsyncTestResultBlock)();

@protocol FLTestable;

@class FLTestCaseList;
@class FLTestResult;
@class FLTestCaseAsyncTest;

#define FLTestCaseDefaultAsyncTimeout 2.0f

@interface FLTestCase : FLOperation {
@private
    NSString* _testCaseName;
    FLSelector* _selector;
    FLSelector* _willTestSelector;
    FLSelector* _didTestSelector;
    FLTestResult* _result;

    NSString* _disabledReason;

    __unsafe_unretained id _target;
    __unsafe_unretained id<FLTestable> _unitTest;
    BOOL _disabled;
    BOOL _debugMode;

    FLTestCaseAsyncTest* _asyncTest;
    FLIndentIntegrity* _indentIntegrity;

}

- (id) initWithName:(NSString*) name
           testable:(id<FLTestable>) testable;

- (id) initWithName:(NSString*) name
           testable:(id<FLTestable>) testable
             target:(id) target
           selector:(SEL) selector;

+ (id) testCase:(NSString*) name
       testable:(id<FLTestable>) testable
         target:(id) target
       selector:(SEL) selector;


@property (readonly, strong) NSString* testCaseName;
@property (readonly, strong) FLSelector* selector;
@property (readonly, assign) id target;

@property (readonly, assign) id<FLTestable> testable;
@property (readonly, strong) FLTestResult* result;

// disabling
@property (readonly, assign, nonatomic) BOOL isDisabled;
@property (readonly, strong, nonatomic) NSString* disabledReason;
- (void) setDisabledWithReason:(NSString*) reason;

// async testing

@property (readwrite, assign) BOOL debugMode;

- (void) startAsyncTest;
- (void) startAsyncTestWithTimeout:(NSTimeInterval) timeout;

- (void) verifyAsyncResults:(dispatch_block_t) block;

- (void) finishAsyncTestWithBlock:(void (^)()) finishBlock;
- (void) finishAsyncTest;
- (void) finishAsyncTestWithError:(NSError*) error;

- (void) waitUntilAsyncTestIsFinished;


- (void) prepareTestCase;

@end

#if DEPRECATED
@interface FLTestCase (TestHelpers)

+ (void) runTestWithExpectedFailure:(void (^)()) test
                       checkResults:(void (^)(NSException* ex, BOOL* pass)) checkResults;

+ (void) runTestWithExpectedFailure:(void (^)()) test;

@end
#endif