//
//  FLObjectStorage.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 2/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@protocol FLObjectStorage <NSObject>
- (void) writeObject:(id) object;
- (void) writeObjectsInArray:(NSArray*) array; 

- (id) readObject:(id) inputObject;
- (void) deleteObject:(id) object;
- (BOOL) containsObject:(id) object;
@end

@protocol FLObjectStorageExtended <FLObjectStorage>
- (NSUInteger) objectCountForClass:(Class) aClass;
- (void) deleteAllObjectsForClass:(Class) aClass;
- (NSArray*) readAllObjectsForClass:(Class) aClass;
@end

@interface NSObject (FLObjectStorage)

- (id) objectStorageKey_fl;

@end