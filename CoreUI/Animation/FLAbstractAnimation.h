//
//  FLAbstractAnimation.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/21/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

#import <QuartzCore/QuartzCore.h>

typedef enum {
    FLAnimationDirectionRight,
    FLAnimationDirectionLeft,
    FLAnimationDirectionUp,
    FLAnimationDirectionDown,
} FLAnimationDirection;

#define FLAnimationDirectionForward     FLAnimationDirectionRight
#define FLAnimationDirectionBackward    FLAnimationDirectionLeft

NS_INLINE
FLAnimationDirection FLAnimationDirectionGetOppositeDirection(FLAnimationDirection direction) {
    switch(direction) {
        case FLAnimationDirectionUp: 
            return FLAnimationDirectionDown;
        case FLAnimationDirectionDown: 
            return FLAnimationDirectionUp;
        case FLAnimationDirectionLeft: 
            return FLAnimationDirectionRight;
        case FLAnimationDirectionRight: 
            return FLAnimationDirectionLeft;
    }
}

typedef enum {
    FLAnimationAxisX,
    FLAnimationAxisY,
    FLAnimationAxisZ
} FLAnimationAxis;

typedef enum {
    FLAnimationTimingDefault,
    FLAnimationTimingLinear,
    FLAnimationTimingEaseIn,
    FLAnimationTimingEaseOut,
    FLAnimationTimingEaseInEaseOut,
    FLAnimationTimingCustom   
} FLAnimationTiming;

@interface FLAbstractAnimation : NSObject {
@private
    CGFloat _duration;
    BOOL _removeTransform;
    FLAnimationTiming _timing;
    FLAnimationDirection _direction;
    FLAnimationAxis _axis;
    __weak FLAbstractAnimation* _parentAnimation;
}

@property (readwrite, assign, nonatomic) BOOL removeTransform;
@property (readwrite, weak, nonatomic) FLAbstractAnimation* parentAnimation;

@property (readwrite, assign, nonatomic) CGFloat duration;

@property (readwrite, assign, nonatomic) FLAnimationTiming timing;
@property (readwrite, assign, nonatomic) FLAnimationDirection direction;
@property (readwrite, assign, nonatomic) FLAnimationAxis axis;

- (void) startAnimationWithPrepareBlock:(fl_block_t) prepare
                          commitBlock:(fl_block_t) commit
                          finishBlock:(fl_block_t) finish
                      completionBlock:(fl_block_t) completion;
 
// subclass utils

- (CAMediaTimingFunction*) timingFunction;

- (void) configureAnimation:(CAAnimation*) animation;

@end

CAMediaTimingFunction* FLAnimationGetTimingFunction(FLAnimationTiming functionEnum);
