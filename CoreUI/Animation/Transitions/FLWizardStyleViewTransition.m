//
//  FLWizardStyleViewTransition.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLWizardStyleViewTransition.h"
#import "FLFadeAnimation.h"
#import "FLSlideInAnimation.h"
#import "FLMoveAnimation.h"
#import "FLDistanceAnimation.h"

@implementation FLWizardStyleTransition 
- (id) init {
    self = [super init];
    if(self) {
		self.duration = 0.4;
    }
    return self;
}

@end


@implementation FLWizardStyleForwardTransition

+ (id) wizardStyleForwardTransition {
    return FLAutorelease([[[self class] alloc] init]);
}


- (id) init {
    self = [super init];
    if(self) {
        [self addShowAnimation:[FLSlideInAnimation slideInAnimation:FLAnimationDirectionRight]];
        [self addShowAnimation:[FLFadeInAnimation fadeInAnimation]];
        
        [self addHideAnimation:[FLDistanceAnimation distanceAnimation:1.0 finishScale:0.5]];
        [self addHideAnimation:[FLFadeOutAnimation fadeOutAnimation]];
 
    }
    return self;
}

@end


@implementation FLWizardStyleBackwardTransition


+ (id) wizardStyleBackwardTransition {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {
    self = [super init];
    if(self) {
        [self addShowAnimation:[FLDistanceAnimation distanceAnimation:0.5 finishScale:1.0]];
        [self addShowAnimation:[FLFadeInAnimation fadeInAnimation]];
        
        [self addHideAnimation:[FLSlideOutAnimation slideOutAnimation:FLAnimationDirectionRight]];
        [self addHideAnimation:[FLFadeOutAnimation fadeOutAnimation]];
 
    }
    return self;
}

@end
