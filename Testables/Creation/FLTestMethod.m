//
//  FLTestMethod.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestMethod.h"

@implementation FLTestMethod 

@synthesize testClass = _testClass;
@synthesize testSelector = _testSelector;

- (id) initWithTestClass:(Class) aClass selector:(SEL) selector {
	self = [super init];
	if(self) {
        FLAssertNotNil(aClass);
        FLAssertNotNil(selector);
		_testClass = aClass;
        _testSelector = selector;
	}
	return self;
}

+ (id) testMethod:(Class) aClass selector:(SEL) selector {
    return FLAutorelease([[[self class] alloc] initWithTestClass:aClass selector:selector]);
}

- (NSString*) className {
    return NSStringFromClass(_testClass);
}

@end
