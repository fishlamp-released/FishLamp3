//
//  FLMoveAnimation.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/15/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLMoveAnimation.h"
#import "FLCompatibility.h"

@interface FLMoveAnimation ()

@end

@implementation FLMoveAnimation 
@synthesize startPoint = _startPoint;
@synthesize finishPoint = _finishPoint;

- (id) initWithDestination:(CGPoint) point {
    self = [super init];
    if(self) {
        self.finishPoint = point;
    }
    return self;
}

+ (id) moveAnimation:(CGPoint) destination  {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) setStartPoint: (CGPoint) point {
    _startPoint = point;
    _setStartPoint = YES;
}

- (void) setFinishPoint: (CGPoint) point {
    _finishPoint = point;
    _setFinishPoint = YES;
}

- (CAAnimation*) CAAnimation {

    CABasicAnimation *moveFrame = [CABasicAnimation animationWithKeyPath:@"position"];
    [moveFrame setFromValue:[NSValue valueWithPoint:NSPointFromCGPoint(_startPoint)]];
    [moveFrame setToValue:[NSValue valueWithPoint:NSPointFromCGPoint(_finishPoint)]];
    [self configureAnimation:moveFrame];
    return moveFrame;
}

- (void) prepareAnimation:(CALayer*) layer {
    [layer setPosition:_startPoint];
}

- (void) commitAnimation:(CALayer*) layer {
    [layer addAnimation:[self CAAnimation] forKey:@"position"];
//    [layer setPosition:_finishPoint];
}

- (void) finishAnimation:(CALayer*) layer {
    [layer setPosition:_finishPoint];
}

@end

