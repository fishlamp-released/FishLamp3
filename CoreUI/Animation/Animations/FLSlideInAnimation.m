//
//  FLSlideInAnimation.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/22/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSlideInAnimation.h"
#import "FLGeometry.h"
#import "FLCompatibility.h"

@implementation FLSlideAnimation

@synthesize slideDirection = _slideDirection;

- (id) initWithSlideDirection:(FLAnimationDirection) direction {
    self = [super init];
    if(self) {
        _slideDirection = direction;
        
        self.timing = FLAnimationTimingEaseInEaseOut;
    }
    return self;
}


- (CGPoint) offscreenOrigin:(CALayer*) layer {

    CGRect frame = layer.frame;
    CGRect bounds = layer.superlayer.bounds;

    switch(self.direction) {
        case FLAnimationDirectionUp:
            return CGPointMake(frame.origin.x, bounds.origin.y);
        break;

        case FLAnimationDirectionDown:
            return CGPointMake(frame.origin.x, CGRectGetBottom(bounds) - frame.size.height);
        break;
        
        case FLAnimationDirectionLeft:
            return CGPointMake(bounds.origin.x - frame.size.width, frame.origin.y);
        break;
        
        case FLAnimationDirectionRight:
            return CGPointMake(CGRectGetRight(bounds) + frame.size.width, frame.origin.y);
        break;
    
    }
    
    return CGPointZero;
}


@end


@implementation FLSlideInAnimation


+ (id) slideInAnimation:(FLAnimationDirection)slideInDirection {
    return FLAutorelease([[[self class] alloc] initWithSlideDirection:slideInDirection]);
}

- (void) prepareAnimation:(CALayer*) layer {
    _onScreenOrigin = layer.position;
    [layer setPosition:[self offscreenOrigin:layer]];
    layer.hidden = NO;
}

- (void) commitAnimation:(CALayer*) layer {
    CABasicAnimation *moveFrame = [CABasicAnimation animationWithKeyPath:@"position"];

    [moveFrame setFromValue:[NSValue valueWithPoint:NSPointFromCGPoint(layer.position)]];
    [moveFrame setToValue:[NSValue valueWithPoint:NSPointFromCGPoint(_onScreenOrigin)]];

    [self configureAnimation:moveFrame];
    [layer addAnimation:moveFrame forKey:@"position"];
}

- (void) finishAnimation:(CALayer*) layer {
    [layer setPosition:_onScreenOrigin];
    [layer removeAnimationForKey:@"position"];
}


@end

@implementation FLSlideOutAnimation


+ (id) slideOutAnimation:(FLAnimationDirection)slideInDirection {
    return FLAutorelease([[[self class] alloc] initWithSlideDirection:slideInDirection]);
}

- (void) prepareAnimation:(CALayer*) layer {
    _onScreenOrigin = layer.position;
    layer.hidden = NO;
}

- (void) commitAnimation:(CALayer*) layer {
    CABasicAnimation *moveFrame = [CABasicAnimation animationWithKeyPath:@"position"];
    [moveFrame setFromValue:[NSValue valueWithPoint:NSPointFromCGPoint(layer.position)]];
    [moveFrame setToValue:[NSValue valueWithPoint:NSPointFromCGPoint([self offscreenOrigin:layer])]];
    [self configureAnimation:moveFrame];
    [layer addAnimation:moveFrame forKey:@"position"];
}

- (void) finishAnimation:(CALayer*) layer {
    layer.hidden = YES;
    [layer setPosition:_onScreenOrigin];
    [layer removeAnimationForKey:@"position"];
}


@end

