//
//  FLFiloCache.h
//  FishLamp
//
//  Created by Mike Fullerton on 1/5/14.
//  Copyright (c) 2014 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

@protocol FLCacheableObject <NSObject>
@property (readwrite, strong, nonatomic) id cacheData;
@end

@interface FLFiloCache : NSObject {
@private
    id<FLCacheableObject> _head;
    int32_t _spinLock;
}

- (id) popObject;
- (void) addObject:(id<FLCacheableObject>) object;

@end
