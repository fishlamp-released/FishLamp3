//
//  FLRunAllTestsOperationBot.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLRunAllTestsOperation.h"
#import "FLAsyncQueue.h"
#import "FLStaticTestMethodRunner.h"
#import "FLObjcRuntime.h"
#import "FLTestable.h"
#import "FLDispatchQueues.h"

#import "FLTestOrganizer.h"
#import "FLTestFactoryList.h"

#import "FLTestFactory.h"
#import "FLTestableOperation.h"

#import "FLTestLoggingManager.h"

@implementation FLRunAllTestsOperation

+ (id) testRunner {
    return FLAutorelease([[[self class] alloc] init]);
}

- (FLPromisedResult) runSynchronously {

    FLAssertNotNil(self.context);

    FLTestOrganizer* organizer = [FLTestOrganizer testOrganizer];
    [organizer organizeTests];

    FLSortedTestGroupList* sortedGroupList = [organizer sortedGroupList];

    [[FLTestLoggingManager instance] appendLineWithFormat:@"Found %ld unit test classes in %ld groups",
        (unsigned long) sortedGroupList.testCount,
        (unsigned long) sortedGroupList.count];
    
    NSMutableArray* resultArray = [NSMutableArray array];

    for(FLTestFactoryList* group in sortedGroupList) {
    
        [[FLTestLoggingManager instance] appendLineWithFormat:@"Testable Group: %@", group.groupName];

        for(id<FLTestFactory> factory in group) {

            @autoreleasepool {
                FLTestableOperation* test = [factory createTest];

                [FLTestLogger() indentLinesInBlock:^{

                    FLPromisedResult result = [self.context runSynchronously:test];

//                    FLTestResultCollection* result =
//                        [FLTestResultCollection fromPromisedResult:
//                            ];

                    [resultArray addObject:result];
                }];
            }
        }
    }

//    if(results.testResults.count) {
//        NSArray* failedResults = [results failedResults];
//        if(failedResults && failedResults.count) {
//            FLTestOutput(@"%@: %d test cases failed", test.testName, failedResults.count);
//        }
//        else {
//            FLTestOutput(@"%@: %d test cases passed", test.testName, results.testResults.count);
//        }
//    }

    return resultArray;
}

@end

