//
//  FLBatchAnimation.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/23/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAnimation.h"

@interface FLBatchAnimation : FLAnimation {
@private
    NSMutableArray* _animations;
}

//// use this to add child animations
- (void) addAnimation:(FLAnimation*) animation;

@end