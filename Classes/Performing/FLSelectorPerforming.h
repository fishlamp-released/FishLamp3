//
//  FLSelectorUtils.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/30/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"
#import "NSObject+FLSelectorPerforming.h"

// the functions are here to accept target and selectors that are nil. also
// if the target doesn't respond to the selector, the functions return NO 
// and do nothing. 
// if you know for sure the target responds to the selector, use the NSObject methods instead.

extern BOOL FLSelectorPerforming(id target, SEL selector, id __strong * arguments, int argCount);
extern BOOL FLPerformSelector0(id target, SEL selector);
extern BOOL FLPerformSelector1(id target, SEL selector, id object);
extern BOOL FLPerformSelector2(id target, SEL selector, id object1, id object2);
extern BOOL FLPerformSelector3(id target, SEL selector, id object1, id object2, id object3);
extern BOOL FLPerformSelector4(id target, SEL selector, id object1, id object2, id object3, id object4);

extern BOOL FLPerformSelectorOnMainThread0(id target, SEL selector);
extern BOOL FLPerformSelectorOnMainThread1(id target, SEL selector, id object);
extern BOOL FLPerformSelectorOnMainThread2(id target, SEL selector, id object1, id object2);
extern BOOL FLPerformSelectorOnMainThread3(id target, SEL selector, id object1, id object2, id object3);
extern BOOL FLPerformSelectorOnMainThread4(id target, SEL selector, id object1, id object2, id object3, id object4);

typedef BOOL (*FLSelectorPerformer0)(id, SEL);
typedef BOOL (*FLSelectorPerformer1)(id, SEL, id);
typedef BOOL (*FLSelectorPerformer2)(id, SEL, id, id);
typedef BOOL (*FLSelectorPerformer3)(id, SEL, id, id, id);
typedef BOOL (*FLSelectorPerformer4)(id, SEL, id, id, id, id);

typedef struct {
    FLSelectorPerformer0 performSelector0;
    FLSelectorPerformer1 performSelector1;
    FLSelectorPerformer2 performSelector2;
    FLSelectorPerformer3 performSelector3;
    FLSelectorPerformer4 performSelector4;
} FLDispatcher_t;

extern const FLDispatcher_t FLMainThreadSelectorPerformer;
extern const FLDispatcher_t FLSelectorPerformer;