//
//	FLOrderedCollection.h
//	FishLamp
//
//	Created by Mike Fullerton on 9/28/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

/// @brief this class is about quick access. uses a lot more memory. inserts/deletes a bit slower. 
@interface FLOrderedCollection : NSObject<NSCopying, NSMutableCopying, NSFastEnumeration> {
@private
	NSMutableDictionary* _objectDictionary;
	NSMutableDictionary* _indexes;
	NSMutableArray* _keys;
	NSMutableArray* _objectArray;
    unsigned long _mutationCount;
}

@property (readonly, strong, nonatomic) NSArray* objectArray;
@property (readonly, assign, nonatomic) NSUInteger count;
@property (readonly, strong, nonatomic) id firstObject;
@property (readonly, strong, nonatomic) id lastObject;

@property (readonly, strong, nonatomic) id<NSFastEnumeration> forwardKeyEnumerator;
@property (readonly, strong, nonatomic) id<NSFastEnumeration> forwardObjectEnumerator;

- (id) initWithCapacity:(NSUInteger) capacity;

+ (FLOrderedCollection*) orderedCollection;
+ (FLOrderedCollection*) orderedCollectionWithCapacity:(NSUInteger) capacity;

// setting an object will add it to the end of the array if it's not already in collection
- (void) setObject:(id) object forKey:(id) key;
- (id) objectForKey:(id) key;
- (id) objectAtIndex:(NSUInteger) idx;

- (void) removeObjectForKey:(id) key;
- (void) removeObjectAtIndex:(NSUInteger) idx;

- (void) removeObject:(id) object;
- (void) removeAllObjects;

- (id) replaceObjectAtIndex:(NSUInteger) atIndex withObject:(id) object forKey:(id) forKey;

- (NSUInteger) indexForKey:(id) key;
- (id) keyAtIndex:(NSUInteger) aIndex;

- (id) removeFirstObject;
- (id) removeLastObject;


// TODO
//- (void)sortUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context;
//- (void)sortUsingSelector:(SEL)comparator;

@end


//@property (readonly, copy, nonatomic) NSArray* objectArray;
//@property (readonly, strong, nonatomic) NSDictionary* objectDictionary;
//@property (readonly, strong, nonatomic) NSArray* keys;
//@property (readonly, strong, nonatomic) NSMutableDictionary* indexes;
//- (void) addOrReplaceObject:(id) object forKey:(id) key;
