//
//  FLRunTestCaseOperation.h
//  Pods
//
//  Created by Mike Fullerton on 2/8/14.
//
//

#if 0

#import "FLOperation.h"

@class FLTestCase;

@interface FLRunTestCaseOperation : FLOperation {
@private

    FLTestCase* _testCase;
}

+ (id) runTestCaseOperation:(FLTestCase*) testCase;

@end

#endif