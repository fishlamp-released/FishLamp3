//
//  FLComeForwardAnimation.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAnimation.h"

#define FLDropBackAnimationDefaultScale 0.95f

@interface FLDistanceAnimation : FLAnimation {
@private
    CGFloat _startScale;
    CGFloat _finishScale;
    
    CATransform3D _startTransform;
    CATransform3D _finishTransform;
    CATransform3D _originalTransform;
}

+ (id) distanceAnimation:(CGFloat) scale finishScale:(CGFloat) finishScale;

@end