//
//  FLTestMethod.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"

@interface FLTestMethod : NSObject {
@private
    Class _testClass;
    SEL _testSelector;
}

@property (readonly, strong, nonatomic) NSString* className;

@property (readonly, assign, nonatomic) Class testClass;
@property (readonly, assign, nonatomic) SEL testSelector;

+ (id) testMethod:(Class) aClass selector:(SEL) selector;


@end
