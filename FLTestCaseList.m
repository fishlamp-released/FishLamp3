//
//  FLTestCaseList.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/10/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestCaseList.h"
#import "FLTestCase.h"
#import "FishLampCore.h"

@interface FLTestCaseList ()
@property (readwrite, strong) NSString* disabledReason;

- (FLTestCase*) setRunOrder:(NSUInteger) order forSelector:(SEL) selector;
- (FLTestCase*) setRunOrder:(NSUInteger) order forTestCase:(FLTestCase*) testCase;
- (NSUInteger) runOrderForTestCase:(FLTestCase*) testCase;

@end

@implementation FLTestCaseList

@synthesize isDisabled = _isDisabled;
@synthesize disabledReason = _disabledReason;
@synthesize testCaseArray = _testCaseArray;

- (id) initWithArrayOfTestCases:(NSArray*) array {

    self = [super init];
	if(self) {
		_testCaseArray = [array mutableCopy];
	}
	return self;
}

- (id) init {	
	self = [super init];
	if(self) {
        _testCaseArray = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (id) testCaseList {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) testCaseListWithArrayOfTestCases:(NSArray*) testCases {
    return FLAutorelease([[[self class] alloc] initWithArrayOfTestCases:testCases]);
}

#if FL_MRC
- (void)dealloc {
    [_disabledReason release];
    [_testCaseArray release];
	[super dealloc];
}
#endif

- (void) disableAllTests:(NSString*) reason {
    _isDisabled = YES;
    self.disabledReason = reason;

    for(FLTestCase* testCase in _testCaseArray) {
        [testCase setDisabledWithReason:reason];
    }
}

- (FLTestCase*) testCaseForName:(NSString*) name {

    FLTestCase* outTestCase = nil;

    for(FLTestCase* testCase in _testCaseArray) {
        if([testCase.selector.selectorName isEqual:name] ) {
            outTestCase  = testCase;
            break;
        }
    }

    FLConfirmNotNil(outTestCase, @"unable to find test case for \"%@\"", name);
    
    return outTestCase;
}

- (FLTestCase*) testCaseForSelector:(SEL) selector {

    FLTestCase* outTestCase = nil;

    for(FLTestCase* testCase in _testCaseArray) {
        if([testCase.selector isEqualToSelector:selector]) {
            outTestCase = testCase;
        }
    }

    FLConfirmNotNil(outTestCase, @"unable to find test case for \"%@\"", NSStringFromSelector(selector));

    return outTestCase;
}

- (FLTestCase*) testCaseForObject:(id) object {
    return [object isKindOfClass:[FLTestCase class]] ? object : [self testCaseForName:object];
}

- (NSUInteger) runOrderForTestCase:(FLTestCase*) testCase {
    return [_testCaseArray indexOfObject:testCase];
}

- (void) addTestCase:(FLTestCase*) testCase {
    [_testCaseArray addObject:testCase];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_testCaseArray countByEnumeratingWithState:state objects:buffer count:len];
}

- (FLTestCase*) setRunOrder:(NSUInteger) order forTestCase:(FLTestCase*) testCase {
    FLConfirmNotNil(testCase);

    [_testCaseArray removeObject:FLRetainWithAutorelease(testCase)];

    if(order == 0) {
        [_testCaseArray insertObject:testCase atIndex:0];
    }
    else if(order >= (_testCaseArray.count - 1)) {
        [_testCaseArray addObject:testCase];
    }
    else {
        [_testCaseArray insertObject:testCase atIndex:order];
    }

    return testCase;
}

- (FLTestCase*) setRunOrder:(NSUInteger) order forSelector:(SEL) selector {
    return [self setRunOrder:order forTestCase:[self testCaseForSelector:selector]];
}

- (NSString*) description {
    return [_testCaseArray description];
}

//- (void) orderTestCaseFirst:(FLTestCase*) testCase {
//    [self setRunOrder:0 forTestCase:testCase];
//}
//
//- (void) orderTestCaseLast:(FLTestCase*) testCase {
//    [self setRunOrder:_testCases.count - 1 forTestCase:testCase];
//}
//
//- (void) orderTestCase:(FLTestCase*) testCase
//         afterTestCase:(FLTestCase*) anotherTestCase {
//    NSInteger idx = [_testCases indexOfObject:anotherTestCase];
//    if(idx != NSNotFound) {
//        [self setRunOrder:idx + 1 forTestCase:anotherTestCase];
//    }
//}
//
//- (void) orderTestCase:(FLTestCase*) testCase
//        beforeTestCase:(FLTestCase*) anotherTestCase {
//    NSInteger idx = [_testCases indexOfObject:anotherTestCase];
//    if(idx != NSNotFound) {
//        [self setRunOrder:idx - 1 forTestCase:anotherTestCase];
//    }
//}


- (FLTestCase*) orderFirst:(SEL) testCase {
    return [self setRunOrder:0 forTestCase:[self testCaseForSelector:testCase]];
}

- (FLTestCase*) orderLast:(SEL) testCase {
    return [self setRunOrder:_testCaseArray.count - 1 forTestCase:[self testCaseForSelector:testCase]];
}

- (FLTestCase*) order:(SEL) testCase
                   after:(SEL) anotherTestCase {
    NSInteger idx = [_testCaseArray indexOfObject:[self testCaseForSelector:anotherTestCase]];
    FLConfirm(idx != NSNotFound, @"run order for %@ not found", NSStringFromSelector(testCase));
    return [self setRunOrder:idx + 1 forTestCase:[self testCaseForSelector:testCase]];
}

- (FLTestCase*) order:(SEL) testCase
                  before:(SEL) anotherTestCase {
    NSInteger idx = [_testCaseArray indexOfObject:[self testCaseForSelector:anotherTestCase]];
    FLConfirm(idx != NSNotFound, @"run order for %@ not found", NSStringFromSelector(testCase));
    return [self setRunOrder:idx - 1 forTestCase:[self testCaseForSelector:testCase]];
}

@end
