//
//  FLBroadcaster.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/24/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

#import "FLMessageSender.h"
#import "FLListenerRegistry.h"

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

@interface FLBroadcaster : FLMessageSender <FLBroadcaster, FLListenerRegistry> {
@private
    FLListenerRegistry* _listeners;
}

@property (readonly, strong) FLListenerRegistry* listeners;

@end