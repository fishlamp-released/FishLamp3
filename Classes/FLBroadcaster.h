//
//  FLBroadcaster.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/24/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

@protocol FLBroadcaster <NSObject>

- (void) sendMessageToListeners:(SEL) messageSelector;

- (void) sendMessageToListeners:(SEL) messageSelector
              withObject:(id) object;

- (void) sendMessageToListeners:(SEL) messageSelector
              withObject:(id) object1
              withObject:(id) object2;

- (void) sendMessageToListeners:(SEL) messageSelector
              withObject:(id) object1
              withObject:(id) object2
              withObject:(id) object3;

- (void) sendMessageToListeners:(SEL) messageSelector
              withObject:(id) object1
              withObject:(id) object2
              withObject:(id) object3
              withObject:(id) object4;

@end

typedef NS_ENUM(NSUInteger, FLScheduleMessages) {
    FLScheduleMessagesInMainThreadOnly,
    FLScheduleMessagesInAnyThread
};

@protocol FLListenerRegistry <NSObject>

- (BOOL) hasListener:(id) listener;

- (id) addListener:(id) listener;
- (id) addListener:(id) listener withScheduling:(FLScheduleMessages) schedule;

- (void) removeListener:(id) listener;

@end


@interface FLListenerRegistry : NSObject<FLListenerRegistry> {
@private
    NSMutableSet* _listeners;
    NSArray* _iteratableListeners;
}

@property (readonly, strong) NSArray* listeners;

@end


@interface FLMessageSender : NSObject

- (void) sendMessage:(SEL) messageSelector
         toListeners:(NSArray*) listeners;

- (void) sendMessage:(SEL) messageSelector
          withObject:(id) object
         toListeners:(NSArray*) listeners;

- (void) sendMessage:(SEL) messageSelector
          withObject:(id) object1
          withObject:(id) object2
         toListeners:(NSArray*) listeners;

- (void) sendMessage:(SEL) messageSelector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3
         toListeners:(NSArray*) listeners;

- (void) sendMessage:(SEL) messageSelector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3
          withObject:(id) object4
         toListeners:(NSArray*) listeners;

@end

@interface FLBroadcaster : FLMessageSender <FLBroadcaster, FLListenerRegistry> {
@private
    FLListenerRegistry* _listeners;
}

@property (readonly, strong) FLListenerRegistry* listeners;

@end