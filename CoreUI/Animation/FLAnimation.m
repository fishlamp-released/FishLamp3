//
//  FLAnimation.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAnimation.h"
#import "FLFinisher.h"

@implementation CALayer (FLAnimation)
- (CALayer*) layer {
    return self;
}
@end

@interface FLAnimation ()
@end

@implementation FLAnimation

- (void) prepareAnimation:(CALayer*) layer {
}

- (void) commitAnimation:(CALayer*) layer {
}

- (void) finishAnimation:(CALayer*) layer {
}

- (id) init {	
	return [self initWithAnimationDirection:FLAnimationDirectionForward];
}

- (id) initWithAnimationDirection:(FLAnimationDirection) direction {
    self = [super init];
    if(self) {
        self.direction = direction;
    }
    return self;
}

- (void) startAnimating:(id) target
             completion:(fl_block_t) completion {
    
    FLAssert([NSThread isMainThread], @"not on main thread");

    CALayer* layer = [target layer];
    FLAssertNotNil(layer, @"layer is nil");
    
    [self startAnimationWithPrepareBlock:^{ [self prepareAnimation:layer]; }
                           commitBlock:^{ [self commitAnimation:layer]; }
                           finishBlock:^{ [self finishAnimation:layer]; }
                       completionBlock:completion];
}

- (void) didMoveToParentAnimation:(FLAnimation*) parent {
    if(parent) {
        self.duration = parent.duration;
        self.timing = parent.timing;
    }
}

- (void) setParentAnimation:(FLAbstractAnimation*) parent {
    [super setParentAnimation:parent];
    [self didMoveToParentAnimation:parent];
}


@end


