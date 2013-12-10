//
//  FLObjectCache.m
//  FishLamp-iOS-Lib
//
//  Created by Mike Fullerton on 12/25/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLObjectCache.h"
#import "NSArray+FLExtras.h"

@implementation FLObjectCache

- (void) _handleLowMemoryWarning:(id) sender {
    [self purgeCache];
}

- (id) init {
    if((self = [super init])) {
#if IOS
    	[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_handleLowMemoryWarning:) 
                                                     name: UIApplicationDidReceiveMemoryWarningNotification
                                                   object: [UIApplication sharedApplication]];
#endif
    }
    
    return self;
}

- (void) dealloc
{
#if IOS
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#endif
    [self purgeCache];
    FLSuperDealloc();
}

- (void) cacheObject:(id) object {
    if(object) {
        FLAssertWithComment([NSThread isMainThread], @"not main thread");

        if(!_cache) {
            _cache = [[NSMutableDictionary alloc] init];
        }

        id cacheKey = [object class];

        NSMutableArray* cache = [_cache objectForKey:cacheKey];
        if(cache) {
            [cache addObject:object];
        }
        else {
            [_cache setObject:[NSMutableArray arrayWithObject:object] forKey:cacheKey];
        }
        
        [object wasCachedInCache:self];
    }
}

- (id) uncacheObjectForClass:(Class) cacheKey {

    FLAssertWithComment([NSThread isMainThread], @"not main thread");
    id object = nil;
    
    NSMutableArray* cache = [_cache objectForKey:cacheKey];
    if(cache && cache.count) {
        object = FLAutorelease(FLRetain([cache lastObject]));
        [cache removeLastObject_fl];

        [object wasUncachedFromCache:self];
    }
    return object;
}

- (void) purgeCache {
    for(NSArray* list in _cache.objectEnumerator) {
        for(id object in list) {
            [object willBePurgedFromCache:self];
        }
    }
    
    FLReleaseWithNil(_cache);
}

@end

@implementation NSObject (FLObjectCache)

- (void) wasCachedInCache:(FLObjectCache*) cache
{
}

- (void) wasUncachedFromCache:(FLObjectCache*) cache
{
}

- (void) willBePurgedFromCache:(FLObjectCache*) cache
{
}

@end

