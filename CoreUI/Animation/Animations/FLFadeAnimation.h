//
//  FLFadeAnimation.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/15/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAnimation.h"


@interface FLOpacityAnimation : FLAnimation {
@private
    CGFloat _startOpacity;
}
@end

@interface FLFadeInAnimation : FLOpacityAnimation {
@private
}
+ (id) fadeInAnimation;; 
@end

@interface FLFadeOutAnimation : FLOpacityAnimation {
@private
}
+ (id) fadeOutAnimation; 
@end
