////
////  FLFlipAnimation.m
////  FishLampCocoaUI
////
////  Created by Mike Fullerton on 1/1/13.
////  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
////
//
//#import "FLFlipAnimation.h"
//
//
//@implementation FLFlipAnimation 
//
//@synthesize showBothSidesDuringFlip = _showBothSidesDuringFlip;
//@synthesize perspectiveDistance = _perspectiveDistance;
//
//- (id) initWithAnimationDirection:(FLAnimationDirection) direction {
//    self = [super initWithAnimationDirection:direction];
//    if(self) {
//        _perspectiveDistance = FLFlipAnimationDefaultPerspectiveDistance;
//        _showBothSidesDuringFlip = YES;
//    }
//    return self;
//}
//
//+ (id) flipAnimation:(FLAnimationDirection) direction {
//    return FLAutorelease([[[self class] alloc] initWithAnimationDirection:direction]);
//}
//
//+ (void) addPerspectiveToLayer:(CALayer*) layer 
//       withPerspectiveDistance:(CGFloat) distance {
// 
//    if(distance > 0) {
//        CATransform3D perspective = CATransform3DIdentity; 
//        perspective.m34 = -1. / distance;
//        layer.transform = perspective;
//    }
//}
//
////+ (CATransform3D) transformForFlipForDirection:(FLAnimationDirection) direction {
////
////    CATransform3D rotation = CATransform3DMakeRotation(M_PI / 2.0f, 0, 0, 1)
////
////    CATransform3D outTransform; CATransform3DScale(rotation, -1, 1, 1);
////
////    switch(self.direction) {
////        case FLAnimationDirectionUp:
////            keyPath = @"transform.rotation.x";
////            start = M_PI;
////            finish = 0.0;
////        break;
////        
////        case FLAnimationDirectionDown:
////            keyPath = @"transform.rotation.x";
////            start = 0.0f;
////            finish = -M_PI;
////        break;
////
////        case FLAnimationDirectionLeft:
////            keyPath = @"transform.rotation.y";
////            start = M_PI;
////            finish = 0.0f;
////        break;
////
////        case FLAnimationDirectionRight:
////            keyPath = @"transform.rotation.y";
////            start = 0.0f;
////            finish = -M_PI;
////        break;
////    }
////
////}
//
////- (CAAnimation*) CAAnimation {
////    
////    CGFloat start = 0.0f;
////    CGFloat finish = 0.0f;
////    NSString* keyPath = nil;
////
////    switch(self.direction) {
////        case FLAnimationDirectionUp:
////            keyPath = @"transform.rotation.x";
////            start = M_PI;
////            finish = 0.0;
////        break;
////        
////        case FLAnimationDirectionDown:
////            keyPath = @"transform.rotation.x";
////            start = 0.0f;
////            finish = -M_PI;
////        break;
////
////        case FLAnimationDirectionLeft:
////            keyPath = @"transform.rotation.y";
////            start = M_PI;
////            finish = 0.0f;
////        break;
////
////        case FLAnimationDirectionRight:
////            keyPath = @"transform.rotation.y";
////            start = 0.0f;
////            finish = -M_PI;
////        break;
////    }
////
////    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:keyPath];
////    flipAnimation.fromValue = [NSNumber numberWithDouble:start];
////    flipAnimation.toValue = [NSNumber numberWithDouble:finish];
////    flipAnimation.fillMode = kCAFillModeBoth;
////    flipAnimation.additive = YES;
////    flipAnimation.removedOnCompletion = NO;
////    return flipAnimation;
////}
//
////- (void) flipLayer:(CALayer*) layer direction:(FLAnimationDirection) direction {
////
////}
//
////- (NSArray*) forwardKeyFrames {
////
////    static NSMutableArray* s_frames = nil;
////    if(!s_frames) {
////        s_frames = [[NSMutableArray alloc] init];
////        [s_frames addObject:[NSNumber numberWithFloat:M_PI*2.0]];
////        [s_frames addObject:[NSNumber numberWithFloat:M_PI*1.5]];
////        [s_frames addObject:[NSNumber numberWithFloat:M_PI]];
//////        [s_frames addObject:[NSNumber numberWithFloat:M_PI*0.5]];
//////        [s_frames addObject:[NSNumber numberWithFloat:0.0]];
////
//////        [s_frames addObject:[NSNumber numberWithFloat:M_PI]];
////    }
////    return s_frames;
////}
////
////- (NSArray*) backwardKeyFrames {
////    static NSMutableArray* s_frames = nil;
////    if(!s_frames) {
////        s_frames = [[NSMutableArray alloc] init];
////        [s_frames addObject:[NSNumber numberWithFloat:0.0]];
////        [s_frames addObject:[NSNumber numberWithFloat:M_PI*0.5]];
////        [s_frames addObject:[NSNumber numberWithFloat:M_PI]];
//////        [s_frames addObject:[NSNumber numberWithFloat:M_PI*1.5]];
//////        [s_frames addObject:[NSNumber numberWithFloat:M_PI*2.0]];
////    }
////    return s_frames;
////}
////
////- (void) commitAnimation:(CALayer *)layer {
////
////    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
////    [animation setValues:self.direction == FLAnimationDirectionRight ? [self forwardKeyFrames]  : [self backwardKeyFrames]];
////    
////    NSString* axis = nil;
////    switch(self.axis) {
////        case FLAnimationAxisX:
////            axis = kCAValueFunctionRotateX;
////            break;
////        case FLAnimationAxisY:
////            axis = kCAValueFunctionRotateY;
////            break;
////        case FLAnimationAxisZ:
////            axis = kCAValueFunctionRotateZ;
////            break;
////    }
////    
////    [animation setValueFunction:[CAValueFunction functionWithName: axis]];
////    [self configureAnimation:animation];
////    [layer addAnimation:animation forKey:nil];
////}
////
////- (void) prepareAnimation:(CALayer*) layer {
////    layer.doubleSided = _showBothSidesDuringFlip;
////    
////    _position = layer.position;
////    _anchorPoint = layer.anchorPoint;
////
////    SDKRect frame = layer.frame;
////    CGPoint newPosition = _position;
////    newPosition.y += (frame.size.height/ 2);
////    newPosition.x += (frame.size.width / 2);
////    layer.anchorPoint = CGPointMake(0.5, 0.5);
////    layer.position = newPosition;
////}
////
//////- (void) commitAnimation:(CALayer*) layer {
////////    [layer addAnimation:[self CAAnimation] forKey:@"flip"];    
//////
//////    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//////    [animation setValues:self.direction == FLAnimationDirectionRight || FLAnimationDirectionDown ? [self forwardKeyFrames]  : [self backwardKeyFrames]];
//////    
//////    NSString* axis = nil;
//////    switch(self.axis) {
//////        case FLAnimationAxisX:
//////            axis = kCAValueFunctionRotateX;
//////            break;
//////        case FLAnimationAxisY:
//////            axis = kCAValueFunctionRotateY;
//////            break;
//////        case FLAnimationAxisZ:
//////            axis = kCAValueFunctionRotateZ;
//////            break;
//////    }
//////    
//////    [animation setValueFunction:[CAValueFunction functionWithName: axis]];
//////    [self configureAnimation:animation];
//////    [layer addAnimation:animation forKey:nil];
//////}
////
////- (void) finishAnimation:(CALayer*) layer {
////    layer.anchorPoint = _anchorPoint;
////    layer.position = _position;
////}
//
//
//
//@end
