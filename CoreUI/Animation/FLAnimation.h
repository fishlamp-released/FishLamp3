//
//  FLAnimation.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//


#import "FLAbstractAnimation.h"

@interface FLAnimation : FLAbstractAnimation {
}

- (id) initWithAnimationDirection:(FLAnimationDirection) direction;

- (void) startAnimating:(id) target
             completion:(fl_block_t) completion;

// overrides
// animations are disabled during prepare and finish,
// commit is where you apply the animations
- (void) prepareAnimation:(CALayer*) layer;
- (void) commitAnimation:(CALayer*) layer;
- (void) finishAnimation:(CALayer*) layer;

- (void) didMoveToParentAnimation:(FLAbstractAnimation*) parent;

@end


