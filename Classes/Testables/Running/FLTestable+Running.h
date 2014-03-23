//
//  FLTestable+Running.h
//  Pods
//
//  Created by Mike Fullerton on 2/8/14.
//
//

#import "FLTestable.h"

@interface FLTestable (Running)
- (id) performAllTestCases;
- (void) appendTestCaseOutput:(FLTestCase*) testCase;
@end
