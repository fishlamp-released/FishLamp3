//
//  FLTestGroupFinder.h
//  FishLampCore
//
//  Created by Mike Fullerton on 10/29/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

@interface FLTestGroupFinder : NSObject {
@private
    NSMutableArray* _testFinders;
    NSDictionary* _testGroups;
}

+ (id) testGroupFinder;

- (void) addTestFinder:(id) finder;

- (NSDictionary*) findTestGroups;

@end
