//
//  FLLinkedListObjectContainer.h
//  FLCore
//
//  Created by Mike Fullerton on 4/24/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

#import "FLLinkedListElement.h"
#import "FLLinkedList.h"

@interface FLLinkedListObjectContainer : FLLinkedListElement {
@private
	id _object;
    id _key;
}
@property (readwrite, retain, nonatomic) id key;
@property (readwrite, retain, nonatomic) id object;

- (id) initWithObject:(id) object;
+ (FLLinkedListObjectContainer*) linkedListObjectContainer:(id) object;

@end

/// This is a category added to FLLinkedList for finding FLLinkedListObjectContainer in a list.
/// This assumes all the elements in the list are FLLinkedListObjectContainer objects.
@interface FLLinkedList (FLLinkedListObjectContainer)
    
/// Find an FLLinkedListObjectContainer in the list using a contained object.
/// @param object The contained object in owned by a FLLinkedListObjectContainer in the list to find.
/// @returns The container that owns the searched for object.
- (FLLinkedListObjectContainer*) findContainerWithObject:(id) object;

/// Find an FLLinkedListObjectContainer in the list using a container key.
/// @param key The key for FLLinkedListObjectContainer in the list to find.
/// @returns The container that has a matching key.
- (FLLinkedListObjectContainer*) findContainerWithKey:(id) key;
@end