//
//  FLFiloCache.m
//  FishLamp
//
//  Created by Mike Fullerton on 1/5/14.
//  Copyright (c) 2014 Mike Fullerton. All rights reserved.
//

#import "FLFiloCache.h"

@interface FLFiloCache ()
@property (readwrite, strong) id<FLCacheableObject> head;
@end

@implementation FLFiloCache

@synthesize head = _head;

- (id) init {	
	self = [super init];
	if(self) {
		_spinLock = OS_SPINLOCK_INIT;
	}
	return self;
}

- (id) popObject {

    id outObject = nil;
    OSSpinLockLock(&_spinLock);

    if(_head) {
        outObject = _head;
        _head = _head.cacheData;
    }

    OSSpinLockUnlock(&_spinLock);

    return FLAutorelease(outObject);
}

- (void) addObject:(id<FLCacheableObject>) object {

    OSSpinLockLock(&_spinLock);

    object.cacheData = _head;
    _head = FLRetain(object);

    OSSpinLockUnlock(&_spinLock);
}


@end
