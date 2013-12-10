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
#import "FLTimer.h"
#import "FLTestCaseAsyncTest.h"
#import "FishLampAsync.h"

@interface FLTestCase ()
@property (readwrite, strong) NSString* testCaseName;
@property (readwrite, strong) FLSelector* selector;
@property (readwrite, assign) id target;
@property (readwrite, strong) NSString* disabledReason;
@property (readwrite, strong) FLTestResult* result;
@property (readonly, strong) FLIndentIntegrity* indentIntegrity;
@property (readwrite, strong) FLTestCaseAsyncTest* asyncTest;
@end

@implementation FLTestCase

@synthesize isDisabled = _disabled;
@synthesize disabledReason = _disabledReason;
@synthesize selector = _selector;
@synthesize target = _target;
@synthesize testCaseName = _testCaseName;
@synthesize testable = _unitTest;
@synthesize result = _result;
@synthesize debugMode = _debugMode;
@synthesize indentIntegrity = _indentIntegrity;
@synthesize asyncTest = _asyncTest;

- (id) init {	
	self = [super init];
	if(self) {
		_indentIntegrity = [[FLIndentIntegrity alloc] init];
	}
	return self;
}

- (id) initWithName:(NSString*) name testable:(id<FLTestable>) testable {
    self = [self init];
    if(self) {
        _testCaseName = FLRetain(name);
        _unitTest = testable;
    }

    return self;
}

- (id) initWithName:(NSString*) name
           testable:(id<FLTestable>) testable
             target:(id) target
           selector:(SEL) selector {

    self = [self initWithName:name testable:testable];
    if(self) {
        _target = target;
        _selector = [[FLSelector alloc] initWithSelector:selector];
        _willTestSelector = [[FLSelector alloc] initWithString:[NSString stringWithFormat:@"will%@", [_selector.selectorString stringWithUppercaseFirstLetter_fl]]];
        _didTestSelector = [[FLSelector alloc] initWithString:[NSString stringWithFormat:@"did%@", [_selector.selectorString stringWithUppercaseFirstLetter_fl]]];
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_asyncTest release];
    [_indentIntegrity release];
    [_disabledReason release];
    [_testCaseName release];
	[_selector release];
    [_willTestSelector release];
    [_didTestSelector release];
    [_result release];
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

- (void) performTestCaseSelector:(FLSelector*) selector optional:(id) optional{

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

- (BOOL) isAsyncTest {
    return _asyncTest != nil;
}


- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@", [super description], self.testCaseName];
}

- (void) startAsyncTestWithTimeout:(NSTimeInterval) timeout {
    self.asyncTest =  [FLTestCaseAsyncTest testCaseAsyncTest:self timeout:timeout];
}

- (void) startAsyncTest {
    return [self startAsyncTestWithTimeout:FLAsyncTestDefaultTimeout];
}

- (void) verifyAsyncResults:(dispatch_block_t) block {
    [self.asyncTest verifyAsyncResults:block];
}

- (void) finishAsyncTestWithBlock:(void (^)()) finishBlock {
    return [self.asyncTest setFinishedWithBlock:finishBlock];
}

- (void) finishAsyncTest {
    [self.asyncTest setFinished];
}
- (void) finishAsyncTestWithError:(NSError*) error {
    [self.asyncTest setFinishedWithError:error];
}

- (void) waitUntilAsyncTestIsFinished {

}

- (void) setFinishedWithResult:(id)result {


    if([result isError]) {
        [self.result setFailedWithError:result];
    }
    else {
        [self.result setPassed];
    }

    if(!self.isDisabled && [_willTestSelector willPerformOnTarget:_didTestSelector]) {
        [self performTestCaseSelector:_didTestSelector optional:self];
    }

    [super setFinishedWithResult:self.result];
}

- (void) startOperation {
    @try {
        if(self.isDisabled) {
            [self setFinished];
        }

        [self.result setStarted];

        switch(_selector.argumentCount) {
            case 0:
                [_selector performWithTarget:_target];
            break;

            case 1:
                [_selector performWithTarget:_target withObject:self];
            break;

            default:
                [self setDisabledWithReason:[NSString stringWithFormat:@"[%@ %@] has too many paramaters (%ld).",
                    NSStringFromClass([_target class]),
                    _selector.selectorString,
                    (unsigned long) _selector.argumentCount]];
            break;
        }
    }
    @catch(NSException* ex) {
        if(!self.finisher.isFinished) {
            [self setFinishedWithResult:ex.error];
        }
    }
    @finally {
        if(self.asyncTest) {
            [self.asyncTest setTestCaseStarted];
        }
        else if (!self.finisher.isFinished) {
            [self setFinished];
        }
    }
}


@end

#if DEPRECATED
+ (void) runTestWithExpectedFailure:(void (^)()) test
                       checkResults:(void (^)(NSException* ex, BOOL* pass)) checkResults {
 
    BOOL passed = YES;
    @try {
        test();
        passed = NO;
    }
    @catch(NSException* ex) {
        if(checkResults) {
            checkResults(ex, &passed);
        }
    }
    
    FLAssertIsTrueWithComment(passed, @"Didn't catch expected exception");
}

+ (void) runTestWithExpectedFailure:(void (^)()) test {
    [self runTestWithExpectedFailure:test checkResults:nil];
}

+ (void) runTestWithExpectedFailure:(FLAssertionFailure) failureType
                       infoString:(NSString*) infoStringContainsThisOrNil
                               test:(void (^)()) callback {

//    FLAssertionFailure failed = FLAssertionFailureNone;

//    BOOL gotReasonString = infoStringContainsThisOrNil == nil;
    
    @try {
        callback();
    }
    @catch(NSException* ex) {
        
//        if(ex.error.failed) {
//            failed = ex.error.code;
//        }
        
//        gotReasonString = [failure.info loca]
    }
    
//    FLAssertAreEqualWithComment(failed, failureType, nil);
}
#endif
