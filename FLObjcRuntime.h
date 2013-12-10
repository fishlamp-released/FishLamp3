/*
 *  FLObjcRuntime.h
 *  PackMule
 *
 *  Created by Mike Fullerton on 6/29/11.
 *  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
 *
 */
#import "FishLampObjc.h"
#import <objc/runtime.h>

#import "FLRuntimeInfo.h"


// swizzling

extern void FLSwizzleInstanceMethod(Class c, SEL originalSelector, SEL newSelector);

extern void FLSwizzleClassMethod(Class c, SEL originalSelector, SEL newSelector);

// visiting at runtime

typedef void (^FLRuntimeClassVisitor)(FLRuntimeInfo info, BOOL* stop);
typedef void (^FLRuntimeSelectorVisitor)(FLRuntimeInfo info, BOOL* stop);
typedef void (^FLRuntimeFilterBlock)(FLRuntimeInfo info, BOOL* passed, BOOL* stop);

extern void FLRuntimeVisitEachSelectorInClassAndSuperclass(Class aClass, FLRuntimeSelectorVisitor visitor); // not including NSObject

extern BOOL FLRuntimeVisitEachSelectorInClass(Class aClass, FLRuntimeSelectorVisitor visitor);

extern BOOL FLRuntimeVisitEveryClass(FLRuntimeClassVisitor visitor);

extern NSArray* FLRuntimeAllClassesMatchingFilter(FLRuntimeFilterBlock filter);

// classes

extern NSArray* FLRuntimeSubclassesForClass(Class theClass);

extern BOOL FLRuntimeClassHasSubclass(Class aSuperclass, Class aSubclass);

// selectors and methods

#define FLSelectorsAreEqual(LHS, RHS) sel_isEqual(LHS, RHS)

#define FLRuntimeGetSelectorName(__SEL__) sel_getName(__SEL__)

extern BOOL FLRuntimeClassRespondsToSelector(Class aClass, SEL aSelector);

extern NSArray* FLRuntimeClassesImplementingInstanceMethod(SEL theMethod);

extern NSArray* FLRuntimeMethodsForClass(Class aClass, FLRuntimeFilterBlock filterOrNil);

extern int FLArgumentCountForSelector(SEL selector);

// doesn't count the first two hidden arguments so a selector like this @selector(foo:) will return 1
extern int FLArgumentCountForClassSelector(Class aClass, SEL selector);


// protocols

extern BOOL FLClassConformsToProtocol(Class aClass, Protocol* aProtocol);

extern void FLRuntimeGetSelectorsInProtocol(Protocol* protocol, SEL** list, unsigned int* count);

#if DEBUG
void FLRuntimeLogMethodsForClass(Class aClass);
#endif


#if EXPERIMENTAL
@interface NSObject (FLObjcRuntime)


// http://www.cocoawithlove.com/2008/03/supersequent-implementation.html
// Lookup the next implementation of the given selector after the
// default one. Returns nil if no alternate implementation is found.
- (IMP)getImplementationOf:(SEL)lookup after:(IMP)skip;

@end

#define invokeSupersequent(...) \
    ([self getImplementationOf:_cmd \
        after:impOfCallingMethod(self, _cmd)]) \
            (self, _cmd, ##__VA_ARGS__)

#define invokeSupersequentNoParameters() \
    ([self getImplementationOf:_cmd \
        after:impOfCallingMethod(self, _cmd)]) \
            (self, _cmd)



#endif
