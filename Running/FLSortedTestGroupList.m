//
//  FLSortedTestGroupList.m
//  FishLampCore
//
//  Created by Mike Fullerton on 10/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLSortedTestGroupList.h"
#import "FLTestFactoryList.h"

@interface FLSortedTestGroupList ()
@end

@implementation FLSortedTestGroupList

@synthesize groupDictionary = _groupDictionary;

- (id) initWithGroupDictionary:(NSDictionary*) groups {
	self = [super initWithArray:[groups allValues]];
	if(self) {
        FLAssertNotNil(groups);
        _groupDictionary = FLRetain(groups);

        [self organize];
	}
	return self;
}

+ (id) sortedTestGroupList:(NSDictionary*) groups {
    return FLAutorelease([[[self class] alloc] initWithGroupDictionary:groups]);
}

#if FL_MRC
- (void)dealloc {
    [_groupDictionary release];
    [super dealloc];
}
#endif

- (Class) classFromObject:(id) object {
    return [object testGroup];
}

- (NSUInteger) testCount {

    if(_totalTestCount == 0) {
        for(FLTestFactoryList* group in self) {
            _totalTestCount += group.count;
        }
    }

    return _totalTestCount;
}

- (NSArray*) allTests{

    NSMutableArray* runList = [NSMutableArray array];

    for(FLTestFactoryList* group in self) {
        for(id<FLTestFactory> factory in group) {
            [runList addObject:factory];
        }
    }

    return runList;
}

@end

