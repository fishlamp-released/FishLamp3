//
//  FLOrderedRunList.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLOrderedRunList.h"

@interface FLOrderedRunListElement : NSObject {
@private
    id _object;
    NSInteger _weight;
}
@property (readwrite, strong, nonatomic) id object;
@property (readwrite, assign, nonatomic) NSInteger weight;
@end

@implementation FLOrderedRunListElement
@synthesize object = _object;
@synthesize weight = _weight;

- (id) initWithObject:(id) object {
	self = [super init];
	if(self) {
		self.object = object;
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_object release];
	[super dealloc];
}
#endif

+ (id) orderedRunListElement:(id) object {
   return FLAutorelease([[[self class] alloc] initWithObject:object]);
}

@end

@implementation FLOrderedRunList

- (id) initWithArray:(NSArray*) array {
	self = [super init];
	if(self) {
        _runList = [array mutableCopy];
	}
	return self;
}

- (id) init {	
	self = [super init];
	if(self) {
		_runList = [[NSMutableArray alloc] init];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_runList release];
	[super dealloc];
}
#endif

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_runList countByEnumeratingWithState:state objects:buffer count:len];
}

- (Class) classFromObject:(id) object {
    return object;
}

- (NSUInteger) indexOfClass:(Class) aClass {
    for(NSUInteger i = 0; i < _runList.count; i++) {
        Class theClass = [self classFromObject:[_runList objectAtIndex:i]];
        if(theClass == aClass) {
            return i;
        }
    }

    return NSNotFound;
}

- (void) orderClassFirst:(Class) aClass {
    NSUInteger theIndex = [self indexOfClass:aClass];
    if(theIndex != NSNotFound) {
        id theObject = FLRetainWithAutorelease([_runList objectAtIndex:theIndex]);
        [_runList removeObjectAtIndex:theIndex];
        [_runList insertObject:theObject atIndex:0];
    }
}

- (void) orderClassLast:(Class) aClass {
    NSUInteger theIndex = [self indexOfClass:aClass];
    if(theIndex != NSNotFound) {
        id theObject = FLRetainWithAutorelease([_runList objectAtIndex:theIndex]);
        [_runList removeObjectAtIndex:theIndex];
        [_runList addObject:theObject];
    }
}


- (void) orderClass:(Class) aClass anotherClass:(Class) anotherClass before:(BOOL) before {
    NSUInteger anotherClassIndex = NSNotFound;
    NSUInteger classIndex = NSNotFound;

    for(NSUInteger i = 0; i < _runList.count; i++) {
        Class theClass = [self classFromObject:[_runList objectAtIndex:i]];
        if(theClass == aClass) {
            classIndex = i;
            if(anotherClassIndex != NSNotFound) {
                break;
            }
        }
        else if(theClass == anotherClass) {
            anotherClassIndex = i;
            if(classIndex != NSNotFound) {
                break;
            }
        }
    }

    if( anotherClassIndex == NSNotFound || classIndex == NSNotFound) {
        return;
    }

    if(before) {
        if(classIndex > anotherClassIndex) {
            id theObject = FLRetainWithAutorelease([_runList objectAtIndex:classIndex]);
            [_runList removeObjectAtIndex:classIndex];
            // since classIndex is greater than anotherClassIndex, anotherClassIndex is still
            // valid after removing the object, so we can safely insert the object at that index
            // which pushes the object at anotherClassIndex down.
            [_runList insertObject:theObject atIndex:anotherClassIndex];
        }
    }
    else {
        if(classIndex < anotherClassIndex) {
            id theObject = FLRetainWithAutorelease([_runList objectAtIndex:classIndex]);
            [_runList removeObjectAtIndex:classIndex];
            // after removing the object, anotherClassIndex is off by one. So we'll decrement it
            // when inserting. And since anotherClassIndex was greater than classIndex, we know that
            // anotherClassIndex was always greater than zero, so we're safe decrementing it by one
            // here during insersion.
            [_runList insertObject:theObject atIndex:anotherClassIndex];
        }
    }
}

- (void) orderClass:(Class) aClass afterClass:(Class) anotherClass {
   [self orderClass:aClass anotherClass:anotherClass before:NO];
}

- (void) orderClass:(Class) aClass beforeClass:(Class) anotherClass {
   [self orderClass:aClass anotherClass:anotherClass before:YES];
}

- (void)sortUsingComparator:(NSComparator)cmptr {
    [_runList sortedArrayUsingComparator:cmptr];
}

- (void) orderClassEarly:(Class) aClass {
}

- (void) orderClassLate:(Class) aClass {
}

- (void) organize {

    NSMutableArray* tempList = FLMutableCopyWithAutorelease(_runList);

    for(id obj in tempList) {
        [[self classFromObject:obj] specifyRunOrder:self];
    }
}

- (void) addObject:(id) object {
    [_runList addObject:object];
}

- (NSUInteger) count {
    return _runList.count;
}

@end
