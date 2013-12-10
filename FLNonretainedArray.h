//
//  FLNonretainedArray.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"

#if EXPERIMENTAL
#if MRC

@interface FLNonretainedArray : NSObject<NSCopying, NSMutableCopying, NSFastEnumeration> {
@private
    CFArrayRef _arrayRef;
    unsigned long _mutationCount;
}
+ (id)array;
+ (id)arrayWithObject:(id)anObject;
+ (id)arrayWithObjects:(const id [])objects count:(NSUInteger)cnt;
+ (id)arrayWithObjects:(id)firstObj, ... NS_FORMAT_FUNCTION(1,2);
+ (id)arrayWithArray:(FLNonretainedArray *)array;

- (id)init;	/* designated initializer */
- (id)initWithObjects:(const id [])objects count:(NSUInteger)cnt;	/* designated initializer */

- (id)initWithObjects:(id)firstObj, ... NS_FORMAT_FUNCTION(1,2);
- (id)initWithArray:(FLNonretainedArray *)array;

- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObject:(id)anObject;
- (BOOL)containsObject:(id)anObject;
@end


@interface FLMutableNonretainedArray : FLNonretainedArray
- (void)addObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (void) removeObject:(id) object;
@end

#endif
#endif
