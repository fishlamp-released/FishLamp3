//
//  FLNonretainedArray.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLNonretainedArray.h"
#if EXPERIMENTAL
#if MRC

const void* RetainCallback(CFAllocatorRef allocator, const void *value) {
    return value;
}
void ReleaseCallback(CFAllocatorRef allocator, const void *value) {
}
CFStringRef DescriptionCallback(const void *value) {
    NSString* outString = value != nil ? [FLBridge(id, value) description] : @"(null)";
    return FLBridge(CFStringRef, outString);
}

Boolean EqualCallback(const void *value1, const void *value2) {

    if(value1 == value2) {
        return YES;
    }

    if(value1 && value2) {
        id lhs = FLBridge(id, value1);
        id rhs = FLBridge(id, value2);

        return [lhs isEqual:rhs];
    }

    return NO;
}

static CFArrayCallBacks s_callbacks = {
    0,
    RetainCallback,
    ReleaseCallback,
    DescriptionCallback,
    EqualCallback
    };

@interface FLNonretainedArray ()
@property (readonly, assign, nonatomic) CFArrayRef arrayRef;
@end

@implementation FLNonretainedArray
@synthesize arrayRef = _arrayRef;

- (id) initWithArrayRef:(CFArrayRef) arrayRef {
	self = [super init];
	if(self) {
        _arrayRef = arrayRef;
	}
	return self;
}


- (id) init {	
    return [self initWithArrayRef:CFArrayCreate(nil, nil, 0, &s_callbacks)];
}


- (id)initWithObjects:(const id [])objects count:(NSUInteger)cnt {
    return [self initWithArrayRef:CFArrayCreate(nil, FLBridge(const void**, &(objects)), cnt, &s_callbacks)];
}

#define GetObjectsAndCountFromVaList(objects, count) \
    va_list va_args; \
	va_start(va_args, firstObj); \
    id arg = firstObj; \
    while(arg) { \
        ++count; \
        arg = va_arg(va_args, id); \
    } \
	va_end(va_args); \
    \
    objects = malloc(count * sizeof(id)); \
    \
    va_start(va_args, firstObj); \
    objects[0] = firstObj; \
    for(int i = 1; i < count; i++) { \
        objects[i] = va_arg(va_args, id); \
    } \
	va_end(va_args)


- (id)initWithObjects:(id)firstObj, ... {
    NSUInteger count = 0;
    id* objects = nil;

    GetObjectsAndCountFromVaList(objects, count);

    @try {
        return [self initWithObjects:objects count:count];
    }
    @finally {
        free(objects);
    }
}

- (id)initWithArray:(FLNonretainedArray *)array {
    return [self initWithArrayRef:CFArrayCreateCopy(nil, array.arrayRef)];
}

+ (id)array {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id)arrayWithObject:(id)anObject {
    return FLAutorelease([[[self class] alloc] initWithObjects:&anObject count:1]);
}

+ (id)arrayWithObjects:(const id [])objects count:(NSUInteger)cnt {
    return FLAutorelease([[[self class] alloc] initWithObjects:objects count:cnt]);
}

+ (id)arrayWithObjects:(id)firstObj, ... {
    NSUInteger count = 0;
    id* objects = nil;

    GetObjectsAndCountFromVaList(objects, count);

    @try {
        return FLAutorelease([[[self class] alloc] initWithObjects:objects count:count]);
    }
    @finally {
        free(objects);
    }
}

+ (id)arrayWithArray:(NSArray *)array {
    return FLAutorelease([[[self class] alloc] initWithArray:array]);
}

- (void)dealloc {
    CFRelease(_arrayRef);

#if FL_MRC
	[super dealloc];
#endif
}

- (NSUInteger) count {
    return (NSUInteger) CFArrayGetCount(_arrayRef);
}

- (id) objectAtIndex:(NSUInteger) idx {
    return FLBridge(id, CFArrayGetValueAtIndex(_arrayRef, idx));
}

- (id) copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithArrayRef:CFArrayCreateCopy(nil, _arrayRef)];
}

- (id) mutableCopyWithZone:(NSZone *)zone {
    return [[FLMutableNonretainedArray alloc] initWithArrayRef:CFArrayCreateMutableCopy(nil, self.count * 2, _arrayRef)];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer
                                    count:(NSUInteger)len {


	CFRange range = CFRangeMake(state->state, len);
    CFIndex arrayLen = CFArrayGetCount(_arrayRef);
	if(range.length + range.location >= arrayLen) {
		range.length -= ((range.length + range.location) - arrayLen);
	}

    CFArrayGetValues(_arrayRef, range, FLBridge(const void**, &(state->itemsPtr)));
	state->state = state->state + range.length;
	state->mutationsPtr = &_mutationCount;
	return range.length;
}

- (void) setMutated {
    ++_mutationCount;
}

- (NSUInteger)indexOfObject:(id)anObject {
    return CFArrayGetFirstIndexOfValue(_arrayRef, CFRangeMake(0, self.count), FLBridge(void*, anObject));
}

- (BOOL)containsObject:(id)anObject {
    return CFArrayContainsValue(_arrayRef, CFRangeMake(0, self.count), FLBridge(void*, anObject));
}


@end

#define MutableRef() ((CFMutableArrayRef) self.arrayRef)

@implementation FLMutableNonretainedArray

- (id) initWithCapacity:(NSUInteger) capacity {
	return [super initWithArrayRef:CFArrayCreateMutable(nil, capacity, &s_callbacks)];
}

- (id) init {
    return [self initWithCapacity:0];
}

- (void) setObject:(id) object atIndex:(NSUInteger) idx {
    CFArraySetValueAtIndex(MutableRef(), idx, FLBridge(void*, object));
    [self setMutated];
}

- (void) addObject:(id) object {
    CFArrayAppendValue(MutableRef(), FLBridge(void*, object));
    [self setMutated];
}

- (void) insertObject:(id) object atIndex:(NSUInteger) idx {
    CFArrayInsertValueAtIndex(MutableRef(), idx, FLBridge(void*, object));
    [self setMutated];
}

- (void)removeLastObject {
    [self removeObjectAtIndex:self.count - 1];
    [self setMutated];
}

- (void)removeObjectAtIndex:(NSUInteger) idx {
    CFArrayRemoveValueAtIndex(MutableRef(), idx);
    [self setMutated];
}

- (void)replaceObjectAtIndex:(NSUInteger)idx withObject:(id)anObject {
    CFArraySetValueAtIndex(MutableRef(), idx, FLBridge(void*, anObject));
    [self setMutated];
}

- (void) removeAllObjects {
    CFArrayRemoveAllValues(MutableRef());
    [self setMutated];
}

- (id) copyWithZone:(NSZone *)zone {
    return [super mutableCopyWithZone:zone];
}

- (void) removeObject:(id) object {

    CFIndex idx = CFArrayGetFirstIndexOfValue(MutableRef(), CFRangeMake(0, self.count), FLBridge(void*, object));
    while(idx != NSNotFound) {
        CFArrayRemoveValueAtIndex(MutableRef(), idx);
        [self setMutated];
        idx = CFArrayGetFirstIndexOfValue(MutableRef(), CFRangeMake(0, self.count), FLBridge(void*, object));
    }
}


@end

#endif
#endif
