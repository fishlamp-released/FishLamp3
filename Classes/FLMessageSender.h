//
//  FLMessageSender.h
//  Pods
//
//  Created by Mike Fullerton on 1/12/14.
//
//

#import "FishLampCore.h"

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