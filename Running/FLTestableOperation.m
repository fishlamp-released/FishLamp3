//
//  FLTestableOperation.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestableOperation.h"
#import "FLTestCaseList.h"
#import "FLDispatchQueues.h"
#import "FLOperationContext.h"
#import "FLTestCase.h"
#import "FLTestable.h"
#import "FLTestLoggingManager.h"
#import "NSString+FishLamp.h"


@interface FLTestableOperation ()
@property (readonly, strong, nonatomic) id<FLTestable> testableObject;
@property (readwrite, strong, nonatomic) NSMutableArray* queue;
@property (readwrite, strong, nonatomic) FLTestCase* currentTestCase;
- (void) willRunTestCases:(FLTestCaseList*) testCases;
- (void) didRunTestCases:(FLTestCaseList*) testCases;
@end

@implementation FLTestableOperation

@synthesize testableObject = _testableObject;
@synthesize queue =_queue;
@synthesize currentTestCase = _currentTestCase;


- (id) initWithTestable:(id<FLTestable>) testableObject {
	self = [super init];
	if(self) {
        FLAssertNotNil(testableObject);
		_testableObject = FLRetain(testableObject);
    }
	return self;
}

+ (id) testWithTestable:(id<FLTestable>) testableObject  {
   return FLAutorelease([[[self class] alloc] initWithTestable:testableObject]);
}

#if FL_MRC
- (void)dealloc {
    [_queue release];
	[_testableObject release];
	[super dealloc];
}
#endif

- (NSString*) testName {
    return [_testableObject testName];
}

- (void) willRunTestCases:(FLTestCaseList*) testCases {
    if([_testableObject respondsToSelector:@selector(willRunTestCases:)]) {
        [_testableObject willRunTestCases:testCases];
    }
}

- (void) didRunTestCases:(FLTestCaseList*) testCases {

    if([_testableObject respondsToSelector:@selector(didRunTestCases:)]) {
        [_testableObject didRunTestCases:testCases];
    }
}

- (id) resultForTest {

    for(FLTestCase* testCase in self.testableObject.testCaseList) {
       if(!testCase.result.passed) {
            return FLFailedResult;
       }
    }

    return FLSuccessfulResult;

}

#define kPadWidth [@"starting" length]

- (void) finishedTest:(FLTestCase*) testCase
           withResult:(FLPromisedResult) withResult {

    [[FLTestLoggingManager instance] appendTestCaseOutput:testCase];
    [[FLTestLoggingManager instance] outdent:nil];


    if(testCase.isDisabled) {
        NSString* reason = testCase.disabledReason;
        if(![reason length]) {
            reason = @"NO REASON";
        }
        [[FLTestLoggingManager instance] appendLineWithFormat:@"%@: %@ (%@)",
            [NSString stringWithLeadingPadding_fl:@"DISABLED"
                                     minimumWidth:kPadWidth],
                                     testCase.testCaseName, reason];
    }
    else if(testCase.result.passed) {
        [[FLTestLoggingManager instance] appendLineWithFormat:@"%@: %@", [NSString stringWithLeadingPadding_fl:@"Passed" minimumWidth:kPadWidth], testCase.testCaseName];
    }
    else {
        [[FLTestLoggingManager instance] appendLineWithFormat:@"%@: %@", [NSString stringWithLeadingPadding_fl:@"FAILED" minimumWidth:kPadWidth], testCase.testCaseName ];
    }
}

- (void) beginNextTest:(FLFinisher*) finisher {

    if(_queue.count > 0) {

        FLTestCase* currentTestCase = [_queue objectAtIndex:0];
        [_queue removeObjectAtIndex:0];
        FLAssertNotNil(currentTestCase);

        id<FLTestable> testable = self.testableObject;
        FLAssertNotNil(testable);

        if(!currentTestCase.isDisabled) {
            [[FLTestLoggingManager instance] appendLineWithFormat:@"%@: %@",
                [NSString stringWithLeadingPadding_fl:@"Starting" minimumWidth:kPadWidth],
                currentTestCase.testCaseName];
        }

        [[FLTestLoggingManager instance] indent:nil];

        __block FLTestableOperation* SELF = FLRetain(self);
        __block FLTestCase* testCase = FLRetain(currentTestCase);

        [self.context queueOperation:testCase
                          completion:^(FLPromisedResult result) {

            [SELF finishedTest:testCase withResult:result];

            [FLBackgroundQueue queueBlock:^{
                [self beginNextTest:finisher];
            }];

            FLReleaseWithNil(SELF);
            FLReleaseWithNil(testCase);
        }];

    }
    else {

        [self didRunTestCases:self.testableObject.testCaseList];

        [finisher setFinishedWithResult:[self resultForTest]];
    }
}

- (void) startOperation:(FLFinisher*) finisher {

    [self willRunTestCases:self.testableObject.testCaseList];

    NSArray* startList = FLCopyWithAutorelease(self.testableObject.testCaseList.testCaseArray);
    for(FLTestCase* testCase in startList) {
        // note that this can alter the run order which is why we're iterating on a copy of the list.
        [testCase prepareTestCase];
    }

    // the list is now prepared and ordered.
    self.queue = FLMutableCopyWithAutorelease(self.testableObject.testCaseList.testCaseArray);

    [FLBackgroundQueue queueBlock:^{
        [self beginNextTest:finisher];
    }];
}



@end
