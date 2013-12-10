//
//  FLCollectionIterator.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCollectionIterator.h"

@interface FLArrayIterator : NSObject<FLCollectionIterator> {
@private
    NSInteger _index;
    id _object;
    NSArray* _array;
}
@property (readwrite, strong) id object;
@property (readwrite, strong) NSArray* array;
@property (readwrite, assign) NSInteger arrayIndex;

- (id) initWithArray:(NSArray*) array;
+ (id) arrayIterator:(NSArray*) array;

@end

@implementation FLArrayIterator

@synthesize arrayIndex = _index;
@synthesize object = _object;
@synthesize array = _array;

- (id) initWithArray:(NSArray*) array {
    self = [super init];
    if(self) {
        self.array = array;
        _index = NSNotFound;
        
        if(array.count > 0) {
            _index = -1;
        }
    }
    
    return self;
}

- (NSInteger ) nextIndex {
    return self.arrayIndex + 1;
}

+ (id) arrayIterator:(NSArray*) array {
    return FLAutorelease([[[self class] alloc] initWithArray:array]);
}

- (id) init {
    self = [super init];
    if(self) {
        _index = NSNotFound;
    }
    return self;
}

- (id) nextObject {
    self.object = nil;

    NSInteger index = [self nextIndex];
    _index = NSNotFound;
    
    if(index >= 0 && index < _array.count) {
        @try {
            self.object = [_array objectAtIndex:index];
            _index = index;
        }
        @catch(NSException* ex) {
        }
    }
    return self.object;
}

#if FL_MRC
- (void) dealloc {
    [_array release];
    [_object release];
    [super dealloc];
}
#endif

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id *)stackbuf count:(NSUInteger)len
{
    id object = self.nextObject;
    
    if(object == nil) {
        return 0;
    }
	
	stackbuf[0] = object;
	
	state->state = _index;
	state->itemsPtr = stackbuf;
	state->mutationsPtr = FLBridge(void*, self); // mutations are allowed, this is essentially a no-op

	return 1;
}

@end

@interface FLArrayReverseIterator : FLArrayIterator
@end

@implementation FLArrayReverseIterator

- (id) initWithArray:(NSArray*) array {
    self = [super initWithArray:array];
    if(self) {
        self.arrayIndex = array.count;
    }
    
    return self;
}

- (NSInteger ) nextIndex {
    return self.arrayIndex - 1;
}

@end

@implementation NSArray (FLCollectionIterator)
- (id<FLCollectionIterator>) forwardIterator {
    return [FLArrayIterator arrayIterator:self];
}
- (id<FLCollectionIterator>) reverseIterator {
    return [FLArrayReverseIterator arrayIterator:self];
}
@end

//typedef id (^FLTranslatorBlock)(id from);
//
//@interface FLIteratorTranslator : NSObject<FLCollectionIterator> {
//@private
//    id<FLCollectionIterator> _iterator;
//    FLTranslatorBlock _block;
//}
//- (id) initWithIterator:(id<FLCollectionIterator>) iterator translator:(FLTranslatorBlock) translator;
//+ (id) iteratorTranslator:(id<FLCollectionIterator>) iterator translator:(FLTranslatorBlock) translator;
//@end
//
//@interface FLIteratorTranslator ()
//@property (readwrite, strong) id<FLCollectionIterator> iterator;
//@property (readwrite, copy) FLTranslatorBlock block;
//@end
//
//@implementation FLIteratorTranslator
//
//@synthesize iterator = _iterator;
//@synthesize block = _block;
//
//- (id) initWithIterator:(id<FLCollectionIterator>) iterator translator:(FLTranslatorBlock) translator {
//    self = [super init];
//    if(self) {
//        self.iterator = iterator;
//        self.block = translator;
//    }
//    return self;
//}
//
//+ (id) iteratorTranslator:(id<FLCollectionIterator>) iterator translator:(FLTranslatorBlock) translator {
//    return FLAutorelease([[[self class] alloc] initWithIterator:iterator translator:translator]);
//}
//
//- (id) nextObject {
//    id next = _iterator.nextObject;
//    if(next && _block) {
//        next = _block(next);
//    }
//    return next;
//}
//
//#if FL_MRC
//- (void) dealloc {
//    [_iterator release];
//    [_block release];
//    [super dealloc];
//}
//#endif
//
//
//@end
