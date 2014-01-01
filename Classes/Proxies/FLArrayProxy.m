//
//  FLArrayProxy.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/13/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLArrayProxy.h"
#import "FishLampAssertions.h"

@implementation FLAbstractArrayProxy

- (id) init {
    return self;
}

- (NSArray*) array {
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSArray* array = [self array];
    for(NSInteger i = array.count - 1; i >= 0; i--) {
        id listener = [array objectAtIndex:i];
        if([listener respondsToSelector:[anInvocation selector]]) {
            [anInvocation invokeWithTarget:listener];
        }
    }
}

- (BOOL) respondsToSelector:(SEL) selector {

    for(id listener in [self array]) {
        if([listener respondsToSelector:selector]) {
            return YES;
        }
    }

    return [super respondsToSelector:selector];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {

    NSMethodSignature* signature = nil;
    for(id obj in [self array]) {
        signature = [obj methodSignatureForSelector:selector];
        if(signature) {
            return signature;
        }
    }

    if(!signature) {
        signature = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }

    return signature;
}

@end

@implementation FLArrayProxy

- (NSArray*) array {
    return _array;
}

- (id) initWithArray:(NSArray*) array {
    FLAssertNotNil(array);
    _array = FLRetain(array);
    return self;
}

+ (id) arrayProxy:(NSArray*) array {
    return FLAutorelease([[[self class] alloc] initWithArray:array]);
}

#if FL_MRC
- (void)dealloc {
	[_array release];
	[super dealloc];
}
#endif

@end
