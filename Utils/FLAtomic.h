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

NS_INLINE
void _FLAtomicSet64(int64_t *target, int64_t new_value) {
    while (true) {
        int64_t old_value = *target;
        if (OSAtomicCompareAndSwap64Barrier(old_value, new_value, target)) {
            return;
        }
    }
}


NS_INLINE
int64_t _FLAtomicGet64(int64_t *target) {
    while (true) {
        int64_t value = *target;
        if (OSAtomicCompareAndSwap64Barrier(value, value, target)) {
            return value;
        }
    }
    
    return 0;
}


NS_INLINE
void _FLAtomicSet32(int32_t *target, int32_t new_value) {
    while (true) {
        int32_t old_value = *target;
        if (OSAtomicCompareAndSwap32Barrier(old_value, new_value, target)) {
            return;
        }
    }
}


NS_INLINE
int32_t _FLAtomicGet32(int32_t *target) {
    while (true) {
        int32_t value = *target;
        if (OSAtomicCompareAndSwap32Barrier(value, value, target)) {
            return value;
        }
    }
    
    return 0;
}

#define FLAtomicSet64(__INTEGER__, __NEW_INTEGER_VALUE__) \
            _FLAtomicSet64((int64_t*)&(__INTEGER__), (int64_t) __NEW_INTEGER_VALUE__)

#define FLAtomicGet64(__INTEGER__) \
            _FLAtomicGet64((int64_t*)&(__INTEGER__))

#define FLAtomicSet32(__INTEGER__, __NEW_INTEGER_VALUE__) \
            _FLAtomicSet32((int32_t*)&(__INTEGER__), (int32_t) __NEW_INTEGER_VALUE__)

#define FLAtomicGet32(__INTEGER__) \
            _FLAtomicGet32((int32_t*)&(__INTEGER__))

#define FLAtomicIncrement32(__INTEGER__) \
            OSAtomicIncrement32((int32_t*) &(__INTEGER__))

#define FLAtomicDecrement32(__INTEGER__) \
            OSAtomicDecrement32((int32_t*) &(__INTEGER__))

#define FLAtomicIncrement64(__INTEGER__) \
            OSAtomicIncrement64((int64_t*) &(__INTEGER__))

#define FLAtomicDecrement64(__INTEGER__) \
            OSAtomicDecrement64((int64_t*) &(__INTEGER__))


// for use with pointers and NSInteger, etc.
// LP64 = "Longs and Pointers are 64 bit"

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64

    #define FLAtomicGetInteger         FLAtomicGet64

    #define FLAtomicSetInteger         FLAtomicSet64

    #define FLAtomicIncrementInteger   FLAtomicIncrement64

    #define FLAtomicDecrementInteger   FLAtomicIncrement64

    #define fl_atomic_integer_t           int64_t

#else 

    #define FLAtomicGetInteger         FLAtomicGet32

    #define FLAtomicSetInteger         FLAtomicSet32

    #define FLAtomicIncrementInteger   FLAtomicIncrement32

    #define FLAtomicDecrementInteger   FLAtomicIncrement32

    #define fl_atomic_integer_t           int32_t

#endif


#define FLAtomicGetPointer_(__POINTER__) \
            ((void*) FLAtomicGetInteger((fl_atomic_integer_t*) &(__POINTER__)))

#define FLAtomicSetPointer_(__POINTER__, __NEW_POINTER__) \
            FLAtomicSetInteger((fl_atomic_integer_t*) &(__POINTER__), (fl_atomic_integer_t*) __NEW_POINTER__)

extern void FLCriticalSection(void* shared_addr, dispatch_block_t block);

