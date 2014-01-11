//
//  FLTestOrganizer.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FLSortedTestGroupList.h"

@class FLTestable;
@class FLTestGroupFinder;

@interface FLTestOrganizer : NSObject {
@private
    FLSortedTestGroupList* _sortedGroupList;
}

@property (readonly, strong, nonatomic) FLSortedTestGroupList* sortedGroupList;

+ (id) testOrganizer;

- (void) organizeTests;

@end
