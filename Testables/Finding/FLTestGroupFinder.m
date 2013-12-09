//
//  FLTestGroupFinder.m
//  FishLampCore
//
//  Created by Mike Fullerton on 10/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestGroupFinder.h"
#import "FLTestableSubclassFinder.h"
#import "FLTestFactory.h"
#import "FLTestMethod.h"
#import "FLTestable.h"
#import "FLTestFactoryList.h"
#import "FLTestFinder.h"

@interface FLTestGroupFinder ()
@property (readwrite, strong, nonatomic) NSDictionary* testGroups;
@end

@implementation FLTestGroupFinder

@synthesize testGroups = _testGroups;

- (id) init {	
	self = [super init];
	if(self) {
		_testFinders = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (id) testGroupFinder {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void)dealloc {
    [_testFinders release];
    [super dealloc];
}
#endif

- (NSArray*) removeUnitTestBaseClasses:(NSArray*) factoryList {

    FLAssertNotNil(factoryList);

    NSMutableArray* newList = [NSMutableArray array];

    for(NSInteger i = 0; i < factoryList.count; i++) {
        id<FLTestFactory> factory = [factoryList objectAtIndex:i];
        Class outerClass = [factory testableClass];

        BOOL foundSubclass = NO;

        for(NSInteger j = 0; j < factoryList.count; j++) {

            if( i == j ) {
                continue;
            }

            Class innerClass = [[factoryList objectAtIndex:j] testableClass];

            if( [innerClass isSubclassOfClass:outerClass] ) {
                foundSubclass = YES;
                break;
            }

        }

        if(!foundSubclass) {
            [newList addObject:factory];
        }
    }

    return newList;
}

- (void) addTestFinder:(id) finder {
    [_testFinders addObject:finder];
}

- (NSArray*) addUnitTestsForTestMethods:(NSDictionary*) testMethods {

// TODO: create test objects for methods.

    return nil;
}

- (NSDictionary*) sortClassesIntoGroups:(NSArray*) allTestFactories
                       discoveredGroups:(NSDictionary*) discoveredGroups {

    FLAssertNotNil(allTestFactories);
    FLAssertNotNil(discoveredGroups);

    NSMutableDictionary* groups = [NSMutableDictionary dictionary];

    for(id<FLTestFactory> factory in allTestFactories) {

        Class testGroupClass = nil;

        NSString* testGroupName = [[factory testableClass] testGroupName];
        if(testGroupName) {
            testGroupClass = [discoveredGroups objectForKey:testGroupName];

            FLConfirmNotNilWithComment(testGroupClass, @"Unknown test group: %@", testGroupName);
        }

        if(!testGroupClass) {
            testGroupClass = [[factory testableClass] testGroupClass];
        }

        if(!testGroupClass) {
            testGroupClass = [FLTestGroup class];
        }

        FLTestFactoryList* factoryList = [groups objectForKey:[testGroupClass testGroupName]];
        if(!factoryList) {
            factoryList = [FLTestFactoryList testFactoryList:testGroupClass];
            [groups setObject:factoryList forKey:[testGroupClass testGroupName]];
        }
        
        [factoryList addObject:factory];
    }

    for(FLTestFactoryList* group in [groups allValues]) {
        [group organizeTests];
    }

    return groups;

}

- (NSDictionary*) findTestGroups {

    NSMutableArray* unitTestFactories = [NSMutableArray array];
    NSMutableDictionary* testMethods = [NSMutableDictionary dictionary];
    NSMutableDictionary* testGroups = [NSMutableDictionary dictionary];

    FLRuntimeVisitEveryClass(
        ^(FLRuntimeInfo classInfo, BOOL* stop) {
            for(id finder in _testFinders) {

                // find test subclasses
                if([finder respondsToSelector:@selector(findPossibleUnitTestClass:)]) {
                    id<FLTestFactory> factory = [finder findPossibleUnitTestClass:classInfo];
                    if(factory) {
                        [unitTestFactories addObject:factory];
                    }
                }

                // find test groups
                if([finder respondsToSelector:@selector(findPossibleTestGroup:)]) {
                    Class testGroup = [finder findPossibleTestGroup:classInfo];
                    if(testGroup) {
                        [testGroups setObject:testGroup forKey:[testGroup testGroupName]];
                    }
                }
            }

            FLRuntimeVisitEachSelectorInClass(classInfo.class,
                ^(FLRuntimeInfo methodInfo, BOOL* stopInner) {
                    for(id finder in _testFinders) {
                        if([finder respondsToSelector:@selector(findPossibleTestMethod:)]) {
                            FLTestMethod* testMethod = [finder findPossibleTestMethod:methodInfo];

                            if(testMethod) {
                                NSMutableArray* methods = [testMethods objectForKey:testMethod.className];
                                if(!methods) {
                                    methods = [NSMutableArray array];
                                    [testMethods setObject:methods forKey:testMethod.className];
                                }
                                [methods addObject:testMethod];
                            }
                        }
                    }
                }
            );

        }
    );

    NSArray* testMethodObjectFactories = [self addUnitTestsForTestMethods:testMethods];
    if(testMethodObjectFactories) {
        [unitTestFactories addObjectsFromArray:testMethodObjectFactories];
    }

    NSArray* finalizedFactoryList = [self removeUnitTestBaseClasses:unitTestFactories];

    return [self sortClassesIntoGroups:finalizedFactoryList discoveredGroups:testGroups];
}

@end
