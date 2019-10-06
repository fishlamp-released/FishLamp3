//
//  FLComeForwardAnimation.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDistanceAnimation.h"

@implementation FLDistanceAnimation 

- (id) initWithStartScale:(CGFloat) startScale finishScale:(CGFloat) finishScale {
    self = [super init];
    if(self) {
        _startScale = startScale;
        _finishScale = finishScale;
    }
    return self;
}

+ (id) distanceAnimation:(CGFloat) startScale finishScale:(CGFloat) finishScale {
    return FLAutorelease([[[self class] alloc] initWithStartScale:startScale finishScale:finishScale]);
}

- (CATransform3D) transformForFrame:(CGRect) frame withScale:(CGFloat) scaleAmount {

    CATransform3D scaleTransform = CATransform3DMakeScale(scaleAmount, scaleAmount, 1);
    CATransform3D translateTransform = CATransform3DMakeTranslation((frame.size.width * (1.0 - scaleAmount)) / 2.0f,  
                                                                    (frame.size.height * (1.0 - scaleAmount)), 0);

    return CATransform3DConcat(translateTransform, scaleTransform);
} 

- (void) prepareAnimation:(CALayer*) layer {

    _originalTransform = layer.transform;

    _startTransform = [self transformForFrame:layer.bounds withScale:_startScale];
    _finishTransform = [self transformForFrame:layer.bounds withScale:_finishScale]; 

    if(_startScale != 1.0f) {
        layer.transform = CATransform3DConcat(_originalTransform, _startTransform);
    }
    layer.hidden = NO;
}

- (void) commitAnimation:(CALayer *)layer {
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.fromValue =   [NSValue valueWithCATransform3D:layer.transform];
    scale.toValue =     [NSValue valueWithCATransform3D:_finishTransform];
    
    [self configureAnimation:scale];
    [layer addAnimation:scale forKey:@"transform"];
    layer.transform = _finishTransform;
}

- (void) finishAnimation:(CALayer*) layer {
    layer.transform = _originalTransform;
    [layer removeAnimationForKey:@"transform"];
}

@end

