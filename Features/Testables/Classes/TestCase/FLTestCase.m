//
//  FLTestCase.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestCase.h"
#import "FLTestCaseList.h"
#import "FLTestResult.h"
#import "NSString+FishLamp.h"
#import "FLTestable.h"
#import "FLSelectorPerforming.h"
#import "FLStringFormatter.h"
#import "FLAsyncTest.h"

@interface FLTestCase ()
@property (readwrite, strong) NSString* testCaseName;
@property (readwrite, strong) FLSelector* selector;
@property (readwrite, assign) id target;
@property (readwrite, strong) NSString* disabledReason;
@property (readwrite, strong) FLTestResult* result;
@property (readonly, strong) FLIndentIntegrity* indentIntegrity;
@property (readwrite, strong) FLAsyncTest* asyncTest;
@end

@implementation FLTestCase

@synthesize isDisabled = _disabled;
@synthesize disabledReason = _disabledReason;
@synthesize selector = _selector;
@synthesize target = _target;
@synthesize testCaseName = _testCaseName;
@synthesize testable = _unitTest;
@synthesize result = _result;
@synthesize indentIntegrity = _indentIntegrity;
@synthesize asyncTest = _asyncTest;

@synthesize asyncStartTest = _asyncStartTest;
@synthesize asyncFinishTest = _asyncFinishTest;
@synthesize asyncTimeout = _asyncTimeout;

- (id) init {	
	self = [super init];
	if(self) {
		_indentIntegrity = [[FLIndentIntegrity alloc] init];
        _willTestSelector = [[FLSelector alloc] initWithString:[NSString stringWithFormat:@"will%@", [_selector.selectorString stringWithUppercaseFirstLetter_fl]]];
        _didTestSelector = [[FLSelector alloc] initWithString:[NSString stringWithFormat:@"did%@", [_selector.selectorString stringWithUppercaseFirstLetter_fl]]];
	}
	return self;
}

- (id) initWithName:(NSString*) name
           testable:(id<FLTestable>) testable
             target:(id) target
           selector:(SEL) selector {

    self = [self init];
    if(self) {
        _testCaseName = FLRetain(name);
        _unitTest = testable;
        _target = target;
        _selector = [[FLSelector alloc] initWithSelector:selector];
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_asyncStartTest release];
    [_asyncFinishTest release];
    [_asyncTimeout release];

    [_indentIntegrity release];
    [_disabledReason release];
    [_testCaseName release];
	[_selector release];
    [_result release];
    [_asyncTest release];
    [super dealloc];
}
#endif

+ (id) testCase:(NSString*) name
       testable:(id<FLTestable>) testable
         target:(id) target
       selector:(SEL) selector {

    return FLAutorelease([[[self class] alloc] initWithName:name testable:testable target:target selector:selector]);
}

- (void) setDisabledWithReason:(NSString*) reason {
    _disabled = YES;
    self.disabledReason = reason;
}

- (void) performTestCaseSelector:(FLSelector*) selector optional:(id) optional {

    switch(selector.argumentCount) {
        case 0:
            [selector performWithTarget:_target];
        break;

        case 1:
            [selector performWithTarget:_target withObject:optional];
        break;

        default:
            [self setDisabledWithReason:[NSString stringWithFormat:@"[%@ %@] has too many paramaters (%ld).",
                NSStringFromClass([_target class]),
                selector.selectorString,
                (unsigned long) selector.argumentCount]];
        break;
    }
}

- (void) prepareTestCase {
    self.result = [FLTestResult testResult:self.testCaseName];
    if(!self.isDisabled && [_willTestSelector willPerformOnTarget:_target]) {
        [self performTestCaseSelector:_willTestSelector optional:self];
    }
}

- (void) finishTestCase {
    if(!self.isDisabled && [_willTestSelector willPerformOnTarget:_didTestSelector]) {
        [self performTestCaseSelector:_didTestSelector optional:self];
    }
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@", [super description], self.testCaseName];
}


- (void) performTestCase {

    @try {

        [self prepareTestCase];

        if(self.isDisabled) {
            return;
        }

        [self.result setStarted];

        [self performTestCaseSelector:_selector optional:self];

        if(self.asyncStartTest) {

            FLAsyncTest* asyncTest = [FLAsyncTest asyncTest];
            [asyncTest start];

            self.asyncStartTest(asyncTest);

            [asyncTest waitUntilFinished];

            if(self.asyncFinishTest) {
                self.asyncFinishTest(asyncTest);
            }

            if(self.asyncTest.error) {
                [self.result setFailedWithError:self.asyncTest.error];
            }
            else {
                [self.result setPassed];
            }
        }
        else {
            [self.result setPassed];
        }

    }
    @catch(NSException* ex) {
        [self.result setFailedWithError:[ex error]];
    }
    @finally {
        [self finishTestCase];
    }
}

//- (FLAsyncTest*) startAsyncTestWithTimeout:(NSTimeInterval) timeout timedOutBlock:(FLAsyncTestTimedOutBlock) timeoutBlock {
//    self.asyncTest = [FLAsyncTest asyncTestWithTimeout:timeout timedOutBlock:timeoutBlock];
//    [self.asyncTest start];
//    return self.asyncTest;
//}
//
//- (FLAsyncTest*) asyncStartTest {
//    return [self startAsyncTestWithTimeout:0 timedOutBlock:nil];
//}

@end


