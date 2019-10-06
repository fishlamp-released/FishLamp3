//
//  FLSlideInAnimation.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/22/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAnimation.h"

@interface FLSlideAnimation : FLAnimation {
@private
    FLAnimationDirection _slideDirection;
}
@property (readonly, assign, nonatomic) FLAnimationDirection slideDirection;
@end

@interface FLSlideInAnimation : FLSlideAnimation {
@private
    CGPoint _onScreenOrigin;
}
+ (id) slideInAnimation:(FLAnimationDirection) slideInDirection;
@end

@interface FLSlideOutAnimation : FLSlideAnimation {
@private
    CGPoint _onScreenOrigin;
}
+ (id) slideOutAnimation:(FLAnimationDirection) slideInDirection;
@end

