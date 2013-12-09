//
//  FLLinkedListElement.h
//  FLCore
//
//  Created by Mike Fullerton on 4/24/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@class FLLinkedList;

/// FLLinkedListElement is protocol for a linked list object for use with FLLinkedList
@protocol FLLinkedListElement <NSObject>
@property (readwrite, strong, nonatomic) id nextObjectInLinkedList;
@property (readwrite, strong, nonatomic) id previousObjectInLinkedList;
@property (readwrite, assign, nonatomic) FLLinkedList* linkedList;
@end

/// Default methods for using any object in a FLLinkedList
@interface NSObject (FLLinkedList)
@property (readwrite, strong, nonatomic) id nextObjectInLinkedList;
@property (readwrite, strong, nonatomic) id previousObjectInLinkedList;
@property (readwrite, assign, nonatomic) FLLinkedList* linkedList;
@end

/// FLLinkedListElement is a concrete base class for making custom objects for use with FLLinkedList
@interface FLLinkedListElement : NSObject<FLLinkedListElement> {
@private
	id _nextObjectInLinkedList;
	id _previousObjectInLinkedList;
    __unsafe_unretained FLLinkedList* _linkedList;
}
@property (readwrite, strong, nonatomic) id nextObjectInLinkedList;
@property (readwrite, strong, nonatomic) id previousObjectInLinkedList;
@property (readwrite, assign, nonatomic) FLLinkedList* linkedList;

@end