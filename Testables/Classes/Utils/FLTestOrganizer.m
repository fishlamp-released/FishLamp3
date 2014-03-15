//
//  FLTestOrganizer.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestOrganizer.h"
#import "FLTestFactoryList.h"
#import "FLTestableRunOrder.h"
#import "FLTestFinder.h"
#import "FLTestGroupFinder.h"
#import "FLTestableSubclassFinder.h"
#import "FLTestLoggingManager.h"

#import "FLTestable+Running.h"
#import "FLTestFactory.h"

@interface FLTestOrganizer ()
@property (readwrite, strong, nonatomic) FLSortedTestGroupList* sortedGroupList;
@end

@implementation FLTestOrganizer

//FLSynthesizeSingleton(FLTestOrganizer)

@synthesize sortedGroupList = _sortedGroupList;
@synthesize logger = _logger;

- (id) init {	
	self = [super init];
	if(self) {
        _logger = [[FLTestLoggingManager alloc] init];
    }
	return self;
}

+ (id) testOrganizer {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void)dealloc {
    [_logger release];
	[_sortedGroupList release];
	[super dealloc];
}
#endif

- (FLSortedTestGroupList*) organizeTests {
    FLTestGroupFinder* testRegistry = [FLTestGroupFinder testGroupFinder];
    [testRegistry addTestFinder:[FLTestableSubclassFinder testableSubclassFinder]];
    NSDictionary* groups = [testRegistry findTestGroups];

    return [FLSortedTestGroupList sortedTestGroupList:groups];
}

- (NSArray*) runTests:(FLSortedTestGroupList*) sortedGroupList {

    [self.logger appendLineWithFormat:@"Found %ld unit test classes in %ld groups",
        (unsigned long) sortedGroupList.testCount,
        (unsigned long) sortedGroupList.count];
    
    NSMutableArray* resultArray = [NSMutableArray array];

    for(FLTestFactoryList* group in sortedGroupList) {
    
        [self.logger appendLineWithFormat:@"Testable Group: %@", group.groupName];

        for(id<FLTestFactory> factory in group) {

            @autoreleasepool {
                FLTestable* testable = [factory createTestable:self.logger];

                [self.logger indentLinesInBlock:^{

                    id result = [testable performAllTestCases];

//                    FLPromisedResult result = [self.context runSynchronously:test];

//                    FLTestResultCollection* result =
//                        [FLTestResultCollection fromPromisedResult:
//                            ];

                    if(result) {
                        [resultArray addObject:result];
                    }
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
