//
//  FLBroadcaster.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/24/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBroadcaster.h"

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
