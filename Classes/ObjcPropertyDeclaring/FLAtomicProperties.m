//
//  FLAtomicProperties.m
//  FishLamp
//
//  Created by Mike Fullerton on 12/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAtomicProperties.h"
#import "FLAtomic.h"


// this code is based on: http://www.opensource.apple.com/source/objc4/objc4-371.2/runtime/Accessors.subproj/objc-accessors.m

#define GOODPOWER 7
#define GOODMASK ((1<<GOODPOWER)-1) // 1<<y == 128. 
#define GOODHASH(x) (((long)x >> 5) & GOODMASK)
static OSSpinLock FLPropertyLocks[1 << GOODPOWER] = { 0 };

// I think for the hash table, the only time the value of the spin lock is important is when
// we have two contentions - not necessary the same variable, right?? Low chance of a collision
// happening at the same time. I wish I understood it a bit better, but we'll leave it for now.

#if FL_MRC
id FLAtomicPropertyGet(id* addr) {

    OSSpinLock *slotlock = &FLPropertyLocks[GOODHASH(addr)];
    OSSpinLockLock(slotlock);
    id value = [*addr retain];
    OSSpinLockUnlock(slotlock);

    // for performance, we (safely) issue the autorelease OUTSIDE of the spinlock.
    return [value autorelease];
}

void FLAtomicPropertySet(id* addr, id newValue, dispatch_block_t setter) {

    if (*addr == newValue) {
        return;
    }
   
    [newValue retain];

    OSSpinLock *slotlock = &FLPropertyLocks[GOODHASH(addr)];
    OSSpinLockLock(slotlock);
    id oldValue = *addr;
    if(setter) setter();
    *addr = newValue;
    OSSpinLockUnlock(slotlock);
    [oldValue release];
}

void FLAtomicPropertyCopy(id* addr, id newValue, dispatch_block_t setter) {

    newValue = [newValue copyWithZone:NULL];

    OSSpinLock *slotlock = &FLPropertyLocks[GOODHASH(addr)];
    OSSpinLockLock(slotlock);
    id oldValue = *addr;
    if(setter) setter();
    *addr = newValue;
    OSSpinLockUnlock(slotlock);
    [oldValue release];
}



#else 

id FLAtomicPropertyGet(id __strong * addr) {
    OSSpinLock *slotlock = &FLPropertyLocks[GOODHASH(addr)];
    OSSpinLockLock(slotlock);
    id value = *addr;
    OSSpinLockUnlock(slotlock);
    return value;
}

void FLAtomicPropertyCopy(id __strong * addr, id newValue, dispatch_block_t setter) {

    newValue = [newValue copyWithZone:NULL];
    
    OSSpinLock *slotlock = &FLPropertyLocks[GOODHASH(addr)];
    OSSpinLockLock(slotlock);
    if(setter) setter();
    *addr = newValue;
    OSSpinLockUnlock(slotlock);
}

void FLAtomicPropertySet(id __strong * addr, id newValue, dispatch_block_t setter) {

    if (*addr == newValue) {
        return;
    }

    OSSpinLock *slotlock = &FLPropertyLocks[GOODHASH(addr)];
    OSSpinLockLock(slotlock);
    if(setter) setter();
    *addr = newValue;
    OSSpinLockUnlock(slotlock);
}

#endif

void FLAtomicCreateIfNil(id __strong * addr, Class theClass) {
    if(addr && *addr == nil) {
        OSSpinLock *slotlock = &FLPropertyLocks[GOODHASH(addr)];
        OSSpinLockLock(slotlock);
        if(*addr == nil) {
            *addr = [[theClass alloc] init];
        }
        OSSpinLockUnlock(slotlock);
    }
}

void FLAtomicCreateIfNilWithBlock(id __strong* addr, FLAtomicCreateBlock block) {
    if(addr && *addr == nil) {
        OSSpinLock *slotlock = &FLPropertyLocks[GOODHASH(addr)];
        OSSpinLockLock(slotlock);
        if(*addr == nil) {
            *addr = FLRetain(block());
        }
        OSSpinLockUnlock(slotlock);
    }
}
