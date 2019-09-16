//
//  FLListener.h
//  Pods
//
//  Created by Mike Fullerton on 1/12/14.
//
//

#import "FishLampCore.h"

@interface FLListener : NSObject {
@private
    __weak id _listener;
    FLDispatcher_t _dispatcher;
    NSUInteger _hash;
}

@property (readonly, nonatomic, weak) id listener;

+ (id) listener:(id) listener dispatcher:(FLDispatcher_t) dispatcher;

- (void) receiveMessage:(SEL) messageSelector;

- (void) receiveMessage:(SEL) messageSelector
             withObject:(id) object;

- (void) receiveMessage:(SEL) messageSelector
          withObject:(id) object1
          withObject:(id) object2;

- (void) receiveMessage:(SEL) messageSelector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3;

- (void) receiveMessage:(SEL) messageSelector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3
          withObject:(id) object4;


@end
