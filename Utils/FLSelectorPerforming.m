//
//  FLSelectorUtils.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/30/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSelectorPerforming.h"
#import "FLObjcRuntime.h"
#import "FishLampAssertions.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"


BOOL FLPerformSelector(id target, SEL selector, id __strong * arguments, int argCount) {

    FLAssertWithComment(FLArgumentCountForClassSelector([target class], selector) == argCount, @"@selector(%@) arg count is %d, should be: %d", NSStringFromSelector(selector), argCount, FLArgumentCountForClassSelector([target class], selector));

    if([target respondsToSelector:selector]) {
        [target performSelector_fl:selector withArguments:arguments argumumentCount:argCount];
        return YES;
    }
    return NO;
}

BOOL FLPerformSelector0(id target, SEL selector) {
    if([target respondsToSelector:selector]) {
        [target performSelector:selector];
        return YES;
    }
    return NO;
} 

BOOL FLPerformSelector1(id target, SEL selector, id object) {
    if([target respondsToSelector:selector]) {
        [target performSelector:selector withObject:object];
        return YES;
    }
    return NO;
} 

BOOL FLPerformSelector2(id target, SEL selector, id object1, id object2) {
    if([target respondsToSelector:selector]) {
        [target performSelector:selector withObject:object1 withObject:object2];
        return YES;
    }

    return NO;
} 

BOOL FLPerformSelector3(id target, SEL selector, id object1, id object2, id object3) {
    if([target respondsToSelector:selector]) {
        [target performSelector_fl:selector withObject:object1 withObject:object2 withObject:object3];
        return YES;
    }

    return NO;
} 

BOOL FLPerformSelector4(id target, SEL selector, id object1, id object2, id object3, id object4) {
    if([target respondsToSelector:selector]) {
        [target performSelector_fl:selector withObject:object1 withObject:object2 withObject:object3  withObject:object4];
        return YES;
    }

    return NO;
} 

BOOL FLPerformSelectorOnMainThread0(id target, SEL selector) {
    if([target respondsToSelector:selector]) {
        if([NSThread currentThread] == [NSThread mainThread]) {
            [target performSelector:selector];
        }
        else {

            __block id theTarget = FLRetain(target);
            dispatch_async(dispatch_get_main_queue(), ^{
                [theTarget performSelector:selector];
                FLReleaseWithNil(theTarget);
            });
        }
        
        return YES;
    }
    return NO;
}

BOOL FLPerformSelectorOnMainThread1(id target, SEL selector, id object) {
    if([target respondsToSelector:selector]) {
        if([NSThread currentThread] == [NSThread mainThread]) {
            [target performSelector:selector withObject:object];
        }
        else {
            __block id theTarget = FLRetain(target);
            __block id theObject = FLRetain(object);
            dispatch_async(dispatch_get_main_queue(), ^{
                [target performSelector:selector withObject:theObject];
                FLReleaseWithNil(theTarget);
                FLReleaseWithNil(theObject);
            });
        }
        return YES;
    }
    return NO;
}

BOOL FLPerformSelectorOnMainThread2(id target, SEL selector, id object1, id object2) {
    if([target respondsToSelector:selector]) {
        if([NSThread currentThread] == [NSThread mainThread]) {
            [target performSelector:selector withObject:object1 withObject:object2];
        }
        else {
            __block id theTarget = FLRetain(target);
            __block id theObject1 = FLRetain(object1);
            __block id theObject2 = FLRetain(object2);
            dispatch_async(dispatch_get_main_queue(), ^{
                [theTarget performSelector:selector withObject:theObject1 withObject:theObject2];
                FLReleaseWithNil(theTarget);
                FLReleaseWithNil(theObject1);
                FLReleaseWithNil(theObject2);
            });
        }
        return YES;
    }
    return NO;
}

BOOL FLPerformSelectorOnMainThread3(id target, SEL selector, id object1, id object2, id object3) {
    if([target respondsToSelector:selector]) {
        if([NSThread currentThread] == [NSThread mainThread]) {
            [target performSelector_fl:selector withObject:object1 withObject:object2 withObject:object3];
        }
        else {
            __block id theTarget = FLRetain(target);
            __block id theObject1 = FLRetain(object1);
            __block id theObject2 = FLRetain(object2);
            __block id theObject3 = FLRetain(object3);
            dispatch_async(dispatch_get_main_queue(), ^{
                [theTarget performSelector_fl:selector withObject:theObject1 withObject:theObject2 withObject:theObject3];
                FLReleaseWithNil(theTarget);
                FLReleaseWithNil(theObject1);
                FLReleaseWithNil(theObject2);
                FLReleaseWithNil(theObject3);
            });
        }
        return YES;
    }
    return NO;
}

BOOL FLPerformSelectorOnMainThread4(id target, SEL selector, id object1, id object2, id object3, id object4) {
    if([target respondsToSelector:selector]) {
        if([NSThread currentThread] == [NSThread mainThread]) {
            [target performSelector_fl:selector withObject:object1 withObject:object2 withObject:object3 withObject:object4];
        }
        else {
            __block id theTarget = FLRetain(target);
            __block id theObject1 = FLRetain(object1);
            __block id theObject2 = FLRetain(object2);
            __block id theObject3 = FLRetain(object3);
            __block id theObject4 = FLRetain(object4);
            dispatch_async(dispatch_get_main_queue(), ^{
                [theTarget performSelector_fl:selector withObject:theObject1 withObject:theObject2 withObject:theObject3 withObject:theObject4];
                FLReleaseWithNil(theTarget);
                FLReleaseWithNil(theObject1);
                FLReleaseWithNil(theObject2);
                FLReleaseWithNil(theObject3);
                FLReleaseWithNil(theObject4);
            });
        }
        return YES;
    }
    return NO;
}

#pragma GCC diagnostic pop
