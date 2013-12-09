//
//  FLTestableOperation.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"
#import "FLOperation.h"

@protocol FLTestable;

@class FLTestCaseList;
@class FLTestResultCollection;
@class FLTestCase;

@interface FLTestableOperation : FLOperation {
@private
    id<FLTestable> _testableObject;
    NSMutableArray* _queue;
    FLTestCase* _currentTestCase;
}

+ (id) testWithTestable:(id<FLTestable>) testableObject;
@end
