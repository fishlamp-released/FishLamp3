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
#import "FLAsyncTestFinisher.h"

@protocol FLTestable;

@class FLTestResult;
@class FLIndentIntegrity;
@class FLAsyncTest;

typedef void (^FLAsyncTestCaseBlock)(FLAsyncTestFinisher* testFinisher);
typedef void (^FLTestCaseBlock)();

@interface FLTestCase : NSObject {
@private
    NSString* _testCaseName;
    FLSelector* _selector;
    FLTestResult* _result;

    FLSelector* _willTestSelector;
    FLSelector* _didTestSelector;

    FLIndentIntegrity* _indentIntegrity;

    NSString* _disabledReason;

    FL_WEAK id _target;
    FL_WEAK id<FLTestable> _unitTest;
    BOOL _disabled;

    FLAsyncTestCaseBlock _asyncStartTest;
    FLTestCaseBlock _asyncFinishTest;
    FLAsyncTestCaseBlock _asyncTimeout;
}

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

@property (readwrite, copy) FLAsyncTestCaseBlock asyncStartTest;
@property (readwrite, copy) FLTestCaseBlock asyncFinishTest;
@property (readwrite, copy) FLAsyncTestCaseBlock asyncTimeout;

//- (void) startAsync
//- (void) startAsyncTestWithTimeout:(NSTimeInterval) timeout
//                             timedOutBlock:(FLAsyncTestTimedOutBlock) timeoutBlock;

@end

