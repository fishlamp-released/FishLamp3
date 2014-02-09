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

#import "FLTestCase.h"
#import "FLTestCaseList.h"

#import "FLAsyncTestCase.h"
#import "FLAsyncTestable.h"

@interface FLTestable (Internal)
@property (readwrite, strong) FLTestCaseList* testCaseList;
@end

@implementation FLTestable (TestCases)

- (id) initWithTestCaseCreation:(id<FLStringFormatter>) logger {
	self = [self initWithLogger:logger];
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

- (FLTestCase*) createTestCase:(NSString*) testName
           testable:(id<FLTestable>) testable
             target:(id) target
           selector:(SEL) selector {

    return [FLTestCase testCase:testName
                       testable:self
                         target:self
                       selector:selector];
}

- (FLTestCaseList*) createTestCases {

    NSMutableSet* set = [NSMutableSet set];

    FLRuntimeVisitEachSelectorInClassAndSuperclass([self class],
        ^(FLRuntimeInfo info, BOOL* stop) {
            if(!info.isMetaClass) {
                if(info.class == [FLTestable class] || info.class == [FLAsyncTestable class]) {
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

        FLTestCase* testCase = [self createTestCase:testName
                                           testable:self
                                             target:self
                                           selector:NSSelectorFromString(selectorName)];
        [testCaseList addObject:testCase];
   }

    [self sortTestCaseList:testCaseList];

    return [FLTestCaseList testCaseListWithArrayOfTestCases:testCaseList];
}


@end

@implementation FLAsyncTestable (FLTestCases)

- (FLTestCase*) createTestCase:(NSString*) name
           testable:(id<FLTestable>) testable
             target:(id) target
           selector:(SEL) selector {

    return [FLAsyncTestCase testCase:name
                       testable:self
                         target:self
                       selector:selector];
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

- (FLTestable*) createTestable:(id<FLStringFormatter>) logger {

    id<FLTestable> testable = FLAutorelease([[self.testableClass alloc] initWithTestCaseCreation:logger]);

    FLConfirmNotNil(testable);
    FLConfirm([testable isKindOfClass:[FLTestable class]],
                            @"%@ is not a testable object",
                            NSStringFromClass([testable class]));

    return testable;
}


- (NSString*) description {
    return [NSString stringWithFormat:@"%@ Group:%@, Class:%@",
                [super description],
                [self.testableClass testGroupName],
                NSStringFromClass(self.testableClass)];
}

@end
