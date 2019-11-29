//
//  FLCriticalSection.m
//  FishLamp
//
//  Created by Mike Fullerton on 12/26/13.
//
//

#import "FLCriticalSection.h"
#import "FishLampAssertions.h"

#import <os/lock.h>

// this code is based on: http://www.opensource.apple.com/source/objc4/objc4-371.2/runtime/Accessors.subproj/objc-accessors.m

#define GOODPOWER 7
#define GOODMASK ((1<<GOODPOWER)-1) // 1<<7 == 128. GOODMASK == 127
#define GOODHASH(x) (((long)x >> 5) & GOODMASK)

static os_unfair_lock s_spinlocks[1 << GOODPOWER] = { 0 };

void FLCriticalSection(void* addr, FLCriticalSectionBlock block) {
    FLCAssertNotNil(addr);
    FLCAssertNotNil(block);

    if(block && addr) {
        os_unfair_lock *slotlock = &s_spinlocks[GOODHASH(addr)];
        @try {
            os_unfair_lock_lock(slotlock);
            block();
        }
        @finally {
            os_unfair_lock_unlock(slotlock);
        }
    }
}


