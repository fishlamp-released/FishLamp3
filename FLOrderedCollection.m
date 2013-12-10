//
//	FLOrderedCollection.m
//	FishLamp
//
//	Created by Mike Fullerton on 9/28/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOrderedCollection.h"

@implementation FLOrderedCollection

@synthesize objectArray = _objectArray;

- (id) initWithCapacity:(NSUInteger) capacity {
	if((self = [super init])) {
		_objectDictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
		_objectArray = [[NSMutableArray alloc] initWithCapacity:capacity];
        _indexes = [[NSMutableDictionary alloc] initWithCapacity:capacity];
        _keys = [[NSMutableArray alloc] initWithCapacity:capacity];
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
    FLRelease(_objectDictionary);
    FLRelease(_objectArray);
    FLRelease(_indexes);
    FLRelease(_keys);
	FLSuperDealloc();
}
#endif

- (id) init {
    return [self initWithCapacity:0];
}

+ (FLOrderedCollection*) orderedCollection {
	return FLAutorelease([[FLOrderedCollection alloc] init]);
}

+ (FLOrderedCollection*) orderedCollectionWithCapacity:(NSUInteger) capacity {
	return FLAutorelease([[FLOrderedCollection alloc] initWithCapacity:capacity]);
}

- (NSString*) description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"%@: {\n", [super description]];
    
    for(int i = 0; i < _keys.count; i++) {
        [description appendFormat:@"[index: %d: key: %@]: { %@ }\n", i, [_keys objectAtIndex:i], [_objectArray objectAtIndex:i]]; 
    }
    
    [description appendString:@"}\n"];
    
    return description;
}

- (id<NSFastEnumeration>) forwardKeyEnumerator {
    return _keys;
}

- (id<NSFastEnumeration>) forwardObjectEnumerator {
    return _objectArray;
}

- (void)getObjects:(id __unsafe_unretained [])objects range:(NSRange)range {
    [_objectArray getObjects:objects range:range];
}

//- (void)sortUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context
//{
//	  [self.orderedArray sortUsingFunction:compare context:context];
//	  [self _updateIndexes];
//}
//
//- (void)sortUsingSelector:(SEL)comparator
//{
//	  [self.orderedArray sortUsingSelector:comparator];
//	  [self _updateIndexes];
//}

- (void) addObject:(id) object forKey:(id) key {
    FLAssertNotNil(object);
    FLAssertNotNil(key);
	FLAssertIsNilWithComment([_objectDictionary objectForKey:key], nil);
    ++_mutationCount;
    [_objectDictionary setObject:object forKey:key];
    [_objectArray addObject:object];
    [_keys addObject:key];
    [_indexes setObject:[NSNumber numberWithUnsignedInteger:_objectArray.count - 1] forKey:key];
}

- (void) setObject:(id) object forKey:(id) key {
    FLAssertNotNil(object);
    FLAssertNotNil(key);
    id existingObject = [_objectDictionary objectForKey:key];
    if(existingObject) {
        ++_mutationCount;
        [_objectDictionary setObject:object forKey:key];
        [_objectArray replaceObjectAtIndex:[[_indexes objectForKey:key] intValue] withObject:object];
    }
    else {
		[self addObject:object forKey:key];
	}
}

- (NSUInteger) indexForKey:(id) key {
    NSNumber* idx = [_indexes objectForKey:key];
	return idx ? [idx intValue] : NSNotFound;
}

- (id) objectForKey:(id) key {	
	return [_objectDictionary objectForKey:key];
}

- (id) objectAtIndex:(NSUInteger) idx {
	return [_objectArray objectAtIndex:idx];
}

- (id) keyAtIndex:(NSUInteger) aIndex {
    return [_keys objectAtIndex:aIndex];
}

- (void) removeObjectForKey:(id) key {
    if(key) {
        ++_mutationCount;

        NSNumber* idx = [_indexes objectForKey:key];
        if(idx) {
            NSUInteger theIndex = [idx intValue];
            [_objectDictionary removeObjectForKey:key];
            [_objectArray removeObjectAtIndex:theIndex];
            [_keys removeObjectAtIndex:theIndex];
            [_indexes removeObjectForKey:key];
            
            // shift the changed indexes down.
            for(NSUInteger i = theIndex; i < _keys.count; i++) {
                [_indexes setObject:[NSNumber numberWithUnsignedInteger:i] forKey:[_keys objectAtIndex:i]];
            }
        }
    }
    
//
//	NSUInteger idx = [self indexForObjectWithKey:key];
//	if(idx != NSNotFound)
//	{
//		[self.orderedArray removeObjectAtIndex:idx];
//		for(NSUInteger i = idx; i < self.orderedArray.count; i++)
//		{
//			((FLIndexedObjectContainer*) [self.orderedArray objectAtIndex:i]).index--;
//		}
//		[_objectDictionary removeObjectForKey:key];
//	}
}

- (id) replaceObjectAtIndex:(NSUInteger) atIndex withObject:(id) object forKey:(id) key  {
    ++_mutationCount;
    id previousKey = [_keys objectAtIndex:atIndex];
    [_objectDictionary removeObjectForKey:previousKey];
    [_indexes removeObjectForKey:previousKey];
    
    [_keys replaceObjectAtIndex:atIndex withObject:key];
    id oldObject = FLRetainWithAutorelease([_objectArray objectAtIndex:atIndex]);
    [_objectArray replaceObjectAtIndex:atIndex withObject:object];
    [_objectDictionary setObject:object forKey:key];
    [_indexes setObject:[NSNumber numberWithUnsignedInteger:atIndex] forKey:key];
    return oldObject;
}

- (void) removeObjectAtIndex:(NSUInteger) idx {
    [self removeObjectForKey:[_keys objectAtIndex:idx]];
}

- (NSUInteger) count {
	return _objectArray.count;
}

- (id) firstObject {
	return [_objectArray objectAtIndex:0];
}

- (id) lastObject {
	return [_objectArray lastObject];
}

- (id) removeFirstObject {
    id firstObject = FLRetainWithAutorelease([self firstObject]);
    [self removeObjectAtIndex:0];
    return firstObject;
}

- (id) removeLastObject {
    id lastObject = FLRetainWithAutorelease([self lastObject]);
    [self removeObjectAtIndex:self.count - 1];
    return lastObject;
}

- (void) removeObject:(id) object {
	id thekey = nil;
	for(id key in _objectDictionary) {
		if([_objectDictionary objectForKey:key] == object) {
			thekey = key;
			break;
		}
	}
	
	if(thekey) {
		[self removeObjectForKey:thekey];
	}
}

//- (id<NSFastEnumeration>) forwardKeyEnumerator
//{
//	return [FLOrderedCollectionForwardKeyEnumerator enumeratorWithArray:_objectArray];
//}
//
//- (id<NSFastEnumeration>) forwardObjectEnumerator
//{
//	return [FLOrderedCollectionForwardObjectEnumerator enumeratorWithArray:_objectArray];
//}

- (void) removeAllObjects {
    ++_mutationCount;
	[_objectArray removeAllObjects];
	[_objectDictionary removeAllObjects];
    [_keys removeAllObjects];
    [_indexes removeAllObjects];
}

- (id) _init:(NSMutableDictionary*) objects array:(NSMutableArray*) inArray keys:(NSMutableArray*) keys indexes:(NSDictionary*) indexes
{
	if((self = [super init])) {
		_objectDictionary = [objects mutableCopy];
		_objectArray = [inArray mutableCopy];
        _keys = [keys mutableCopy];
        _indexes = [indexes mutableCopy];
	}
	return self;
}

- (id) copyWithZone:(NSZone*) zone {
	return [[FLOrderedCollection alloc] _init:_objectDictionary array:_objectArray keys:_keys indexes:_indexes];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
	return [self copyWithZone:zone];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state 
                                  objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
	if(state->state >= _objectArray.count) {
		return 0;
	}
	
	NSRange range = NSMakeRange(state->state, len);
	if(range.length + range.location >= _objectArray.count) {
		range.length -= ((range.length + range.location) - _objectArray.count);
	}
	
	[_keys getObjects:buffer range:range];
	state->state = state->state + range.length;
	state->itemsPtr = buffer;
	state->mutationsPtr = &_mutationCount;
	return range.length;
}


@end
