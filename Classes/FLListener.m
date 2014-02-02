//
//  FLListener.m
//  Pods
//
//  Created by Mike Fullerton on 1/12/14.
//
//

#import "FLListener.h"


@implementation FLListener

@synthesize listener = _listener;

- (id) initWithListener:(id) listener
               schedule:(FLEventThread) schedule {

	self = [super init];
	if(self) {
        _listener = listener;

        _dispatcher = (schedule == FLScheduleMessagesInMainThreadOnly) ?
            FLMainThreadSelectorPerformer :
            FLSelectorPerformer;
	}
	return self;
}

+ (id) listener:(id) listener schedule:(FLEventThread) schedule {
    return FLAutorelease([[[self class] alloc] initWithListener:listener schedule:schedule]);
}

- (void) receiveMessage:(SEL) messageSelector {
    _dispatcher.performSelector0(_listener, messageSelector);
}

- (void) receiveMessage:(SEL) messageSelector
          withObject:(id) object {

    _dispatcher.performSelector1(_listener, messageSelector, object);
}

- (void) receiveMessage:(SEL) messageSelector
          withObject:(id) object1
          withObject:(id) object2 {

    _dispatcher.performSelector2(_listener, messageSelector, object1, object2);
}

- (void) receiveMessage:(SEL) messageSelector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3 {

    _dispatcher.performSelector3(_listener, messageSelector, object1, object2, object3);
}

- (void) receiveMessage:(SEL) messageSelector
          withObject:(id) object1
          withObject:(id) object2
          withObject:(id) object3
          withObject:(id) object4 {

    _dispatcher.performSelector4(_listener, messageSelector, object1, object2, object3, object4);

}

- (BOOL) isEqual:(id)object {
    return self == object || _listener == object || [_listener isEqual:object];
}

- (NSUInteger)hash {
    return [_listener hash];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@: %@", [super description], NSStringFromClass([_listener class])];
}



@end