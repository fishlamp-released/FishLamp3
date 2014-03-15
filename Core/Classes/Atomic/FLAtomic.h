//
//  FlAtomicBitFlags.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/11/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import <Foundation/Foundation.h>
#import <libkern/OSAtomic.h>

extern void FLAtomicSet64Ptr(int64_t *target, int64_t new_value);
extern int64_t FLAtomicGet64Ptr(int64_t *target);
extern void FLAtomicSet32Ptr(int32_t *target, int32_t new_value);
extern int32_t FLAtomicGet32Ptr(int32_t *target);

#define FLAtomicSetInt64(__INTEGER__, __NEW_INTEGER_VALUE__) \
            FLAtomicSet64Ptr((int64_t*)&(__INTEGER__), (int64_t) __NEW_INTEGER_VALUE__)

#define FLAtomicGetInt64(__INTEGER__) \
            FLAtomicGet64Ptr((int64_t*)&(__INTEGER__))

#define FLAtomicSetInt32(__INTEGER__, __NEW_INTEGER_VALUE__) \
            FLAtomicSet32Ptr((int32_t*)&(__INTEGER__), (int32_t) __NEW_INTEGER_VALUE__)

#define FLAtomicGetInt32(__INTEGER__) \
            FLAtomicGet32Ptr((int32_t*)&(__INTEGER__))

#define FLAtomicIncrementInt32(__INTEGER__) \
            OSAtomicIncrement32((int32_t*) &(__INTEGER__))

#define FLAtomicDecrementInt32(__INTEGER__) \
            OSAtomicDecrement32((int32_t*) &(__INTEGER__))

#define FLAtomicIncrementInt64(__INTEGER__) \
            OSAtomicIncrement64((int64_t*) &(__INTEGER__))

#define FLAtomicDecrementInt64(__INTEGER__) \
            OSAtomicDecrement64((int64_t*) &(__INTEGER__))


// for use with pointers and NSInteger, etc.
// LP64 = "Longs and Pointers are 64 bit"

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64

    #define FLAtomicGetInteger         FLAtomicGetInt64

    #define FLAtomicSetInteger         FLAtomicSetInt64

    #define FLAtomicIncrementInteger   FLAtomicIncrementInt64

    #define FLAtomicDecrementInteger   FLAtomicDecrementInt64

    #define fl_atomic_integer_t        int64_t

#else 

    #define FLAtomicGetInteger         FLAtomicGetInt32

    #define FLAtomicSetInteger         FLAtomicSetInt32

    #define FLAtomicIncrementInteger   FLAtomicIncrementInt32

    #define FLAtomicDecrementInteger   FLAtomicDecrementInt32

    #define fl_atomic_integer_t        int32_t

#endif


#define FLAtomicGetPointer_(__POINTER__) \
            ((void*) FLAtomicGetInteger((fl_atomic_integer_t*) &(__POINTER__)))

#define FLAtomicSetPointer_(__POINTER__, __NEW_POINTER__) \
            FLAtomicSetInteger((fl_atomic_integer_t*) &(__POINTER__), (fl_atomic_integer_t*) __NEW_POINTER__)


