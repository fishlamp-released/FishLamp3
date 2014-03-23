//
//  FLAbstractObjectProxy.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAbstractObjectProxy.h"
//#import "FLLog.h"
//#import "FLTrace.h"
#import "FishLampAssertions.h"

@implementation NSObject (FLAbstractObjectProxy)

- (id) nextContainedObject {
    return nil;
}

- (id) containedObject {
    return self;
}

@end

@implementation FLAbstractObjectProxy

- (id) nextContainedObject {
    return self.containedObject;
}

- (id) containedObject {
    return nil;
}

- (id) representedObject {
    id walker = [self nextContainedObject];
    while(walker) {
        id next = [walker nextContainedObject];
        if(next) {
            walker = next;
        }
        else {
            break;
        }
    }
    return walker;
}

- (NSString*) description {

    id object = [self representedObject];

	return [NSString stringWithFormat:@"%@ holding a %@:\n%@",
        NSStringFromClass([self class]),
        NSStringFromClass([object class]),
        [object description]];
}

- (BOOL)isEqual:(id)representedObject {
	return [[self representedObject] isEqual:representedObject];
}

- (NSUInteger)hash {
	return [[self representedObject] hash];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    id object = [self representedObject];
    if([object respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:object];
    }
    else {
//        FLTrace(@"not responding to %@", NSStringFromSelector([anInvocation selector]));
    }
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {

    NSMethodSignature* sig = [[self representedObject] methodSignatureForSelector:selector];
    if(!sig) {
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
//        FLTrace(@"returning fake method signature for selector %@", NSStringFromSelector(selector));
    }
    return sig;
}

- (BOOL) respondsToSelector:(SEL)aSelector {
    return [[self representedObject] respondsToSelector:aSelector];
}

- (BOOL) willRetainInBroadcaster {
    return YES;
}


@end
