//
//  FLTestGroupRunner.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestFactoryList.h"
#import "FLTestFactory.h"

@interface FLTestFactoryList ()
//@property (readwrite, strong, nonatomic) NSArray* testFactories;
@end

@implementation FLTestFactoryList

@synthesize groupName = _groupName;
@synthesize testGroup = _testGroup;

- (id) initWithGroup:(Class) group {
	self = [super init];
	if(self) {
        FLAssertNotNil(group);
        _testGroup = group;
		_groupName = FLRetain([group testGroupName]);
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_groupName release];
	[super dealloc];
}
#endif

+ (id) testFactoryList:(Class) group {
    return FLAutorelease([[[self class] alloc] initWithGroup:group]);
}

- (void) organizeTests {
    [self sortUsingComparator:^NSComparisonResult(id<FLTestFactory> obj1, id<FLTestFactory> obj2) {

        NSString* lhs = [obj1.testableClass testName];
        NSString* rhs = [obj2.testableClass testName];

        return [lhs compare:rhs];
    }];

    [self organize];
}


- (Class) classFromObject:(id) object {
    return [object testableClass];
}

@end
