//
//  FLBroadcasterProxy.m
//  Pods
//
//  Created by Mike Fullerton on 1/5/14.
//
//

#import "FLBroadcasterProxy.h"

@interface FLBroadcasterProxy ()
@property (readwrite, strong, nonatomic) FLBroadcaster* broadcaster;
@end

@implementation FLBroadcasterProxy

@synthesize broadcaster = _broadcaster;

- (id) init {
	return [self initWithBroadcaster:nil];
}

- (id) initWithBroadcaster:(FLBroadcaster*) broadcaster {
    FLAssertNotNil(broadcaster);
    _broadcaster = FLRetain(broadcaster);
    return self;
}

- (id) representedObject {
    return _broadcaster;
}

#if FL_MRC
- (void)dealloc {
	[_broadcaster release];
	[super dealloc];
}
#endif

- (void)forwardInvocation:(NSInvocation *)anInvocation {

    BOOL listenerHandled = NO;

    for(id listener in [_broadcaster.events listeners]) {
        if([listener respondsToSelector:[anInvocation selector]]) {
            [anInvocation invokeWithTarget:listener];
            listenerHandled = YES;
        }
    }
    if(!listenerHandled) {
        [super forwardInvocation:anInvocation];
    }
}

- (BOOL) respondsToSelector:(SEL) selector {

    for(id listener in [_broadcaster.events listeners]) {
        if([listener respondsToSelector:selector]) {
            return YES;
        }
    }

    return NO;
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {

    NSMethodSignature* signature = nil;
    for(id listener in [_broadcaster.events listeners]) {
        signature = [listener methodSignatureForSelector:selector];
        if(signature) {
            return signature;
        }
    }

    if(!signature) {
    // saw this on the internet, so it must be true.
        signature = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }

    return signature;
}

- (void) sendEvent:(SEL) selector {
    [self.broadcaster sendEvent:selector];
}

- (void) sendEvent:(SEL) selector  
                     withObject:(id) object {

   [self.broadcaster sendEvent:selector withObject:object];
}

- (void) sendEvent:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2 {

    [self.broadcaster sendEvent:selector withObject:object1 withObject:object2];
}

- (void) sendEvent:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3 {
    [self.broadcaster sendEvent:selector withObject:object1 withObject:object2 withObject:object3];
}

- (void) sendEvent:(SEL) selector 
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3
                     withObject:(id) object4 {

    [self.broadcaster.events sendEvent:selector withObject:object1 withObject:object2 withObject:object3 withObject:object4];
}

- (void) removeListener:(id) listener {
    [self.broadcaster.events removeListener:listener];
}

@end
