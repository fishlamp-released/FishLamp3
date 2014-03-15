//
//  FLEventBroadcaster.m
//
//  Created by Mike Fullerton on 2/1/11.
//
//

#import "FLEventBroadcaster.h"

#import "FishLampSimpleLogger.h"
#import "FLListener.h"

#if DEBUG
#define LOG_EVENTS_DEFAULT NO
#else
#define LOG_EVENTS_DEFAULT NO
#endif

#define TRACEMSG(OBJ,SELECTOR) \
            do { \
                if(self.logEvents) { \
                    id __LISTENER = [OBJ listener]; \
                    if([__LISTENER respondsToSelector:SELECTOR]) { \
                        FLLog(@"%@: -[%@ %@]", \
                            [NSThread isMainThread] ? @"F" : @"B", \
                            NSStringFromClass([__LISTENER class]), \
                            NSStringFromSelector(SELECTOR) \
                            ); \
                    } \
                } \
            } while(0)

//    else { \
//        FLTrace(@"%@: %@ IGNORED %@ FROM %@", \
//            [NSThread isMainThread] ? @"F" : @"B", \
//            NSStringFromClass([__LISTENER class]), \
//            NSStringFromSelector(SELECTOR), \
//            NSStringFromClass([self class])); \
//    } \
//} \
//while(0)


@implementation FLEventBroadcaster

@synthesize logEvents = _logEvents;


- (id) init {
	self = [super init];
	if(self) {
        _listeners = [[NSMutableSet alloc] init];
		self.logEvents = LOG_EVENTS_DEFAULT;
	}
	return self;
}

+ (id) eventBroadcaster {
    return FLAutorelease([[[self class] alloc] init]);
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

    return FLRetainWithAutorelease(_iteratableListeners);
}

- (BOOL) hasListener:(id) listener {
    @synchronized(self) {
        return [_listeners containsObject:listener];
    }
}

- (void) addListener:(id) aObject onQueue:(FLDispatcher_t) eventQueue {

    FLListener* listener = [FLListener listener:aObject dispatcher:eventQueue];
    @synchronized(self) {
        [_listeners addObject:listener];
        FLReleaseWithNil(_iteratableListeners);
    }
}

- (void) addListener:(id) listener sendEventsOnMainThread:(BOOL) mainThread {
    [self addListener:listener onQueue:mainThread ? FLDispatchOnMainThread : FLDispatchOnCurrentThread];
}

//- (void) addListener:(id) listener {
//
//    [self addListener:listener
//              onQueue:];
//
////    [self addListener:listener
////              onQueue:[NSThread isMainThread] ?
////                FLScheduleMessagesInMainThreadOnly :
////                FLRecieveEventInCurrentThread];
//}


- (void) removeListener:(id) listener {
    @synchronized(self) {
        if(listener) {
            [_listeners removeObject:listener];
        }
        FLReleaseWithNil(_iteratableListeners);
    }
}

- (NSString*) description {

    NSMutableString* string = [NSMutableString stringWithFormat:@"%@: Listeners:\n", [super description]];

    for(FLListener* listener in self.listeners) {
        [string appendFormat:@" %@\n", [listener description]];
    }

    return string;
}


- (void) sendEvent:(SEL) selector {

    NSArray* listeners = self.listeners;
    if(listeners) {
        for(FLListener* listener in listeners) {
            @try {
                TRACEMSG(listener, selector);

                [listener receiveMessage:selector];
            }
            @catch(NSException* ex) {
            }
        }
    }
}

- (void) sendEvent:(SEL) selector
          withObject:(id) object {

    NSArray* listeners = self.listeners;
    if(listeners) {
        for(FLListener* listener in listeners) {
            @try {
                TRACEMSG(listener, selector);

                [listener receiveMessage:selector
                              withObject:object];
            }
            @catch(NSException* ex) {
            }
        }
    }
}

- (void) sendEvent:(SEL) selector
          withObject:(id) object1
          withObject:(id) object2  {

    NSArray* listeners = self.listeners;
    if(listeners) {
        for(FLListener* listener in listeners) {

            @try {
                TRACEMSG(listener, selector);

                [listener receiveMessage:selector
                              withObject:object1
                              withObject:object2];
            }
            @catch(NSException* ex) {
            }
        }
    }
}

- (void) sendEvent:(SEL) selector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3 {

    NSArray* listeners = self.listeners;
    if(listeners) {
        for(FLListener* listener in listeners) {
            @try {
                TRACEMSG(listener, selector);

                [listener receiveMessage:selector
                              withObject:object1
                              withObject:object2
                              withObject:object3];
            }
            @catch(NSException* ex) {
            }
        }
    }
}

- (void) sendEvent:(SEL) selector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3
          withObject:(id) object4  {

    NSArray* listeners = self.listeners;
    if(listeners) {
        for(FLListener* listener in listeners) {
            @try {
                TRACEMSG(listener, selector);

                [listener receiveMessage:selector
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

