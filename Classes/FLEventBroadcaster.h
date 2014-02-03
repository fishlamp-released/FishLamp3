//
//  FLEventBroadcaster.h
//  Pods
//
//  Created by Mike Fullerton on 2/1/14.
//
//

#import "FishLampCore.h"

extern const FLDispatcher_t FLDispatchOnMainThread;
extern const FLDispatcher_t FLDispatchOnCurrentThread;

@protocol FLEventBroadcaster <NSObject>

- (void) sendEvent:(SEL) messageSelector;

- (void) sendEvent:(SEL) messageSelector
          withObject:(id) object;

- (void) sendEvent:(SEL) messageSelector
          withObject:(id) object1
          withObject:(id) object2;

- (void) sendEvent:(SEL) messageSelector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3;

- (void) sendEvent:(SEL) messageSelector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3
          withObject:(id) object4;

- (BOOL) hasListener:(id) listener;

- (void) addListener:(id) listener sendEventsOnMainThread:(BOOL) mainThread;

- (void) removeListener:(id) listener;

@end

@interface FLEventBroadcaster : NSObject<FLEventBroadcaster> {
@private
    NSMutableSet* _listeners;
    NSArray* _iteratableListeners;
}

+ (id) eventBroadcaster;

@property (readwrite, assign) BOOL logEvents;

@property (readonly, strong) NSArray* listeners;

@end

