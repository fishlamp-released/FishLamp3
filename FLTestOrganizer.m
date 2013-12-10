//
//  FLTestOrganizer.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestOrganizer.h"
#import "FLTestFactoryList.h"
#import "FLTestableRunOrder.h"
#import "FLTestFinder.h"
#import "FLTestGroupFinder.h"
#import "FLTestableSubclassFinder.h"

@interface FLTestOrganizer ()
@property (readwrite, strong, nonatomic) FLSortedTestGroupList* sortedGroupList;
@end

@implementation FLTestOrganizer

@synthesize sortedGroupList = _sortedGroupList;

- (id) init {	
	self = [super init];
	if(self) {
    }
	return self;
}

+ (id) testOrganizer {
    return FLAutorelease([[[self class] alloc] init]);
}


#if FL_MRC
- (void)dealloc {
	[_sortedGroupList release];
	[super dealloc];
}
#endif

- (void) organizeTests {
    FLTestGroupFinder* testRegistry = [FLTestGroupFinder testGroupFinder];
    [testRegistry addTestFinder:[FLTestableSubclassFinder testableSubclassFinder]];
    NSDictionary* groups = [testRegistry findTestGroups];

    self.sortedGroupList = [FLSortedTestGroupList sortedTestGroupList:groups];
}

@end
