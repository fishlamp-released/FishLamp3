//
//  FLTestable+Running.m
//  Pods
//
//  Created by Mike Fullerton on 2/8/14.
//
//

#import "FLTestable+Running.h"

#import "FLTestLoggingManager.h"

#define kPadWidth [@"starting" length]

@implementation NSObject (FLTestable)

- (void) willRunTestCases:(FLTestCaseList*) testCases {
}

- (void) didRunTestCases:(FLTestCaseList*) testCases {
}

+ (void) specifyRunOrder:(id<FLTestableRunOrder>) runOrder {
}


+ (NSString*) testGroupName {
    return NSStringFromClass([self class]);
}

+ (NSString*) testName {
    return NSStringFromClass([self class]);
}

@end


@implementation FLTestable (Running)

- (void) finishTestCase:(FLTestCase*) testCase {

    if(testCase.result.passed) {

        [self appendTestCaseOutput:testCase];
        [self.logger outdent:nil];
        [self.logger appendLineWithFormat:@"%@: %@", [NSString stringWithLeadingPadding_fl:@"Passed" minimumWidth:kPadWidth], testCase.testCaseName];
    }
    else {

//        [self.logger appendTestCaseOutput:testCase];
        [self.logger outdent:nil];
        [self.logger appendLineWithFormat:@"%@: %@", [NSString stringWithLeadingPadding_fl:@"FAILED" minimumWidth:kPadWidth], testCase.testCaseName ];
    }
}


- (void) startTestCase:(FLTestCase*) testCase {

    [self.logger appendLineWithFormat:@"%@: %@",
        [NSString stringWithLeadingPadding_fl:@"Starting" minimumWidth:kPadWidth],
        testCase.testCaseName];

    [self.logger indent:nil];

}

- (void) appendTestCaseOutput:(FLTestCase*) testCase {
    if(!testCase.result.passed) {
        [self.logger appendLine:@"Log Entries:"];
        [self.logger indentLinesInBlock:^{
            NSArray* logEntries = testCase.result.logEntries;
            for(FLTestResultLogEntry* entry in logEntries) {
                [self.logger appendLine:entry.line];
                if(entry.stackTrace) {
                    [self.logger indentLinesInBlock:^{
                        [entry.stackTrace appendToStringFormatter:self.logger];
                    }];
                }
            }
        }];
    }
}

- (id) performAllTestCases {

    NSArray* startList = FLCopyWithAutorelease(self.testCaseList.testCaseArray);

    for(FLTestCase* testCase in startList) {
        // note that this can alter the run order which is why we're iterating on a copy of the list.
        [testCase prepareTestCase];
    }

    if([self respondsToSelector:@selector(willRunTestCases:)]) {
        [self willRunTestCases:self.testCaseList];
    }

    // the list is now prepared and ordered.
    NSArray* queue = FLMutableCopyWithAutorelease(self.testCaseList.testCaseArray);

    for(FLTestCase* testCase in queue) {

        if(testCase.isDisabled) {
            NSString* reason = testCase.disabledReason;
            if(![reason length]) {
                reason = @"NO REASON";
            }
            [self.logger appendLineWithFormat:@"%@: %@ (%@)",
                [NSString stringWithLeadingPadding_fl:@"DISABLED"
                                         minimumWidth:kPadWidth],
                                         testCase.testCaseName, reason];

            continue;
        }

        [self startTestCase:testCase];

        [testCase performTestCase];

        [self finishTestCase:testCase];
    }

    if([self respondsToSelector:@selector(didRunTestCases:)]) {
        [self didRunTestCases:self.testCaseList];
    }


// todo return result.
    return nil;
}

@end
