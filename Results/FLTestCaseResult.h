//
//  FLTestCaseResult.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 9/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTestResult.h"

@class FLTestCase;

@interface FLTestCaseResult : FLTestResult {
@private
    FLTestCase* _testCase;
}
+ (id) testCaseResult:(FLTestCase*) forTest;

@property (readonly, strong, nonatomic) FLTestCase* testCase;

@end

