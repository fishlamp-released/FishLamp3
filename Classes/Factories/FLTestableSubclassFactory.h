//
//  FLTestSubclassFactory.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestFactory.h"

@interface FLTestableSubclassFactory : NSObject<FLTestFactory> {
@private
    Class _testableClass;
}

@property (readonly, assign, nonatomic) Class testableClass;

- (id) initWithUnitTestClass:(Class) aClass;

+ (id) testableSubclassFactory:(Class) aClass;
@end

