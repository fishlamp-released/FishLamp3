//
//  FLListenerRegistry.m
//  Pods
//
//  Created by Mike Fullerton on 1/12/14.
//
//

#import "FLListenerRegistry.h"

@interface FLListenerRegistry ()
@end

@implementation FLListenerRegistry

- (id) init {	
	self = [super init];
	if(self) {
        _listeners = [[NSMutableSet alloc] init];
	}
	return self;
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

    return _iteratableListeners;
}

- (BOOL) hasListener:(id) listener {
    @synchronized(self) {
        return [_listeners containsObject:listener];
    }
}

- (void) addListener:(id) aObject withScheduling:(FLScheduleMessages) schedule {

    FLListener* listener = [FLListener listener:aObject schedule:schedule];
    @synchronized(self) {
        [_listeners addObject:listener];
        FLReleaseWithNil(_iteratableListeners);
    }
}

- (void) addListener:(id) listener {
    [self addListener:listener
              withScheduling:[NSThread isMainThread] ?
                FLScheduleMessagesInMainThreadOnly :
                FLScheduleMessagesInAnyThread];
}


- (void) removeListener:(id) listener {
    @synchronized(self) {
        if(listener) {
            [_listeners removeObject:listener];
        }
        FLReleaseWithNil(_iteratableListeners);
    }
}

@end