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

#import "FishLampSimpleLogger.h"
#import "FLTrace.h"

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

- (id) initWithRepresentedObject:(id) object {
    _representedObject = object;
    return self;
}

- (id) representedObject {
    return _representedObject;
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

- (id) addBackgroundListener:(id)listener {
    FLCriticalSection(&_semaphore, ^{
        if(!_listeners) {
            _listeners = [[NSMutableSet alloc] init];
        }

        [_listeners addObject:[listener objectAsListener]];

        self.dirty = YES;
    });

    return self;
}

- (id) addForegroundListener:(id) listener  {
    FLCriticalSection(&_semaphore, ^{
        if(!_listeners) {
            _listeners = [[NSMutableSet alloc] init];
        }

        [_listeners addObject:[FLMainThreadObject mainThreadObject:[listener objectAsListener]]];

        self.dirty = YES;
    });

    return self;
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

#define TRACEMSG(OBJ,SELECTOR) \
do { \
    id __LISTENER = [OBJ representedObject]; \
    if([__LISTENER respondsToSelector:SELECTOR]) { \
        FLTrace(@"%@: %@ receieved %@ FROM %@", \
            [NSThread isMainThread] ? @"F" : @"B", \
            NSStringFromClass([__LISTENER class]), \
            NSStringFromSelector(SELECTOR), \
            NSStringFromClass([[self representedObject] class])); \
    } \
    else { \
        FLTrace(@"%@: %@ IGNORED %@ FROM %@", \
            [NSThread isMainThread] ? @"F" : @"B", \
            NSStringFromClass([__LISTENER class]), \
            NSStringFromSelector(SELECTOR), \
            NSStringFromClass([[self representedObject] class])); \
    } \
} \
while(0)


- (void) sendMessageToListeners:(SEL) selector {
    for(id listener in [self iteratable]) {
        @try {
            TRACEMSG(listener, selector);

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
            TRACEMSG(listener, selector);

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
            TRACEMSG(listener, selector);

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
            TRACEMSG(listener, selector);

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
            TRACEMSG(listener, selector);

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
		_broadcaster = [[FLBroadcasterProxy alloc] initWithRepresentedObject:self];
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

- (id) addBackgroundListener:(id)listener {
    [self.broadcaster addBackgroundListener:listener];
    return self;
}

- (id) addForegroundListener:(id)listener {
    [self.broadcaster addForegroundListener:listener];
    return self;
}

- (void) removeListener:(id) listener {
    [self.broadcaster removeListener:listener];
}

#define SENDMSG(SELECTOR) \
        FLTrace(    @"%@ SENDING %@", \
                    NSStringFromClass([self class]), \
                    NSStringFromSelector(SELECTOR) \
                    )


- (void) sendMessageToListeners:(SEL) selector {
    SENDMSG(selector);
    [self.broadcaster sendMessageToListeners:selector];
}

- (void) sendMessageToListeners:(SEL) selector  
                     withObject:(id) object {
    SENDMSG(selector);
   [self.broadcaster sendMessageToListeners:selector withObject:object];
}

- (void) sendMessageToListeners:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2 {
    SENDMSG(selector);

    [self.broadcaster sendMessageToListeners:selector withObject:object1 withObject:object2];
}

- (void) sendMessageToListeners:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3 {
    SENDMSG(selector);
    [self.broadcaster sendMessageToListeners:selector withObject:object1 withObject:object2 withObject:object3];
}

- (void) sendMessageToListeners:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3
                     withObject:(id) object4 {
    SENDMSG(selector);
    [self.broadcaster sendMessageToListeners:selector withObject:object1 withObject:object2 withObject:object3 withObject:object4];
}

@end
