//
//  FLCriticalSection.m
//  FishLamp
//
//  Created by Mike Fullerton on 12/26/13.
//
//

#import "FLCriticalSection.h"
#import "FishLampAssertions.h"

#import <libkern/OSAtomic.h>


// this code is based on: http://www.opensource.apple.com/source/objc4/objc4-371.2/runtime/Accessors.subproj/objc-accessors.m

#define GOODPOWER 7
#define GOODMASK ((1<<GOODPOWER)-1) // 1<<7 == 128. GOODMASK == 127
#define GOODHASH(x) (((long)x >> 5) & GOODMASK)

static OSSpinLock s_spinlocks[1 << GOODPOWER] = { 0 };

void FLCriticalSection(void* addr, FLCriticalSectionBlock block) {
    FLCAssertNotNil(addr);
    FLCAssertNotNil(block);

    if(block && addr) {
        OSSpinLock *slotlock = &s_spinlocks[GOODHASH(addr)]; \
        @try { \
            OSSpinLockLock(slotlock);
            block();
        }
        @finally {
            OSSpinLockUnlock(slotlock); \
        }
    }
}


