//
//  FLBroadcaster.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/24/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBroadcaster.h"

@interface FLBroadcaster ()
@property (readwrite, strong) FLEventBroadcaster* eventBroadcaster;
@end

@implementation FLBroadcaster

@synthesize eventBroadcaster = _eventBroadcaster;

#if FL_MRC
- (void)dealloc {
	[_eventBroadcaster release];
	[super dealloc];
}
#endif

- (void) sendEvent:(SEL) messageSelector {
    FLEventBroadcaster* broadcaster = self.eventBroadcaster;
    if(broadcaster) {
        [broadcaster sendEvent:messageSelector];
    }
}

- (void) sendEvent:(SEL) messageSelector
              withObject:(id) object {

    FLEventBroadcaster* broadcaster = self.eventBroadcaster;
    if(broadcaster) {
        [broadcaster sendEvent:messageSelector withObject:object];
    }
}

- (void) sendEvent:(SEL) messageSelector
              withObject:(id) object1
              withObject:(id) object2 {

    FLEventBroadcaster* broadcaster = self.eventBroadcaster;
    if(broadcaster) {
        [broadcaster sendEvent:messageSelector withObject:object1 withObject:object2];
    }
}

- (void) sendEvent:(SEL) messageSelector
              withObject:(id) object1
              withObject:(id) object2
              withObject:(id) object3 {

    FLEventBroadcaster* broadcaster = self.eventBroadcaster;
    if(broadcaster) {
        [broadcaster sendEvent:messageSelector withObject:object1 withObject:object2 withObject:object3];
    }
}


- (void) sendEvent:(SEL) messageSelector
              withObject:(id) object1
              withObject:(id) object2
              withObject:(id) object3
              withObject:(id) object4 {

    FLEventBroadcaster* broadcaster = self.eventBroadcaster;
    if(broadcaster) {
        [broadcaster sendEvent:messageSelector withObject:object1 withObject:object2 withObject:object3 withObject:object4];
    }
}

- (FLEventBroadcaster*) events {

    FLEventBroadcaster* broadcaster = self.eventBroadcaster;
    if(!broadcaster) {
        @synchronized(self) {
            broadcaster = self.eventBroadcaster;
            if(!broadcaster) {
                broadcaster = [[FLEventBroadcaster alloc] init];;
                self.eventBroadcaster = broadcaster;
            }
        }
    }

    return broadcaster;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@:\n %@", [super description], [self.eventBroadcaster description]];
}

- (BOOL) hasListener:(id) listener {
    FLEventBroadcaster* broadcaster = self.eventBroadcaster;
    return broadcaster ? [broadcaster hasListener:listener] : NO;
}

- (void) addListener:(id) listener {
    [self.events addListener:listener];
}

- (void) addListener:(id) listener withScheduling:(FLEventThread) schedule {
    [self.events addListener:listener withScheduling:schedule];
}

- (void) removeListener:(id) listener {
    FLEventBroadcaster* broadcaster = self.eventBroadcaster;
    if(broadcaster) {
        [broadcaster removeListener:listener];
    }
}


@end
