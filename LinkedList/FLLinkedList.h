//
//	FLLinkedList.h
//	FishLamp
//
//	Created by Mike Fullerton on 10/20/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

#import "FLLinkedListElement.h"

@class FLLinkedListMutableEnumerator;

/// @brief FLLinkedList is a class for fast linked lists. 
/// This linked list is good for specific things and is not really
/// a general purpose collection. The idea is that you have control
/// over the storage of each element in a list.
///
/// For example, if you had a list of sprites that are FLLinkedListElement objects 
/// (e.g. your not allocating some kind of container, or if you are, you're cacheing that container)
/// If done correctly, you can remove/add/change list without any memory allocation penalties. 
/// 
/// It's also super fast to iterate forward and back in and has a low cost for inserts and deletes.
///
/// Searches, however, are expensive. Log(n). Careful here.
///
/// We have some experimental sorting in which could potentially help, but since the the list
/// don't support indexing, our hands are tied.
/// 
/// Use this is a case where you're doing a lot of inserts and removals, and
/// you need a fast stack/queue that you don't want a lot of memory allocations
/// happening.
///
/// Mutation during fast enumeration is not supported, but you can mutate during iteration with the standard linked list iteration.
/// For example:
///     id walker = list.firstObject;
///     while(walker) {
///         id next = walker.nextObjectInLinkedList;
///         [list removeObject:walker];
///         walker = next;
///     }
/// But be careful, it would be easy to hork yourself.
@interface FLLinkedList : NSObject<NSFastEnumeration> {
@private
	id _firstObject;
	id _lastObject;
    unsigned long _mutationCount;
	NSUInteger _count;
    __unsafe_unretained FLLinkedListMutableEnumerator* _mutableEnumerator;
}

/// Create a new linked list.
+ (FLLinkedList*) linkedList;

- (NSEnumerator*) mutableEnumerator; // you can change the list while enumerating, but the enumeration is a bit slower

/// Get the number of elements in the list.
/// @returns The count.
@property (readonly, assign, nonatomic) NSUInteger count;

/// Get the first object in the list.
/// @returns The first object in the list.
@property (readonly, retain, nonatomic) id firstObject;

/// Get last object in the list.
/// @returns The last object the list.
@property (readonly, retain, nonatomic) id lastObject;

/// Removes and returns the first object in the list.
/// @returns The first object in the list after it is removed.
- (id) removeFirstObject;

/// Removes the last object in the list.
/// @returns The last object in the list after it is removed.
- (id) removeLastObject;
            
/// Pushes an object on the front of the list.
/// @param object The object to be added. Can be any object, or a containing linked list element.
/// @returns The object pushed on the list.
- (id) pushObject:(id) object;

/// Adds object to the end of the list.
/// @param object the object to be added. Can be any object, or a containing linked list element
/// @returns The object inserted.
- (id) addObject:(id) object;

/// Insert an object in the list before another object in the list.
/// @param object The object to be inserted.
/// @param beforeObject The object in the list that the object being added should be inserted BEFORE.
/// @returns The object inserted.
- (id) insertObject:(id) object 
       beforeObject:(id) beforeObject;

/// Insert an object in the list after another object in the list.
/// @param object The object to be inserted.
/// @param afterObject The object in the list that the object being added should be inserted AFTER.
/// @returns The object inserted.
- (id) insertObject:(id) object 
        afterObject:(id) afterObject;

/// Moves an object already in the list to the head of the list.
/// @returns The moved object.
- (id) moveObjectToHead:(id) object;

/// Moves an object already in the list to the end of the list.
/// @param object The object to move to the end of the list.
/// @returns The moved object.
- (id) moveObjectToTail:(id) object;

/// Moves an object already in the list AFTER another object in the list.
/// @param object The object to move
/// @param afterObject The object AFTER which the object should be positioned.
/// @returns The moved object.
- (id) moveObject:(id) object afterObject:(id) afterObject;

/// Moves an object already in the list BEFORE another object in the list.
/// @param object The object to move
/// @param beforeObject The object BEFORE which the object should be positioned.
/// @returns The moved object.
- (id) moveObject:(id) object beforeObject:(id) beforeObject;

/// Swaps the postion of two elements in thest list.
/// @param firstObject The first object to swap positions with.
/// @param secondObject The second object to swap positions with.
- (void) swapListPositions:(id) firstObject secondObject:(id) secondObject;

/// Remove an object from the list.
/// @param object The object to remove.
/// @returns The object removed.
- (id) removeObject:(id) object;

/// Removes all the objects from the list.
- (void) removeAllObjects;

/// Move all the objects to a new list. This removes all the objects from the original list.
/// @returns A list with the new objects in it.
- (FLLinkedList*) moveAllObjectsToNewList; // not thread safe. 

- (void) addObjectsFromList:(FLLinkedList*) list;

/// Sort the list using a Comparator. Use a mergesort algorithm.
/// @param cmptr The comparator to use to sort the list.
/// @warning: Experimental. Not fully tested.
- (void)sortUsingComparator:(NSComparator)cmptr;

/// TODO: fancy search of some kind?

@end

