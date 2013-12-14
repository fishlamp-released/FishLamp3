//
//  FLAtomic.m
//  FishLampCore
//
//  Created by Mike Fullerton on 10/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAtomic.h"
#import "FishLampCore.h"

// this code is based on: http://www.opensource.apple.com/source/objc4/objc4-371.2/runtime/Accessors.subproj/objc-accessors.m

#define GOODPOWER 7
#define GOODMASK ((1<<GOODPOWER)-1) // 1<<y == 128. 
#define GOODHASH(x) (((long)x >> 5) & GOODMASK)
static OSSpinLock s_spinlocks[1 << GOODPOWER] = { 0 };

void FLCriticalSection(void* addr, dispatch_block_t block) {
    FLAssertNotNil(addr);
    FLAssertNotNil(block);

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
