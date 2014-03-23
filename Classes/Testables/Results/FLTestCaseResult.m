//
//  FLTestCaseResult.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 9/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestCaseResult.h"
#import "FLPrettyString.h"
#import "FLTestCase.h"

@interface FLTestCaseResult ()
@end

@implementation FLTestCaseResult

@synthesize testCase = _testCase;

- (id) initWithTestCase:(FLTestCase*) testCase {
    self = [super init];
    if(self) {
        _testCase = testCase;
    }

    return self;
}

+ (id) testCaseResult:(FLTestCase*) test {
    return FLAutorelease([[[self class] alloc] initWithTestCase:test]);
}

#if FL_MRC
- (void) dealloc {
    [_testCase release];
    [super dealloc];
}
#endif

- (NSString*) testName {
    return self.testCase.testCaseName;
}

@end