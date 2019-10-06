//
//  FLRotateAnimation.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/10/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLRotateAnimation.h"

//@implementation FLRotateAnimation
////CGFloat GetNextDegree(CGFloat inDegree, CGFloat increment) {
////
////    CGFloat degree = inDegree + increment;
////
////    if(degree >= 360.0f) {
////        degree = 360.0f - degree;
////    }
////    else if(degree < 0.0) {
////        degree = 360.0f + degree;
////        
////    }
////
////    FLDebugLog(@"next: %f, prev: %f", degree, inDegree);
////
////    return degree;
////}
//
////- (void) somersault;
////{
////
////    CALayer* layer = [self layer];
////    NSMutableArray* keyFrameValues = [NSMutableArray array];
////    [keyFrameValues addObject:[NSNumber numberWithFloat:0.0]];
////    //[values addObject:[NSNumber numberWithFloat:M_PI*0.5]];
////    [keyFrameValues addObject:[NSNumber numberWithFloat:M_PI]];
////    [keyFrameValues addObject:[NSNumber numberWithFloat:M_PI*1.5]];
////    [keyFrameValues addObject:[NSNumber numberWithFloat:M_PI*2.0]];
////
////    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
////    [animation setValues:keyFrameValues];
////    [animation setValueFunction:[CAValueFunction functionWithName: kCAValueFunctionRotateX]];// kCAValueFunctionRotateZ]];
////
////    [animation setDuration:0.9];
////    //[animation setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
////
////    [layer addAnimation:animation forKey:nil];
////
////    return;
////}
//
//- (CAAnimation*) CAAnimation:(FLAnimationFlags) flags {
//    CABasicAnimation *rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"]; //Rotate about z-axis
//    [rotationAnimation setFromValue:[NSNumber numberWithFloat:FLDegreesToRadians(_fromDegree)]];
//    [rotationAnimation setToValue:[NSNumber numberWithFloat:FLDegreesToRadians(_toDegree)]];
//    
////    [rotationAnimation setByValue:[NSNumber numberWithFloat:FLDegreesToRadians(_deltaAmount)]];
//    [rotationAnimation setDuration:4.0];
//    rotationAnimation.cumulative = NO;
//    [rotationAnimation setRemovedOnCompletion:YES];
////    [rotationAnimation setFillMode:kCAFillModeForwards];
//    return rotationAnimation;
//}
//
//- (void) commitAnimation:(CALayer*) layer withAnimationFlags:(FLAnimationFlags) flags {
//    [layer addAnimation:[self CAAnimation:flags] forKey:@"transform.rotation.z"];
//}
//
//- (void) startRotating:(id) target 
//        startFlags:(FLAnimationStartFlags) startFlags
//            fromDegree:(CGFloat) from 
//              toDegree:(CGFloat) toDegree 
//            completion:(fl_block_t) completion {
//    _fromDegree = from;
//    _toDegree = toDegree;
//    
//    FLDebugLog(@"Start rotating: from %f to %f", _fromDegree, _toDegree);
//    
//    [self startAnimating:target startFlags:startFlags completion:completion];
//}            
//
//- (void) startRotating:(id) target 
//       degreesToRotate:(CGFloat) degrees 
//            completion:(fl_block_t) completion {
//    
//    _deltaAmount = degrees;
//    
//    FLDebugLog(@"Start rotating by degrees: %f", _deltaAmount);
//    
//    [self startAnimating:target completion:completion];
//            
//}            
//
//
//@end

@implementation FLSomersaultAnimation

- (NSArray*) forwardKeyFrames {

    static NSMutableArray* s_frames = nil;
    if(!s_frames) {
        s_frames = [[NSMutableArray alloc] init];
        [s_frames addObject:[NSNumber numberWithFloat:M_PI*2.0]];
        [s_frames addObject:[NSNumber numberWithFloat:M_PI*1.5]];
        [s_frames addObject:[NSNumber numberWithFloat:M_PI]];
        [s_frames addObject:[NSNumber numberWithFloat:M_PI*0.5]];
        [s_frames addObject:[NSNumber numberWithFloat:0.0]];

//        [s_frames addObject:[NSNumber numberWithFloat:M_PI]];
    }
    return s_frames;
}

- (NSArray*) backwardKeyFrames {
    static NSMutableArray* s_frames = nil;
    if(!s_frames) {
        s_frames = [[NSMutableArray alloc] init];
        [s_frames addObject:[NSNumber numberWithFloat:0.0]];
        [s_frames addObject:[NSNumber numberWithFloat:M_PI*0.5]];
        [s_frames addObject:[NSNumber numberWithFloat:M_PI]];
        [s_frames addObject:[NSNumber numberWithFloat:M_PI*1.5]];
        [s_frames addObject:[NSNumber numberWithFloat:M_PI*2.0]];
    }
    return s_frames;
}

- (void) commitAnimation:(CALayer *)layer {

    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    [animation setValues:self.direction == FLAnimationDirectionRight ? [self forwardKeyFrames]  : [self backwardKeyFrames]];
    
    NSString* axis = nil;
    switch(self.axis) {
        case FLAnimationAxisX:
            axis = kCAValueFunctionRotateX;
            break;
        case FLAnimationAxisY:
            axis = kCAValueFunctionRotateY;
            break;
        case FLAnimationAxisZ:
            axis = kCAValueFunctionRotateZ;
            break;
    }
    
    [animation setValueFunction:[CAValueFunction functionWithName: axis]];
    [self configureAnimation:animation];
    [layer addAnimation:animation forKey:@"transform"];
}

@end
