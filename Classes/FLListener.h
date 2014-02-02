//
//  FLListener.h
//  Pods
//
//  Created by Mike Fullerton on 1/12/14.
//
//

#import "FishLampCore.h"
#import "FLEventThread.h"

@interface FLListener : NSObject {
@private
    __unsafe_unretained id _listener;
    FLDispatcher_t _dispatcher;
}

@property (readonly, nonatomic, assign) id listener;

+ (id) listener:(id) listener schedule:(FLEventThread) schedule;

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