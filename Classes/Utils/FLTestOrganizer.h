//
//  FLTestOrganizer.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FLTestable.h"
#import "FLSortedTestGroupList.h"
#import "FLTestResultCollection.h"
#import "FLTestLoggingManager.h"
#import "FLTestLoggingManager.h"

@interface FLTestOrganizer : NSObject {
@private
    FLSortedTestGroupList* _sortedGroupList;
    FLTestLoggingManager* _logger;
}

FLSingletonProperty(FLTestOrganizer);

@property (readonly, strong) FLTestLoggingManager* logger;

@property (readonly, strong, nonatomic) FLSortedTestGroupList* sortedGroupList;

- (FLSortedTestGroupList*) organizeTests;
- (NSArray*) runTests:(FLSortedTestGroupList*) tests;

@end
