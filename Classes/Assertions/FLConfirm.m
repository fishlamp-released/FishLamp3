//
//  FLConfirmations.m
//  FishLampCore
//
//  Created by Mike Fullerton on 2/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLConfirm.h"
#import "FLAssert.h"

#if VA_ARG_EXPERIMENTAL


/*
#define InitArguments(__OBJ__, __FIRST__) \
        if(__FIRST__) { \
            va_list valist; \
            va_start(valist, __FIRST__); \
            [__OBJ__ setArguments:__FIRST__ valist:valist]; \
            va_end(valist); \
        }

- (void) setArguments:(id) first valist:(va_list) valist {
    FLSetObjectWithRetain(_arguments[_count++], first);
    id obj = nil;
    while ((obj = va_arg(valist, id))) { 
        FLAssertWithComment(_count < FLArgumentListMaxArgumentCount, @"too many arguments");
        FLSetObjectWithRetain(_arguments[_count++], obj);
    }
}
*/

#define callVardicMethodSafely(values...) ({ values *v = { values }; _actualFunction(values, sizeof(v) / sizeof(*v)); })

#define kMaxSize 20
NSString* func(id condition, ...) {
    
    NSString* first = nil;

    void* fake_list[kMaxSize];
    NSUInteger count = 0;
    va_list valist; 
    va_start(valist, condition); 
    void* obj = nil;
    while ((obj = va_arg(valist, void*))) { 
        if(count == 0) {
            first = FLBridge(id, obj);
        }
        else {
            FLAssert(count < kMaxSize);
            fake_list[count] = obj;
        }
        count++;
    }
    va_end(valist); 

    if(count == 0) {
        return condition;
    }
    NSString* formattedString = first;
    if(count > 1) {
        formattedString = FLAutorelease([[NSString alloc] initWithFormat:first arguments: (void*) fake_list]);
    }
 
    return [NSString stringWithFormat:@"%@ (%@)", condition, formattedString];
}    

#define YO(FOO, ...) if(FOO) func([NSString stringWithCString:#FOO encoding:NSASCIIStringEncoding], ##__VA_ARGS__)


void test() {
    YO(1 == 1);
    YO(1 == 1, @"HI");
    YO(1 == 1, @"HI %@", @"THERE");
    YO(1 == 1, @"HI %@ %d %f", @"THERE", 4, 2.5);
}

#endif

