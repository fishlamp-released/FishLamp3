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

#import "FLObjectProxy.h"

@protocol FLListener <NSObject>
- (id) objectAsListener;
@end


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

@interface FLListenerRegistry ()
@end

@implementation FLListenerRegistry

#define SENDMSG(SELECTOR) \
        FLTrace(    @"%@ SENDING %@", \
                    NSStringFromClass([self class]), \
                    NSStringFromSelector(SELECTOR) \
                    )

- (id) init {	
	self = [super init];
	if(self) {
        _listeners = [[NSMutableSet alloc] init];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
    [_iteratableListeners release];
    [_listeners release];
	[super dealloc];
}
#endif

- (NSArray*) listeners {

    if(!_iteratableListeners) {
        @synchronized(self) {
            if(!_iteratableListeners) {
                _iteratableListeners = [[_listeners allObjects] copy];
            }
        };
    }

    return _iteratableListeners;
}

- (BOOL) hasListener:(id) listener {
    @synchronized(self) {
        return [_listeners containsObject:listener];
    }
}

//- (id) addBackgroundListener:(id)listener {
//    @synchronized(self) {
//        [_listeners addObject:[listener objectAsListener]];
//        FLReleaseWithNil(_iteratableListeners);
//    }
//
//    return self;
//}
//
//- (id) addForegroundListener:(id) listener  {
//    @synchronized(self) {
//        [_listeners addObject:[FLMainThreadObject mainThreadObject:[listener objectAsListener]]];
//        FLReleaseWithNil(_iteratableListeners);
//    }
//
//    return self;
//}

- (id) addListener:(id) listener withScheduling:(FLScheduleMessages) schedule {
    @synchronized(self) {

        if( schedule == FLScheduleMessagesInMainThreadOnly ) {
            [_listeners addObject:[FLMainThreadObject mainThreadObject:[listener objectAsListener]]];
        }
        else {
            [_listeners addObject:[listener objectAsListener]];
        }

        FLReleaseWithNil(_iteratableListeners);
    }

    return self;
}

- (id) addListener:(id) listener {
    return [self addListener:listener
       withScheduling:[NSThread isMainThread] ? FLScheduleMessagesInMainThreadOnly : FLScheduleMessagesInAnyThread];
}


- (void) removeListener:(id) listener {
    @synchronized(self) {

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

        FLReleaseWithNil(_iteratableListeners);
    }
}

@end

@implementation FLMessageSender

#define TRACEMSG(OBJ,SELECTOR) \
do { \
    id __LISTENER = [OBJ representedObject]; \
    if([__LISTENER respondsToSelector:SELECTOR]) { \
        FLTrace(@"%@: %@ receieved %@ FROM %@", \
            [NSThread isMainThread] ? @"F" : @"B", \
            NSStringFromClass([__LISTENER class]), \
            NSStringFromSelector(SELECTOR), \
            NSStringFromClass([self class])); \
    } \
    } while(0)

//    else { \
//        FLTrace(@"%@: %@ IGNORED %@ FROM %@", \
//            [NSThread isMainThread] ? @"F" : @"B", \
//            NSStringFromClass([__LISTENER class]), \
//            NSStringFromSelector(SELECTOR), \
//            NSStringFromClass([self class])); \
//    } \
} \
while(0)

- (void) sendMessage:(SEL) selector
         toListeners:(NSArray*) listeners {

    if(listeners) {
        for(id listener in listeners) {
            @try {
                TRACEMSG(listener, selector);

                [listener performOptionalSelector_fl:selector];
            }
            @catch(NSException* ex) {
            }
        }
    }
}

- (void) sendMessage:(SEL) selector
          withObject:(id) object
         toListeners:(NSArray*) listeners {

    if(listeners) {
        for(id listener in listeners) {
            @try {
                TRACEMSG(listener, selector);

                [listener performOptionalSelector_fl:selector
                                          withObject:object];
            }
            @catch(NSException* ex) {
            }
        }
    }
}

- (void) sendMessage:(SEL) selector
          withObject:(id) object1
          withObject:(id) object2
         toListeners:(NSArray*) listeners {

    if(listeners) {
        for(id listener in listeners) {

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
}

- (void) sendMessage:(SEL) selector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3
         toListeners:(NSArray*) listeners {

    if(listeners) {
        for(id listener in listeners) {
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
}

- (void) sendMessage:(SEL) selector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3
          withObject:(id) object4
         toListeners:(NSArray*) listeners {

    if(listeners) {
        for(id listener in listeners) {
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
}

@end

@implementation FLBroadcaster

@synthesize listeners = _listeners;

#if FL_MRC
- (void)dealloc {
	[_listeners release];
	[super dealloc];
}
#endif

- (void) sendMessageToListeners:(SEL) messageSelector {
   [self sendMessage:messageSelector toListeners:self.listeners.listeners];
}

- (void) sendMessageToListeners:(SEL) messageSelector
              withObject:(id) object {

    [self sendMessage:messageSelector withObject:object toListeners:self.listeners.listeners];
}

- (void) sendMessageToListeners:(SEL) messageSelector
              withObject:(id) object1
              withObject:(id) object2 {

    [self sendMessage:messageSelector withObject:object1 withObject:object2 toListeners:self.listeners.listeners];
}

- (void) sendMessageToListeners:(SEL) messageSelector
              withObject:(id) object1
              withObject:(id) object2
              withObject:(id) object3 {

    [self sendMessage:messageSelector withObject:object1 withObject:object2 withObject:object3 toListeners:self.listeners.listeners];
}


- (void) sendMessageToListeners:(SEL) messageSelector
              withObject:(id) object1
              withObject:(id) object2
              withObject:(id) object3
              withObject:(id) object4 {

    [self sendMessage:messageSelector withObject:object1 withObject:object2 withObject:object3 withObject:object4 toListeners:self.listeners.listeners];
}

- (BOOL) hasListener:(id) listener {
    return self.listeners && [self.listeners hasListener:listener];
}

- (FLListenerRegistry*) lazyListeners {
    if(!_listeners) {
        @synchronized(self) {
            if(!_listeners) {
                _listeners = [[FLListenerRegistry alloc] init];
            }
        }
    }
    return _listeners;
}

- (id) addListener:(id) listener withScheduling:(FLScheduleMessages) schedule {
    [[self lazyListeners] addListener:listener withScheduling:schedule];
    return self;
}

- (void) removeListener:(id) listener {
    [self.listeners removeListener:listener];
}

- (id) addListener:(id) listener {
    [[self lazyListeners] addListener:listener];
    return self;
}

@end
