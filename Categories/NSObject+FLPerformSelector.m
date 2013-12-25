//
//  NSObject+FLPerformSelector.m
//  FishLampCore
//
//  Created by Mike Fullerton on 4/28/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSObject+FLPerformSelector.h"
//#import "FLObjcRuntime.h"
#import "FLSelectorPerforming.h"
#import "FishLampAssertions.h"

// TODO: see objc/message.h

@implementation NSObject (FLPerformSelector)

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"

//NS_INLINE
void FLConfirmNoReturnObject(id obj) {
    FLConfirmIsNilWithComment(obj, @"selector must return nil (or ARC will leak the object). Selector returned: %@", [obj description]); \
}


#define FLAssertNotMetaClass(c) FLAssertWithComment(!class_isMetaClass(c), @"attempting to execute selector on a meta class");


- (void) performSelector_fl:(SEL) selector
                   argCount:(int) argCount
                 withObject:(id) object1
                 withObject:(id) object2
                 withObject:(id) object3 {

// TODO: this was a nice assert. Add it back without taking dependency on Runtime

//    FLAssertWithComment(FLArgumentCountForClassSelector([self class], selector) == argCount, @"@selector(%@) arg count is %d, should be: %d", NSStringFromSelector(selector), argCount, FLArgumentCountForClassSelector([self class], selector));

    switch(argCount) {
        case 0: 
            [self performSelector:selector];
        break;

        case 1: 
            [self performSelector:selector withObject:object1];
        break;
        
        case 2: 
            [self performSelector:selector withObject:object1 withObject:object2];
        break;

        case 3: 
            [self performSelector_fl:selector withObject:object1 withObject:object2 withObject:object3];
        break;
        
        default:
            FLAssertFailedWithComment(@"Unsupported arg count: %d", argCount);
            break;
    }
}

- (void) performSelector_fl:(SEL) selector
              withArguments:(id __strong *) objects
            argumumentCount:(NSUInteger) argCount {

    FLConfirmIsNotNil(selector);
    
    if(argCount < 3) {
        switch(argCount) {
            case 0: 
                [self performSelector:selector];
            break;

            case 1: 
                [self performSelector:selector withObject:objects[0]];
            break;
            
            case 2: 
                [self performSelector:selector withObject:objects[0] withObject:objects[1]];
            break;

            default:
                FLAssertionFailedWithComment(@"only args 0 - 2 supported");
                break;
        }
        return;
    }
    
    NSMethodSignature *signature  = [self methodSignatureForSelector:selector];
    NSInvocation      *invocation = [NSInvocation invocationWithMethodSignature:signature];

    [invocation setTarget:self];                        // index 0 (hidden)
    [invocation setSelector:selector];                  // index 1 (hidden)
    
    for(int i = 0; i < argCount; i++) {
        [invocation setArgument:&objects[i] atIndex:i + 2];        // index 2
    }

    [invocation retainArguments];
    [invocation invoke];

    FLAssertWithComment([[invocation methodSignature] methodReturnLength] == 0, @"returned objects will leak so it's not supported (blame ARC)." );
}  

- (void) performSelector_fl:(SEL) selector
              withObject:(id) object1
              withObject:(id) object2 
              withObject:(id) object3 {
    
    FLConfirmIsNotNil(selector);
    NSMethodSignature *signature  = [self methodSignatureForSelector:selector];
    NSInvocation      *invocation = [NSInvocation invocationWithMethodSignature:signature];

    [invocation setTarget:self];                        // index 0 (hidden)
    [invocation setSelector:selector];                  // index 1 (hidden)
    [invocation setArgument:&object1 atIndex:2];        // index 2
    [invocation setArgument:&object2 atIndex:3];        // index 3
    [invocation setArgument:&object3 atIndex:4];        // index 4
    [invocation retainArguments];
    [invocation invoke];

    FLAssertWithComment([[invocation methodSignature] methodReturnLength] == 0, @"returned objects will leak so it's not supported (blame ARC)." );
}              

- (void) performSelector_fl:(SEL) selector
              withObject:(id) object1
              withObject:(id) object2 
              withObject:(id) object3
              withObject:(id) object4 {
    
    FLConfirmIsNotNil(selector);
    NSMethodSignature *signature  = [self methodSignatureForSelector:selector];
    NSInvocation      *invocation = [NSInvocation invocationWithMethodSignature:signature];

    [invocation setTarget:self];                        // index 0 (hidden)
    [invocation setSelector:selector];                  // index 1 (hidden)
    [invocation setArgument:&object1 atIndex:2];        // index 2
    [invocation setArgument:&object2 atIndex:3];        // index 3
    [invocation setArgument:&object3 atIndex:4];        // index 4
    [invocation setArgument:&object4 atIndex:5];        // index 4
    [invocation retainArguments];
    [invocation invoke];

    FLAssertWithComment([[invocation methodSignature] methodReturnLength] == 0, @"returned objects will leak so it's not supported (blame ARC)." );
}              



- (void) performSelector_fl:(SEL) selector
               outObject:(id*) outObject {

    FLConfirmIsNotNil(selector);
    NSMethodSignature *signature  = [self methodSignatureForSelector:selector];
    NSInvocation      *invocation = [NSInvocation invocationWithMethodSignature:signature];

    [invocation setTarget:self];                        // index 0 (hidden)
    [invocation setSelector:selector];                  // index 1 (hidden)
    [invocation setArgument:&outObject atIndex:2];        // index 2
    [invocation retainArguments];
    [invocation invoke];
}

- (void) performSelector_fl:(SEL) selector
              withObject:(id) object
               outObject:(id*) outObject {

    FLConfirmIsNotNil(selector);
    NSMethodSignature *signature  = [self methodSignatureForSelector:selector];
    NSInvocation      *invocation = [NSInvocation invocationWithMethodSignature:signature];

    [invocation setTarget:self];                        // index 0 (hidden)
    [invocation setSelector:selector];                  // index 1 (hidden)
    [invocation setArgument:&object atIndex:2];        // index 2
    [invocation setArgument:&outObject atIndex:3];        // index 2
    [invocation retainArguments];
    [invocation invoke];
}

- (BOOL) performOptionalSelector_fl:(SEL) selector {
    return FLPerformSelector0(self, selector);
}

- (BOOL) performOptionalSelector_fl:(SEL) selector
             withObject:(id) object {
    return FLPerformSelector1(self, selector, object);
}             

- (BOOL) performOptionalSelector_fl:(SEL) selector
               withObject:(id) object1
               withObject:(id) object2 {
    return FLPerformSelector2(self, selector, object1, object2);
}             

- (BOOL) performOptionalSelector_fl:(SEL) selector
               withObject:(id) object1
               withObject:(id) object2
               withObject:(id) object3 {
    return FLPerformSelector3(self, selector, object1, object2, object3);
}             

- (BOOL) performOptionalSelector_fl:(SEL) selector 
               withObject:(id) object1
               withObject:(id) object2
               withObject:(id) object3 
               withObject:(id) object4 {
    
    return FLPerformSelector4(self, selector, object1, object2, object3, object4);
} 
@end
