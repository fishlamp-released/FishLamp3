//
//  FLTestFinder.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLObjcRuntime.h"

@protocol FLTestFactory;
@class FLTestMethod;

@protocol FLTestClassFinder <NSObject>
- (id<FLTestFactory>) findPossibleUnitTestClass:(FLRuntimeInfo) info;
@end

@protocol FLTestMethodFinder <NSObject>
- (FLTestMethod*) findPossibleTestMethod:(FLRuntimeInfo) info;
@end

@protocol FLTestGroupClassFinder <NSObject>
- (Class) findPossibleTestGroup:(FLRuntimeInfo) info;
@end