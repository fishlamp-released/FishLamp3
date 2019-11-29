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
	}
	return self;
}

- (id) popObject {

    id outObject = nil;
    os_unfair_lock_lock(&_spinLock);

    if(_head) {
        outObject = _head;
        _head = _head.cacheData;
    }

    os_unfair_lock_unlock(&_spinLock);

    return FLAutorelease(outObject);
}

- (void) addObject:(id<FLCacheableObject>) object {

    os_unfair_lock_lock(&_spinLock);

    object.cacheData = _head;
    _head = FLRetain(object);

    os_unfair_lock_unlock(&_spinLock);
}


@end
