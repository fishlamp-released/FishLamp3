//
//  FLTestGroupRunner.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FLTestableRunOrder.h"
#import "FLOrderedRunList.h"

@protocol FLTestFactory;

@interface FLTestFactoryList : FLOrderedRunList {
@private
    Class _testGroup;
    NSString* _groupName;
}

@property (readonly, assign, nonatomic) Class testGroup;

@property (readonly, strong, nonatomic) NSString* groupName;

+ (id) testFactoryList:(Class) testGroup;

- (void) organizeTests;

@end
