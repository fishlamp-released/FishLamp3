//
//  FLBroadcaster.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/24/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBroadcaster.h"
#import "FLSelectorPerforming.h"
#import "FLAtomic.h"
#import "FLAsyncQueue.h"
#import "FishLampAsync.h"

@implementation NSObject (FLBroadcaster)

- (id) objectAsListener {
    return [FLNonretainedObjectProxy nonretainedObjectProxy:self];
}
@end

@implementation NSProxy (FLBroadcaster)

- (id) objectAsListener {
    return self;
}

@end

@interface FLBroadcasterProxy ()
@property (readwrite, assign) BOOL dirty;
@end

@implementation FLBroadcasterProxy

@synthesize dirty =_dirty;

- (id) init {
// NSProxy has no init. Put this here for subclasses
	return self;
}

#if FL_MRC
- (void)dealloc {
    [_iteratable release];
    [_listeners release];
	[super dealloc];
}
#endif

- (NSArray*) iteratable {

    __block NSArray* outArray = nil;
    FLCriticalSection(&_semaphore, ^{
        if(_dirty) {
            FLReleaseWithNil(_iteratable);
        }
        if(!_iteratable) {
            _iteratable = [[_listeners allObjects] copy];
        }
        self.dirty = NO;

        outArray = FLRetainWithAutorelease(_iteratable);
    });

    return outArray;
}

- (BOOL) hasListener:(id) listener {
    return [_listeners containsObject:listener];
}

- (id) broadcaster {
    return self;
}

- (void) addListener:(id) listener  {
    FLCriticalSection(&_semaphore, ^{
        if(!_listeners) {
            _listeners = [[NSMutableSet alloc] init];
        }

        [_listeners addObject:[listener objectAsListener]];

        self.dirty = YES;
    });
}

- (void) removeListener:(id) listener {
    FLCriticalSection(&_semaphore, ^{

        id theObject = nil;
        for(id object in _listeners) {
            if([object representsObject:listener]) {
                theObject = object;
            }
        }
        if(theObject) {
            [_listeners removeObject:theObject];
        }

//        for(NSInteger i = _listeners.count - 1; i >= 0; i--) {
//            id object = [_listeners objectAtIndex:i];
//            if([object representedObject] == listener) {
//                [_listeners removeObjectAtIndex:i];
//            }
//        }

        self.dirty = YES;
    });
}

- (void) sendMessageToListeners:(SEL) selector {
    for(id listener in [self iteratable]) {
        @try {
            [listener performOptionalSelector_fl:selector];
        }
        @catch(NSException* ex) {
        }
    }
}

- (void) sendMessageToListeners:(SEL) selector  
                     withObject:(id) object {

    for(id listener in [self iteratable]) {
        @try {
            [listener performOptionalSelector_fl:selector
                                      withObject:object];
        }
        @catch(NSException* ex) {
        }
    }
}

- (void) sendMessageToListeners:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2 {

    for(id listener in [self iteratable]) {
        @try {
            [listener performOptionalSelector_fl:selector
                                      withObject:object1
                                      withObject:object2];
        }
        @catch(NSException* ex) {
        }
    }
}

- (void) sendMessageToListeners:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3 {

    for(id listener in [self iteratable]) {
        @try {
            [listener performOptionalSelector_fl:selector
                                      withObject:object1
                                      withObject:object2
                                      withObject:object3];
        }
        @catch(NSException* ex) {
        }
    }
}

- (void) sendMessageToListeners:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3
                     withObject:(id) object4 {

    for(id listener in [self iteratable]) {
        @try {
            [listener performOptionalSelector_fl:selector
                                      withObject:object1
                                      withObject:object2
                                      withObject:object3
                                      withObject:object4];
        }
        @catch(NSException* ex) {
        }
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {

    BOOL listenerHandled = NO;

    for(id listener in [self iteratable]) {
        if([listener respondsToSelector:[anInvocation selector]]) {
            [anInvocation invokeWithTarget:listener];
            listenerHandled = YES;
        }
    }
    if(!listenerHandled) {
        [super forwardInvocation:anInvocation];
    }
}

- (BOOL) respondsToSelector:(SEL) selector {

    for(id listener in [self iteratable]) {
        if([listener respondsToSelector:selector]) {
            return YES;
        }
    }

    return NO;
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {

    NSMethodSignature* signature = nil;
    for(id listener in [self iteratable]) {
        signature = [listener methodSignatureForSelector:selector];
        if(signature) {
            return signature;
        }
    }

    if(!signature) {
    // saw this on the internet, so it must be true.
        signature = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }

    return signature;
}

@end

@interface FLBroadcaster ()
@property (readonly, strong) FLBroadcasterProxy* broadcaster;
@end

@implementation FLBroadcaster

@synthesize broadcaster = _broadcaster;

- (id) init {	
	self = [super init];
	if(self) {
		_broadcaster = [[FLBroadcasterProxy alloc] init];
    }
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_broadcaster release];
	[super dealloc];
}
#endif

//- (BOOL) hasListener:(id) listener {
//    __block BOOL hasListener = NO;
//
//    FLCriticalSection(&_predicate, ^{
//        hasListener = [self.broadcaster hasListener:listener];
//    });
//
//    return hasListener;
//}

- (void) addListener:(id) listener  {
    [self.broadcaster addListener:listener];
}

- (void) removeListener:(id) listener {
    [self.broadcaster removeListener:listener];
}

- (void) sendMessageToListeners:(SEL) selector {
    [self.broadcaster sendMessageToListeners:selector];
}

- (void) sendMessageToListeners:(SEL) selector  
                     withObject:(id) object {
   [self.broadcaster sendMessageToListeners:selector withObject:object];
}

- (void) sendMessageToListeners:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2 {

    [self.broadcaster sendMessageToListeners:selector withObject:object1 withObject:object2];
}

- (void) sendMessageToListeners:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3 {
    [self.broadcaster sendMessageToListeners:selector withObject:object1 withObject:object2 withObject:object3];
}

- (void) sendMessageToListeners:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3
                     withObject:(id) object4 {
    [self.broadcaster sendMessageToListeners:selector withObject:object1 withObject:object2 withObject:object3 withObject:object4];
}

@end
