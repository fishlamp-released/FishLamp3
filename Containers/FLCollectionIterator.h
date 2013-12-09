//
//  FLCollectionIterator.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@protocol FLCollectionIterator <NSFastEnumeration>
@property (readonly, strong) id object;
- (id) nextObject;
@end

@interface NSArray (FLCollectionIterator)
- (id<FLCollectionIterator>) forwardIterator;
- (id<FLCollectionIterator>) reverseIterator;
@end


