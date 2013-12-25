//
//	FLBitFlags.h
//	FishLamp
//
//	Created by Mike Fullerton on 6/13/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"
#include <libkern/OSAtomic.h>

#import "FLAtomic.h"

// WARNING: don't import anything here. This file is imported by FishLamp.  This is imported by everything.

typedef uint32_t FLBitFlags_t;
typedef uint32_t FLBitMask_t;
#define FLBitMask FLBitMask_t
#define FLBitFlags FLBitFlags_t

// non atomic

#define FLMaskFromBit(__BIT__) \
            (1 << (__BIT__))

#define FLGetBits(__FLAGS__, __BITS__) \
            ((__FLAGS__) & (__BITS__))
                        
#define FLBitsEqualResult(__FLAGS__, __BITS__, __RESULT__) \
            (FLGetBits(__FLAGS__, __BITS__) == __RESULT__)
            
NS_INLINE
BOOL FLTestAllBits(FLBitFlags_t flags, FLBitMask_t mask) {
    return FLBitsEqualResult(flags, mask, mask);
}

#define FLTestBits   FLTestAllBits

#define FLTestAnyBit(__FLAGS__, __BITS__) \
            (FLGetBits(__FLAGS__, __BITS__) != 0)

#define FLBitCheck      FLTestAnyBit
#define FLBitTest       FLTestAnyBit

#define FLClearBits(__FLAGS__, __BITS__) \
            ((void)((__FLAGS__) &= ~(__BITS__)))

#define FLSetBits(__FLAGS__, __BITS__) \
            ((void)((__FLAGS__) |= (__BITS__)))

#define FLSetOrClearBits(__FLAGS__, __BITS__, __SET_OR_CLEAR__) \
            if(__SET_OR_CLEAR__)    FLSetBits(__FLAGS__, __BITS__); \
            else                    FLClearBits(__FLAGS__, __BITS__)

// atomic

#define FLClearBitsAtomic(__FLAGS__, __BITS__) \
            (void) OSAtomicAnd32Barrier( ~(__BITS__), &(__FLAGS__))

#define FLSetBitsAtomic(__FLAGS__, __BITS__) \
            (void) OSAtomicOr32Barrier(__BITS__, &(__FLAGS__))

#define FLSetOrClearBitsAtomic(__FLAGS__, __BITS__, __SET_OR_CLEAR__) \
            if(__SET_OR_CLEAR__) FLSetBitsAtomic(__FLAGS__, __BITS__); \
            else                 FLClearBitsAtomic(__FLAGS__, __BITS__)

#define FLGetBitsAtomic(__FLAGS__, __BITS__)  \
            FLGetBits(FLAtomicGet32(__FLAGS__), __BITS__)

            
#define FLBitsEqualResultAtomic(__FLAGS__, __BITS__, __RESULT__) \
            (FLGetBitsAtomic(__FLAGS__, __BITS__) == __RESULT__)

NS_INLINE
BOOL FLTestAllBitsAtomic(FLBitFlags_t flags, FLBitMask_t mask) {
    return FLBitsEqualResultAtomic(flags, mask, mask);
}

#define FLTestBitsAtomic FLTestAllBitsAtomic

#define FLTestAnyBitAtomic(__FLAGS__, __BITS__) \
            (FLGetBitsAtomic(__FLAGS__, __BITS__) != 0)


extern NSString* FLBitFlagsDescription(FLBitFlags_t flags); // returns string like @"11010011.11010011.11010011.11010011"

//@interface FLBitFlags : NSObject<NSCopying, NSCoding> {
//@private
//    FLBitFlags_t _bitFlags;
//}
//
//@property (readwrite, assign, nonatomic) FLBitFlags_t bitFlags;
//
//- (id) initWithFlags:(FLBitFlags_t) flags;
//+ (FLBitFlags*) bitFlags:(FLBitFlags_t) flags;
//
//- (FLBitFlags_t) testMask:(FLBitFlags_t) mask;
//- (void) clearMask:(FLBitFlags_t) mask;
//- (void) setMask:(FLBitFlags_t) mask;
//- (void) setMask:(FLBitFlags_t) mask to:(BOOL) setOrClear;
//
//- (BOOL) testBit:(uint32_t) bitNumber;
//- (void) clearBit:(uint32_t) bitNumber;
//- (void) setBit:(uint32_t) bitNumber;
//- (void) setBit:(uint32_t) bitNumber to:(BOOL) setOrClear;
//
//- (NSString*) debugString; // returns string like @"11010011.11010011.11010011.11010011"
//
//@end




#define __return_if(v) case (1 << v): return v

/// @brief: this is expected to be a single bit e.g. (1 << 8)
NS_INLINE
uint32_t FLBitIndexFromMask(uint32_t value) {

    switch(value) {
        __return_if(1);
        __return_if(2);
        __return_if(3);
        __return_if(4);
        __return_if(5);
        __return_if(6);
        __return_if(7);
        __return_if(8);
        __return_if(9);
        __return_if(10);
        __return_if(11);
        __return_if(12);
        __return_if(13);
        __return_if(14);
        __return_if(15);
        __return_if(16);
        __return_if(17);
        __return_if(18);
        __return_if(19);
        __return_if(20);
        __return_if(21);
        __return_if(22);
        __return_if(23);
        __return_if(24);
        __return_if(25);
        __return_if(26);
        __return_if(27);
        __return_if(28);
        __return_if(29);
        __return_if(30);
        __return_if(31);
    }
    return 0;
    
}

#undef __return_if
