//
//  FLTestable.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/18/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

#import "FLTestCase.h"
#import "FLTestCaseList.h"
#import "FLTestableRunOrder.h"
#import "FLTestResultCollection.h"
#import "FLTestGroup.h"
#import "FLTestResultLogEntry.h"
#import "FLAsyncTest.h"

/**
 *  A FLTestable is an object that represents a automoated test of some kind. Either a unit or functional test.
 *  Any method with "test" in it (no params) will be run.
 *  Tests with "first" and "test" will be run first
 *  Tests with "last" and "test" will be run last;
 *  All other tests are run in alphebetical order.
 */
@protocol FLTestable <NSObject>
@optional

/**
 *  Called before test is run.
 *  
 *  @param testCases List of test cases - order of execution can be modified
 *  @param expected  Expected results
 */
- (void) willRunTestCases:(FLTestCaseList*) testCases;

/**
 *  Called after test is rull
 *  
 *  @param testCases the test cases that were run
 *  @param expected  expected results
 *  @param actual    actual results
 */
- (void) didRunTestCases:(FLTestCaseList*) testCases;

/**
 *  Optionally set dependencies in run order at the class level for running FLTestable subclasses.
 *  This is called while the tests are getting setup by the Test Organizer.
 *  
 *  @param runOrder FLTestableRunOrder specifies dependencies.
 */
+ (void) specifyRunOrder:(id<FLTestableRunOrder>) runOrder;

/**
 *  Return class of testGroup.
 *  
 *  @return return Class of a FLTestGroup subclass or nil.
 */

+ (NSString*) testGroupName;

/**
 *  Name of the testable class.
 *  
 *  @return return name. Default value is name of class.
 */
//+ (NSString*) testName;


@end

/**
 *  FLTestable is a concrete implemenation of FLTestable. You can safely subclass this.
 */
@interface FLTestable : NSObject<FLTestable> {
@private
    FLTestCaseList* _testCaseList;
    FLExpectedTestResult* _expectedTestResult;
    FLTestResultCollection* _testResults;
    id<FLStringFormatter> _logger;
}

@property (readwrite, strong) FLTestCaseList* testCaseList;
@property (readonly, strong) id<FLStringFormatter> logger;

- (id) initWithLogger:(id<FLStringFormatter>) logger;

- (FLTestCase*) testCaseForSelector:(SEL) selector;

- (FLTestCase*) testCaseForName:(NSString*) name;

@end

/**
 *  Macro that all the tests should use for output.
 */
#define FLTestLog(__TESTCASE__, FORMAT, ...) \
            [__TESTCASE__.result appendLogEntry:[FLTestResultLogEntry testResultLogEntry:FLStringWithFormatOrNil(FORMAT, ##__VA_ARGS__) stackTrace:nil]]

#define FLTestLogHeavy(__TESTABLE__, FORMAT, ...) \
            [__TESTABLE__.result appendLogEntry:[FLTestResultLogEntry testResultLogEntry:FLStringWithFormatOrNil(FORMAT, ##__VA_ARGS__) stackTrace:FLCreateStackTrace(YES)]]

#define FLDisableTest() \
            do { \
                [self.currentTestCase setDisabled:YES]; \
                return; \
            } while(0)

#define FLTestMode(YESNO) \
            [self.currentTestCase setDebugMode:YESNO]

#define FLConfirmPrerequisiteTestCasePassed(NAME) \
            do { \
                NSString* __name = @#NAME; \
                FLTestCase* testCase = [self testCaseForName:__name]; \
                FLConfirmNotNil(testCase, @"prerequisite test case not found: %@", __name); \
                FLConfirm([[testCase result] passed], @"prerequisite test case \"%@\" failed", testCase.testCaseName); \
            } while(0);
            