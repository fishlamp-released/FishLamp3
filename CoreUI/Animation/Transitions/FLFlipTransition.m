//
//  FLFlipAnimation.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 12/21/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

// see http://www.mentalfaculty.com/mentalfaculty/Blog/Entries/2010/9/22_FLIPPIN_OUT_AT_NSVIEW.html

#import "FLFlipTransition.h"

#if OSX
@implementation NSView (FLFlipAnimation)

-(CALayer *)layerFromContents {
    CALayer *newLayer = [CALayer layer];
    newLayer.bounds = NSRectToCGRect(self.bounds);
    NSBitmapImageRep *bitmapRep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    [self cacheDisplayInRect:self.bounds toBitmapImageRep:bitmapRep];
    newLayer.contents = (id)bitmapRep.CGImage;
    return newLayer;
}

@end
#else

@implementation UIView (FLFlipAnimation)

-(CALayer *)layerFromContents {
    CALayer *newLayer = [CALayer layer];
    newLayer.bounds = self.bounds;
//    NSBitmapImageRep *bitmapRep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
//    [self cacheDisplayInRect:self.bounds toBitmapImageRep:bitmapRep];
//    newLayer.contents = (id)bitmapRep.CGImage;

    return newLayer;
}

@end

#endif

@implementation FLFlipTransition

@synthesize perspectiveDistance = _perspectiveDistance;
@synthesize perspectiveScale = _scale;

- (id) initWithDirection:(FLAnimationDirection) direction {
               
    self = [super init];
    if(self) {
        _perspectiveDistance = FLFlipTransitionDefaultPerspectiveDistance;
        self.duration = .75;
        _scale = 1.0;
        self.axis = FLAnimationAxisX;
    }
    
    return self;
}

+ (id) flipTransition:(FLAnimationDirection) animationDirection {
    return FLAutorelease([[[self class] alloc] initWithDirection:animationDirection]);
}

- (CAAnimation *)flipAnimationForLayerBeginningOnTop:(BOOL)beginsOnTop  {    

    NSString* axisKeyPath = nil;
    switch(self.axis) {
        case FLAnimationAxisX:
            axisKeyPath = @"transform.rotation.x";
            break;
        case FLAnimationAxisY:
            axisKeyPath = @"transform.rotation.y";
            break;
        case FLAnimationAxisZ:
            axisKeyPath = @"transform.rotation.z";
            break;
    }
                              
    // Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:axisKeyPath];
    CGFloat forwardStart = beginsOnTop ? 0.0f : M_PI; 
    CGFloat forwardEnd = beginsOnTop ? -M_PI : 0.0f; 
    
    if(self.direction == FLAnimationDirectionRight || self.direction == FLAnimationDirectionDown) {
        flipAnimation.fromValue = [NSNumber numberWithDouble:forwardStart];
        flipAnimation.toValue = [NSNumber numberWithDouble:forwardEnd];
    }
    else {
        flipAnimation.toValue = [NSNumber numberWithDouble:forwardStart];
        flipAnimation.fromValue = [NSNumber numberWithDouble:forwardEnd];
    }
    
    // Shrinking the view makes it seem to move away from us, for a more natural effect
    // Can also grow the view to make it move out of the screen
    CABasicAnimation *shrinkAnimation = nil;
    if ( _scale != 1.0f ) {
        shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shrinkAnimation.toValue = [NSNumber numberWithFloat:_scale];
        
        // We only have to animate the shrink in one direction, then use autoreverse to "grow"
        shrinkAnimation.duration = self.duration * 0.5;
        shrinkAnimation.autoreverses = YES;
    }
    
    // Combine the flipping and shrinking into one smooth animation
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:flipAnimation, shrinkAnimation, nil];
    
    [self configureAnimation:animationGroup];
    
    // As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
//    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

//    animationGroup.duration = self.duration;
//    
//    // Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
//    animationGroup.fillMode = kCAFillModeForwards;
//    animationGroup.removedOnCompletion = NO;
    
    return animationGroup;
}

- (void) startShowingView:(SDKView*) bottomView 
               viewToHide:(SDKView*) topView
               completion:(fl_block_t) completion {
    
    SDKView* hostView = bottomView.superview;

    [bottomView removeFromSuperview];
    
    CAAnimation *topAnimation = [self flipAnimationForLayerBeginningOnTop:YES];
    CAAnimation *bottomAnimation = [self flipAnimationForLayerBeginningOnTop:NO];
    
    bottomView.frame = topView.frame;

    CALayer* topLayer = [topView layerFromContents];
    CALayer* bottomLayer = [bottomView layerFromContents];
    
    if(_perspectiveDistance != 1.0) {
        CGFloat zDistance = _perspectiveDistance;
        CATransform3D perspective = CATransform3DIdentity; 
        perspective.m34 = -1. / zDistance;
        topLayer.transform = perspective;
        bottomLayer.transform = perspective;
    }

#if OSX
    bottomLayer.frame =  NSRectToCGRect(topView.frame);
#else
    bottomLayer.frame =  topView.frame;
#endif

    bottomLayer.doubleSided = NO;
    [hostView.layer addSublayer:bottomLayer];
    
    topLayer.doubleSided = NO;

#if OSX
    topLayer.frame = NSRectToCGRect(topView.frame);
#else
    topLayer.frame = topView.frame;
#endif

    [hostView.layer addSublayer:topLayer];
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    [topView removeFromSuperview];
    [CATransaction commit];
    
    completion = FLCopyWithAutorelease(completion);
    
    [CATransaction setCompletionBlock:^{
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
        [hostView addSubview:bottomView];
        [topLayer removeFromSuperlayer];
        [bottomLayer removeFromSuperlayer];
        [CATransaction commit];
    
        if(completion) {
            completion();
        }
    }];

    
    [CATransaction begin];
    [topLayer addAnimation:topAnimation forKey:@"flip"];
    [bottomLayer addAnimation:bottomAnimation forKey:@"flip"];
    [CATransaction commit];
}  


@end

