//
//  FLAbstractAnimation.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/21/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAbstractAnimation.h"

@implementation FLAbstractAnimation
@synthesize duration = _duration;
@synthesize direction = _direction;
@synthesize timing = _timing;
@synthesize axis = _axis;
@synthesize removeTransform = _removeTransform;

@synthesize parentAnimation = _parentAnimation;

- (id) init {
    self = [super init];
    if(self) {
        self.duration = 0.3f;
        self.removeTransform = YES;
    }
    return self;
}


- (void) startAnimationWithPrepareBlock:(fl_block_t) prepare
                          commitBlock:(fl_block_t) commit
                          finishBlock:(fl_block_t) finish
                      completionBlock:(fl_block_t) completion {

  
    completion = FLCopyWithAutorelease(completion);

    FLAssert([NSThread isMainThread], @"not on main thread");
    
    if(prepare) {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

        prepare();
        
        [CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
        [CATransaction commit];
    }

    finish = FLCopyWithAutorelease(finish);

    [CATransaction setCompletionBlock:^{
        if(finish) {
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

            finish();
                
            [CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
            [CATransaction commit];
        }
    
        if(completion) {
            completion();
        }
    }];
    
    
    if(commit) {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
        [CATransaction setAnimationDuration:self.duration];
        [CATransaction setAnimationTimingFunction:self.timingFunction];
        
        commit();
        
        [CATransaction commit];
    }
}

- (CAMediaTimingFunction*) timingFunction {
    return FLAnimationGetTimingFunction(self.timing);
}

- (void) configureAnimation:(CAAnimation*) animation {
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [animation setDuration:self.duration];
    [animation setTimingFunction:self.timingFunction];
}

@end

CAMediaTimingFunction* FLAnimationGetTimingFunction(FLAnimationTiming functionEnum) {
    switch(functionEnum) {
        case FLAnimationTimingDefault:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        break;
        case FLAnimationTimingLinear:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        break;
        case FLAnimationTimingEaseIn:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        break;
        case FLAnimationTimingEaseOut:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        break;
        case FLAnimationTimingEaseInEaseOut:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        break;
        case FLAnimationTimingCustom:   
            return nil;
        break;
    }
    
    return nil;
}
