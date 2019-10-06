//
//  FLPopInAnimation.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/4/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPopInAnimation.h"

@implementation FLPopInAnimation

+ (CAAnimation*) CAAnimation {
    
    CAKeyframeAnimation* popInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	
    popInAnimation.values = [NSArray arrayWithObjects:
							 [NSNumber numberWithFloat:0.6],
							 [NSNumber numberWithFloat:1.1],
							 [NSNumber numberWithFloat:.9],
							 [NSNumber numberWithFloat:1],
							 nil];
	
    popInAnimation.keyTimes = [NSArray arrayWithObjects:
							   [NSNumber numberWithFloat:0.0],
							   [NSNumber numberWithFloat:0.6],
							   [NSNumber numberWithFloat:0.8],
							   [NSNumber numberWithFloat:1.0], 
							   nil];	
    return popInAnimation;
}


+ (id) popInAnimation {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) prepareAnimation:(CALayer*) layer {
}

- (void) commitAnimation:(CALayer*) layer {
    [layer addAnimation:[FLPopInAnimation CAAnimation] forKey:@"transform.scale"];    
}

- (void) finishAnimation:(CALayer*) layer {
}

@end
