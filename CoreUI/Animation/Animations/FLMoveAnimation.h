//
//  FLMoveAnimation.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/15/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLAnimation.h"

@interface FLMoveAnimation : FLAnimation {
@private
    CGPoint _startPoint;
    CGPoint _finishPoint;
    BOOL _setStartPoint;
    BOOL _setFinishPoint;
}

@property (readwrite, assign, nonatomic) CGPoint startPoint;
@property (readwrite, assign, nonatomic) CGPoint finishPoint;
+ (id) moveAnimation:(CGPoint) destination;
@end



