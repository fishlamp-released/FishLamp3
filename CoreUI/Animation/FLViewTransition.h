//
//  FLViewTransition.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAbstractAnimation.h"
#import "FLAnimation.h"
#import "FLCompatibility.h"

@interface FLAbstractViewTransition : FLAbstractAnimation {
@private 
    SDKView* _viewToShow;
    SDKView* _viewToHide;
}

- (void) startShowingView:(SDKView*) viewToShow 
               viewToHide:(SDKView*) viewToHide
               completion:(fl_block_t) completion;

// overrides
- (void) prepareTransition:(CALayer*) showLayer hideLayer:(CALayer*) hideLayer;
- (void) commitTransition:(CALayer*) showLayer hideLayer:(CALayer*) hideLayer;
- (void) finishTransition:(CALayer*) showLayer hideLayer:(CALayer*) hideLayer;

@end

@interface FLViewTransition : FLAbstractViewTransition {
@private
    FLAnimation* _showAnimation;
    FLAnimation* _hideAnimation;
}
@property (readwrite, strong, nonatomic) FLAnimation* showAnimation;
@property (readwrite, strong, nonatomic) FLAnimation* hideAnimation;

@end


@interface FLBatchViewTransition : FLAbstractViewTransition {
@private
    NSMutableArray* _showAnimations;
    NSMutableArray* _hideAnimations;
}

- (void) addShowAnimation:(FLAnimation*) animation;
- (void) addHideAnimation:(FLAnimation*) animation;

@end