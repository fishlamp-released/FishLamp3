//
//  FLTestable.m
//  FishLampCore
//
//  Created by Mike Fullerton on 8/26/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestable.h"
#import "FishLampAssertions.h"

#import "FLTestCaseList.h"
#import "FLTestResultCollection.h"
#import "FLTestCaseResult.h"

@interface FLTestable ()
//@property (readwrite, strong) FLTestCaseList* testCaseList;
@property (readwrite, strong) FLExpectedTestResult* expectedTestResult;
@property (readwrite, strong) FLTestResultCollection* testResults;
@end

@implementation FLTestable

- (id) initWithLogger:(id<FLStringFormatter>) logger {
    self = [self init];
    if(self) {
        _logger = FLRetain(logger);
    }

    return self;
}

@synthesize testCaseList = _testCaseList;
@synthesize expectedTestResult = _expectedTestResult;
@synthesize testResults = _testResults;
@synthesize logger = _logger;

#if FL_MRC
- (void)dealloc {
	[_testCaseList release];
    [_expectedTestResult release];
    [_testResults release];
    [_logger release];

    [super dealloc];
}
#endif


- (NSString*) description {
    return [NSString stringWithFormat:@"%@ { group=%@ }", [super description], [[self class] testGroupName]];
}

//+ (NSString*) testName {
//    return NSStringFromClass([self class]);
//}

- (FLTestCase*) testCaseForSelector:(SEL) selector {
    return [self.testCaseList testCaseForSelector:selector];
}

- (FLTestCase*) testCaseForName:(NSString*) name {
    return [self.testCaseList testCaseForName:name];
}

//+ (void) specifyRunOrder:(id<FLTestableRunOrder>) runOrder {
//}

//+ (NSString*) testGroupName {
//    return
//
//    NSStringFromClass([self testGroupClass]);
//}

@end
