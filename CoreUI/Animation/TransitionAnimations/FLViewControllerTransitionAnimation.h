//
//  FLViewControllerTransitionAnimation.h
//  FishLamp-iOS
//
//  Created by Mike Fullerton on 5/12/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLCompatibility.h"

// transition animations

typedef void (^FLViewControllerBlock)(id viewController);
typedef void (^FLViewControllerAnimationBlock)(id viewController, id parentViewController);

@protocol FLViewControllerTransitionAnimation <NSObject> 

- (void) beginShowAnimationForViewController:(SDKViewController*) viewController
                        parentViewController:(SDKViewController*) parentViewController
                               finishedBlock:(FLViewControllerAnimationBlock) finishedBlock; 

- (void) beginHideAnimationForViewController:(SDKViewController*) viewController
                        parentViewController:(SDKViewController*) parentViewController
                               finishedBlock:(FLViewControllerAnimationBlock) finishedBlock; 

@end  

@interface FLViewControllerTransitionAnimation : NSObject<FLViewControllerTransitionAnimation> {
@private
    FLViewControllerAnimationBlock _callback;
}

@property (readwrite, copy, nonatomic) FLViewControllerAnimationBlock callback;

+ (id) viewControllerTransitionAnimation;

@end

@interface FLDefaultViewControllerAnimation : FLViewControllerTransitionAnimation 
@end

@interface FLDropAndSlideInFromRightAnimation : FLViewControllerTransitionAnimation
@end

@interface FLDropAndSlideInFromLeftAnimation : FLViewControllerTransitionAnimation
@end

@interface FLCrossFadeAnimation : FLViewControllerTransitionAnimation
@end

@interface FLPopinViewControllerAnimation : FLViewControllerTransitionAnimation {
@private
    SDKViewController* _parent;
    SDKViewController* _viewController;
}
@end
