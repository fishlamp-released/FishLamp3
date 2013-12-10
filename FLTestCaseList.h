//
//  FLTestCaseList.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/4/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampObjc.h"

@class FLTestCase;

@interface FLTestCaseList : NSObject<NSFastEnumeration> {
@private
    NSMutableArray* _testCaseArray;
    BOOL _isDisabled;
    NSString* _disabledReason;
}

@property (readonly, assign, nonatomic) BOOL isDisabled;
@property (readonly, strong, nonatomic) NSString* disabledReason;
@property (readonly, strong, nonatomic) NSArray* testCaseArray;

+ (id) testCaseList;

+ (id) testCaseListWithArrayOfTestCases:(NSArray*) testCaseArray;

- (void) addTestCase:(FLTestCase*) testCase;

- (FLTestCase*) testCaseForName:(NSString*) name;

- (FLTestCase*) testCaseForSelector:(SEL) selector;

- (void) disableAllTests:(NSString*) reason;

- (FLTestCase*) orderFirst:(SEL) testCase;

- (FLTestCase*) orderLast:(SEL) testCase;

- (FLTestCase*) order:(SEL) testCase
                   after:(SEL) anotherTestCase;

- (FLTestCase*) order:(SEL) testCase
                  before:(SEL) anotherTestCase;

@end


