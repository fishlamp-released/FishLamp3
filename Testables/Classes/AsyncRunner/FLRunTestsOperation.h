//
//  FLRunTestsOperation.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#if 0

#import "FishLampCore.h"
#import "FLOperation.h"

@protocol FLTestable;

@class FLTestCaseList;
@class FLTestResultCollection;
@class FLTestCase;

@interface FLRunTestsOperation : FLOperation {
@private
    id<FLTestable> _testableObject;
    NSMutableArray* _queue;
    FLTestCase* _currentTestCase;
}

+ (id) testWithTestable:(id<FLTestable>) testableObject;
@end
#endif