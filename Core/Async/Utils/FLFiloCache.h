//
//  FLFiloCache.h
//  FishLamp
//
//  Created by Mike Fullerton on 1/5/14.
//  Copyright (c) 2014 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import <os/lock.h>
@protocol FLCacheableObject <NSObject>
@property (readwrite, strong, nonatomic) id cacheData;
@end

@interface FLFiloCache : NSObject {
@private
    id<FLCacheableObject> _head;
    os_unfair_lock _spinLock;
}

- (id) popObject;
- (void) addObject:(id<FLCacheableObject>) object;

@end
