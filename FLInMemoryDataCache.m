//
//	FLInMemoryDataCache.m
//	FishLamp
//
//	Created by Mike Fullerton on 10/21/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLInMemoryDataCache.h"
#if REFACTOR
#if IOS
#import "FLLowMemoryHandler.h"
#endif
#import "FLCacheManager.h"
#endif
#import "FLLinkedListObjectContainer.h"

//#define TRACE 0

@implementation FLInMemoryDataCache

@synthesize removeAllOnLowMemoryWarning = _removeAllOnLowMemoryWarning;
@synthesize cacheSize = _maxCount;

- (void) handleLowMemoryWarning:(id)sender
{
	if(_removeAllOnLowMemoryWarning)
	{
		[self removeAllObjects];
	}
}

- (id) init
{
	if((self = [self initWithCapacity:0]))
	{
	}
	
	return self;
}

- (void) _doClearCache:(NSNotification*) notification
{
	[self removeAllObjects];
}

- (id) initWithCapacity:(NSUInteger) max
{
	if((self = [super init]))
	{
		_maxCount = max;
		
		_list = [[FLLinkedList alloc] init];
		_objects = [[NSMutableDictionary alloc] initWithCapacity:max];
		_removeAllOnLowMemoryWarning = YES;
		
#if REFACTOR
#if IOS
		[[FLLowMemoryHandler defaultHandler] addObserver:self action:@selector(handleLowMemoryWarning:)];

		[[NSNotificationCenter defaultCenter] addObserver:self 
				selector:@selector(_doClearCache:) 
				name:FLCacheManagerEmptyCacheNotification
				object:[FLCacheManager instance]];
#endif
#endif

	}
	return self;
}

- (id) oldestObjectInCache
{
	return [_list.lastObject object];
}

- (id) keyForOldestObjectInCache
{
	return [_list.lastObject key]; 
}

- (void) expireLastObject
{
	id last = _list.lastObject;
	if(last)
	{	
		[_objects removeObjectForKey:[last key]];
        [_list removeObject:last];
	}
}

- (id) expireOldestObjectInCache
{
	id object = FLAutorelease(FLRetain([_list.lastObject object]));
	[self expireLastObject];
	return object;
}

- (void) updateOrAddObject:(id) object forKey:(id) key
{
	@synchronized(self)
	{
		id node = [_objects objectForKey:key];
		if(node)
		{
			if([node object] != object)
			{
				[node setObject:object]; // refresh object if needed
			}
			[_list moveObjectToHead:node];
		}
		else if(_maxCount > 0)
		{
			while(_list.count >= _maxCount)
			{
				[self expireLastObject];
			}
			
			FLLinkedListObjectContainer* newObject = [[FLLinkedListObjectContainer alloc] init];
			newObject.key = key;
			newObject.object = object;
			
			[_list pushObject:newObject];
			[_objects setObject:newObject forKey:key];
			FLRelease(newObject);
		}

#if TRACE		
		FLLog(@"Updated %@:%@", key, object);
#endif

		
#if OUTPUT_ON_CHANGE
		FLLog([_list description]);
#endif		
	}
}

- (id) objectForKey:(id)key
{
	@synchronized(self)
	{
		FLLinkedListObjectContainer* node = [_objects objectForKey:key];
		if(node)
		{
#if TRACE		
			FLLog(@"Cache Hit %@:%@", node.key, node.object);
#endif		  

			[_list moveObjectToHead:node];
			return FLAutorelease(FLRetain(node.object));
		}
#if TRACE
		else
		{
			FLLog(@"Cache miss %@", key);
		}
#endif		  
	}
	return nil;
}

- (BOOL) objectInCache:(id) key
{
	@synchronized(self)
	{
		return [_objects objectForKey:key] != nil;
	}
	
	return NO; // stooopid compiler
}


- (void) removeObjectForKey:(id) forKey
{
	@synchronized(self)
	{
		FLLinkedListObjectContainer* node = [_objects objectForKey:forKey];
		if(node)
		{
#if TRACE		
			FLLog(@"Removed %@:%@", node.key, node.object);
#endif

			[_objects removeObjectForKey:forKey];
			[_list removeObject:node];
		}
	}
}


- (void)removeAllObjects
{
	@synchronized(self)
	{
		[_list removeAllObjects];
		[_objects removeAllObjects];
	}
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if REFACTOR
#if IOS
	[[FLLowMemoryHandler defaultHandler] removeObserver:self];
#endif
#endif
	FLRelease(_objects);
	FLRelease(_list);
	FLSuperDealloc();
}


@end
