//
//  FLTestableSubclassFinder.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestableSubclassFinder.h"
#import "FLTestable.h"
#import "FLTestableSubclassFactory.h"
#import "FLTestMethod.h"
#import "FLTestGroup.h"

@implementation FLTestableSubclassFinder

+ (id) testableSubclassFinder {
    return FLAutorelease([[[self class] alloc] init]);
}

- (FLTestMethod*) findPossibleTestMethod:(FLRuntimeInfo) info {
    NSString* methodName = NSStringFromSelector(info.selector);
    if([methodName hasPrefix:FLTestStaticMethodPrefix]) {
        if(info.isMetaClass) {
            return [FLTestMethod testMethod:info.class selector:info.selector];
        }
        else {
            NSLog(@"IGNORING: Test method [%@ %@] (should be declared at class scope (+), not object scope (-)",
                NSStringFromClass(info.class),
                NSStringFromSelector(info.selector));
        }
    }

    return nil;
}

- (id<FLTestFactory>) findPossibleUnitTestClass:(FLRuntimeInfo) info {

    if(!info.isMetaClass) {
        if(FLRuntimeClassHasSubclass([FLTestable class], info.class) ||
            FLClassConformsToProtocol(info.class, @protocol(FLTestable))) {
            return [FLTestableSubclassFactory testableSubclassFactory:info.class];
        }
    }

    return nil;
}

- (Class) findPossibleTestGroup:(FLRuntimeInfo) info {
    if(!info.isMetaClass) {
        if(FLRuntimeClassHasSubclass([FLTestGroup class], info.class) ||
            FLClassConformsToProtocol(info.class, @protocol(FLTestGroup))) {
            return info.class;
        }
    }

    return nil;

}

@end
