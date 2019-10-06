//
//  FLFadeAnimation.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/15/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFadeAnimation.h"

@interface FLOpacityAnimation ()
@property (readwrite, assign, nonatomic) CGFloat startOpacity;
@end

@implementation FLOpacityAnimation

@synthesize startOpacity = _startOpacity;

+ (id) fadeAnimation {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) prepareAnimation:(CALayer*) layer {
    _startOpacity = layer.opacity;
}

- (void) finishAnimation:(CALayer*) layer{
    [layer setOpacity:_startOpacity];
    [layer removeAnimationForKey:@"opacity"];
}

- (void) commitFadeForLayer:(CALayer*) layer from:(CGFloat) fromOpacity toOpacity:(CGFloat) toOpacity {
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = [NSNumber numberWithFloat:fromOpacity];
    fade.toValue = [NSNumber numberWithFloat:toOpacity];
    [self configureAnimation:fade];
    [layer addAnimation:fade forKey:@"opacity"];
}

@end

@implementation FLFadeInAnimation

+ (id) fadeInAnimation {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) prepareAnimation:(CALayer*) layer {
    [super prepareAnimation:layer];
    layer.opacity = 0;
    layer.hidden = NO;
}

- (void) commitAnimation:(CALayer*) layer {
    [self commitFadeForLayer:layer from:0.0 toOpacity:self.startOpacity];
}

@end

@implementation FLFadeOutAnimation

+ (id) fadeOutAnimation {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) commitAnimation:(CALayer*) layer {
    [self commitFadeForLayer:layer from:self.startOpacity toOpacity:0];
}

- (void) finishAnimation:(CALayer*) layer {
    layer.hidden = YES;
    [super finishAnimation:layer];
}


@end