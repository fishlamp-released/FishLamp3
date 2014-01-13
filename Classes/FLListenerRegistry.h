//
//  FLListenerRegistry.h
//  Pods
//
//  Created by Mike Fullerton on 1/12/14.
//
//

#import "FishLampCore.h"
#import "FLListener.h"

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


