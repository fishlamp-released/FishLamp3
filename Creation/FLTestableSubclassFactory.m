//
//  FLTestSubclassFactory.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestableSubclassFactory.h"
#import "FLTestable.h"
#import "FLObjcRuntime.h"
#import "FLTestableOperation.h"

#import "FLTestCase.h"
#import "FLTestCaseList.h"

@interface FLTestable (Internal)
@property (readwrite, strong) FLTestCaseList* testCaseList;
@end

@implementation FLTestable (TestCases)

- (id) initWithTestCaseCreation {
	self = [self init];
	if(self) {
		self.testCaseList = [self createTestCases];
	}
	return self;
}

- (BOOL) isFirstTest:(NSString*) name {
    return FLStringsAreEqual(name, @"setup") || [name rangeOfString:@"firstTest" options:NSCaseInsensitiveSearch].length > 0;

}

- (BOOL) isLastTest:(NSString*) name {
    return FLStringsAreEqual(name, @"teardown") || [name rangeOfString:@"lastTest" options:NSCaseInsensitiveSearch].length > 0;
}

- (BOOL) isTest:(NSString*) name {
    return [name hasPrefix:@"test"];
}

- (void) sortTestCaseList:(NSMutableArray*) list {

    [list sortUsingComparator:^NSComparisonResult(FLTestCase* obj1, FLTestCase* obj2) {

        NSString* lhs = obj1.selector.selectorString;
        NSString* rhs = obj2.selector.selectorString;

        if( [self isFirstTest:lhs] || [self isLastTest:rhs] ) {
            return NSOrderedAscending;
        }
        else if( [self isFirstTest:rhs] || [self isLastTest:lhs]) {
            return NSOrderedDescending;
        }

        return [lhs compare:rhs];
    }];
}


- (FLTestCaseList*) createTestCases {

    NSMutableSet* set = [NSMutableSet set];

    FLRuntimeVisitEachSelectorInClassAndSuperclass([self class],
        ^(FLRuntimeInfo info, BOOL* stop) {
            if(!info.isMetaClass) {
                if(info.class == [FLTestable class]) {
                    *stop = YES;
                }
                else {

                    NSString* name = NSStringFromSelector(info.selector);

                    if( [self isTest:name] ||
                        [self isFirstTest:name] ||
                        [self isLastTest:name] ) {
                        [set addObject:NSStringFromSelector(info.selector)];
                    };
                }
            }
        });


    NSMutableArray* testCaseList = [NSMutableArray array];

    NSString* myName = NSStringFromClass([self class]);
    
    for(NSString* selectorName in set) {

        NSString* testName = [NSString stringWithFormat:@"%@.%@", myName, selectorName];

        FLTestCase* testCase = [FLTestCase testCase:testName
                                           testable:self
                                             target:self
                                           selector:NSSelectorFromString(selectorName)];
        [testCaseList addObject:testCase];
   }

    [self sortTestCaseList:testCaseList];

    return [FLTestCaseList testCaseListWithArrayOfTestCases:testCaseList];
}


@end

@implementation FLTestableSubclassFactory

@synthesize testableClass = _testableClass;

- (id) initWithUnitTestClass:(Class) aClass {
	self = [super init];
	if(self) {
        FLConfirmNotNil(aClass);
		_testableClass = aClass;
	}
	return self;
}

+ (id) testableSubclassFactory:(Class) aClass {
    return FLAutorelease([[[self class] alloc] initWithUnitTestClass:aClass]);
}

- (id) createTestableObject {

    id<FLTestable> testable = FLAutorelease([[self.testableClass alloc] initWithTestCaseCreation]);

    FLConfirmNotNil(testable);
    FLConfirmWithComment([testable isKindOfClass:[FLTestable class]],
                            @"%@ is not a testable object",
                            NSStringFromClass([testable class]));

    return testable;
}

- (FLTestableOperation*) createTest {
    FLTestable* testObject = [self createTestableObject];
    return [FLTestableOperation testWithTestable:testObject];
}


- (NSString*) description {
    return [NSString stringWithFormat:@"%@ Group:%@, Class:%@",
                [super description],
                [self.testableClass testGroupName],
                NSStringFromClass(self.testableClass)];
}

@end
