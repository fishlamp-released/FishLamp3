//
//  FLCallback.m
//  FishLamp
//
//  Created by Mike Fullerton on 9/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCallback_t.h"

const FLCallback_t FLCallbackZero = { nil, nil };

@implementation FLCallback

- (id) target {
    return nil;
}

- (SEL) action {
    return nil;
}

- (void) setTarget:(id) target {
}

- (void) setAction:(SEL) action {
}


- (id) initWithTarget:(id) target action:(SEL) action {
    self = [super init];
    if(self) {
    }

    return self;
}

+ (id) callbackWithTarget:(id) target action:(SEL) action {
    return FLAutorelease([[[self class] alloc] initWithTarget:target action:action]);
}

- (BOOL) perform {
    return FLPerformSelector0([self target], [self action]);
}

- (BOOL) performWithObject:(id) object {
    return FLPerformSelector1([self target], [self action], object);
}

- (BOOL) performWithObject:(id) object1 withObject:(id) object2 {
    return FLPerformSelector2([self target], [self action], object1, object2);
}

- (BOOL) performWithObject:(id) object1 withObject:(id) object2 withObject:(id) object3 {
    return FLPerformSelector3([self target], [self action], object1, object2, object3);
}

//#if FL_MRC
//- (void) dealloc {
//    [_block release];
//    [_target release];
//    [super dealloc];
//}
//#endif

@end

@implementation FLCallbackWithUnretainedTarget

@synthesize target = _target;
@synthesize action = _action;

- (id) initWithTarget:(id) target action:(SEL) action {
    self = [super init];
    if(self) {
        self.target = target;
        self.action = action;
    }

    return self;
}

@end


        