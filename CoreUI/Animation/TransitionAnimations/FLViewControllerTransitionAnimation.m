//
//  FLViewControllerTransitionAnimation.m
//  FishLamp-iOS
//
//  Created by Mike Fullerton on 5/12/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLViewControllerTransitionAnimation.h"
#import "FLGeometry.h"

@implementation FLViewControllerTransitionAnimation

@synthesize callback = _callback;

+ (id) viewControllerTransitionAnimation
{
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) beginShowAnimationForViewController:(SDKViewController*) viewController
    parentViewController:(SDKViewController*) parentViewController
    finishedBlock: (FLViewControllerAnimationBlock) finishedBlock
{
    if(finishedBlock)
        finishedBlock(viewController, parentViewController);
}    

- (void) beginHideAnimationForViewController:(SDKViewController*) viewController
    parentViewController:(SDKViewController*) parentViewController
    finishedBlock: (FLViewControllerAnimationBlock) finishedBlock
{
    if(finishedBlock)
        finishedBlock(viewController, parentViewController);
}

#if FL_MRC
- (void) dealloc
{
    FLRelease(_callback);
    FLSuperDealloc();
}
#endif

@end

@implementation FLDefaultViewControllerAnimation

FLSynthesizeSingleton(FLDefaultViewControllerAnimation);

+ (id) viewControllerTransitionAnimation
{
    return [self instance];
}

@end   

@implementation FLDropAndSlideInFromRightAnimation

FLSynthesizeSingleton(FLDropAndSlideInFromRightAnimation);

+ (id) viewControllerTransitionAnimation
{
    return [self instance];
}

- (void) beginShowAnimationForViewController:(SDKViewController*) viewController
    parentViewController:(SDKViewController*) parentViewController
    finishedBlock: (FLViewControllerAnimationBlock) finishedBlock
{
#if IOS
    CGRect destFrame = viewController.view.superview.bounds;
    viewController.view.frame = CGRectSetLeft(destFrame, CGRectGetRight(destFrame));
    
    CGFloat savedAlpha = parentViewController.view.alpha;
    [SDKView animateWithDuration:0.4
                delay:0.0f
                options:UIViewAnimationOptionCurveEaseInOut
                animations:^{
      //              parentViewController.view.frame = CGRectInset(parentViewController.view.frame, 10, 10);
                    parentViewController.view.alpha = 0.0;
                    viewController.view.frame = destFrame;
                } 
                completion:^(BOOL completed) {
                    parentViewController.view.alpha = savedAlpha;
      //              parentViewController.view.frame = CGRectInset(parentViewController.view.frame, -10, -10);
                    if(finishedBlock)
                    {
                        finishedBlock(viewController, parentViewController);
                    }
                }
            ];
#endif
}

- (void) beginHideAnimationForViewController:(SDKViewController*) viewController
    parentViewController:(SDKViewController*) parentViewController
    finishedBlock: (FLViewControllerAnimationBlock) finishedBlock
{
#if IOS
    CGRect destFrame = CGRectSetLeft(viewController.view.frame, CGRectGetRight(viewController.view.superview.bounds));
    CGFloat savedAlpha = parentViewController.view.alpha;
    parentViewController.view.alpha = 0.0;
    
    [SDKView animateWithDuration:0.4
                delay:0.0f
                options:UIViewAnimationOptionCurveEaseInOut
                animations:^{
                    parentViewController.view.alpha = savedAlpha;
                    viewController.view.frame = destFrame;
                } 
                completion:^(BOOL completed) {
                    if(finishedBlock)
                    {
                        finishedBlock(viewController, parentViewController);
                    }
                }
            ];
#endif
}


@end

@implementation FLDropAndSlideInFromLeftAnimation

FLSynthesizeSingleton(FLDropAndSlideInFromLeftAnimation);

+ (id) viewControllerTransitionAnimation
{
    return [self instance];
}

- (void) beginShowAnimationForViewController:(SDKViewController*) viewController
                        parentViewController:(SDKViewController*) parentViewController
                               finishedBlock:(FLViewControllerAnimationBlock) finishedBlock
{

#if IOS
    CGRect destFrame = viewController.view.superview.bounds;
    viewController.view.frame = CGRectSetLeft(destFrame, -destFrame.size.width);
    
    CGFloat savedAlpha = parentViewController.view.alpha;
    

    [SDKView animateWithDuration:0.4
                delay:0.0f
                options:UIViewAnimationOptionCurveEaseInOut
                animations:^{
                    parentViewController.view.alpha = 0.0;
                    viewController.view.frame = destFrame;
                } 
                completion:^(BOOL completed) {
                    parentViewController.view.alpha = savedAlpha;
                    if(finishedBlock)
                    {
                        finishedBlock(viewController, parentViewController);
                    }
                }
            ];
#endif
}

- (void) beginHideAnimationForViewController:(SDKViewController*) viewController
                        parentViewController:(SDKViewController*) parentViewController
                               finishedBlock: (FLViewControllerAnimationBlock) finishedBlock
{
#if IOS
    CGRect destFrame = viewController.view.frame;
    destFrame.origin.x = -destFrame.size.width;

    CGFloat savedAlpha = parentViewController.view.alpha;
    parentViewController.view.alpha = 0.0;
    
    [SDKView animateWithDuration:0.4
                delay:0.0f
                options:UIViewAnimationOptionCurveEaseInOut
                animations:^{
                    parentViewController.view.alpha = savedAlpha;
                    viewController.view.frame = destFrame;
                } 
                completion:^(BOOL completed) {
                    if(finishedBlock)
                    {
                        finishedBlock(viewController, parentViewController);
                    }
                }
            ];
#endif
}


@end


@implementation FLCrossFadeAnimation

FLSynthesizeSingleton(FLCrossFadeAnimation);

+ (id) viewControllerTransitionAnimation
{
    return [self instance];
}

- (void) beginShowAnimationForViewController:(SDKViewController*) viewController
    parentViewController:(SDKViewController*) parentViewController
    finishedBlock: (FLViewControllerAnimationBlock) finishedBlock
{
#if IOS
    CGFloat savedParentAlpha = parentViewController.view.alpha;
    CGFloat savedNewAlpha = viewController.view.alpha;
    viewController.view.alpha = 0.0;
    
    [SDKView animateWithDuration:0.25
                delay:0.0f
                options:UIViewAnimationOptionCurveEaseInOut
                animations:^{
                    parentViewController.view.alpha = 0.0;
                    viewController.view.alpha = savedNewAlpha;
                } 
                completion:^(BOOL completed) {
                    parentViewController.view.alpha = savedParentAlpha;
                    if(finishedBlock)
                    {
                        finishedBlock(viewController, parentViewController);
                    }
                }
            ];
#endif
}

- (void) beginHideAnimationForViewController:(SDKViewController*) viewController
    parentViewController:(SDKViewController*) parentViewController
    finishedBlock: (FLViewControllerAnimationBlock) finishedBlock
{
#if IOS
    CGFloat savedParentAlpha = parentViewController.view.alpha;
    CGFloat savedNewAlpha = viewController.view.alpha;
    parentViewController.view.alpha = 0.0;
    
    [SDKView animateWithDuration:0.25
                delay:0.0f
                options:UIViewAnimationOptionCurveEaseInOut
                animations:^{
                    viewController.view.alpha = 0.0;
                    parentViewController.view.alpha = savedParentAlpha;
                } 
                completion:^(BOOL completed) {
                    viewController.view.alpha = savedNewAlpha;
                    if(finishedBlock)
                    {
                        finishedBlock(viewController, parentViewController);
                    }
                }
            ];
#endif
}
@end

@implementation FLPopinViewControllerAnimation


- (void)animationDidStart:(CAAnimation *)anim
{
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(self.callback)
    {
        self.callback(_viewController, _parent);
    }
    FLReleaseWithNil(_viewController);
    FLReleaseWithNil(_parent);
}

- (void) dealloc
{
    FLReleaseWithNil(_viewController);
    FLReleaseWithNil(_parent);

    FLSuperDealloc();
}

- (void) beginShowAnimationForViewController:(SDKViewController*) viewController
    parentViewController:(SDKViewController*) parentViewController
    finishedBlock: (FLViewControllerAnimationBlock) finishedBlock
{
#if IOS
    self.callback = finishedBlock;

    FLSetObjectWithRetain(_viewController, viewController);
    FLSetObjectWithRetain(_parent, parentViewController);

	CALayer *viewLayer = viewController.view.layer;
	CAKeyframeAnimation* popInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	
	popInAnimation.duration = 0.25f;
	popInAnimation.values = [NSArray arrayWithObjects:
							 [NSNumber numberWithFloat:0.6],
							 [NSNumber numberWithFloat:1.1],
							 [NSNumber numberWithFloat:.9],
							 [NSNumber numberWithFloat:1],
							 nil];
	popInAnimation.keyTimes = [NSArray arrayWithObjects:
							   [NSNumber numberWithFloat:0.0],
							   [NSNumber numberWithFloat:0.6],
							   [NSNumber numberWithFloat:0.8],
							   [NSNumber numberWithFloat:1.0], 
							   nil];	
	popInAnimation.delegate = self;
	
	[viewLayer addAnimation:popInAnimation forKey:@"transform.scale"];	
#endif
}

- (void) beginHideAnimationForViewController:(SDKViewController*) viewController
    parentViewController:(SDKViewController*) parentViewController
    finishedBlock: (FLViewControllerAnimationBlock) finishedBlock
{
#if IOS
    self.callback = finishedBlock;
    FLSetObjectWithRetain(_viewController, viewController);
    FLSetObjectWithRetain(_parent, parentViewController);

	CALayer *viewLayer = viewController.view.layer;
	CAKeyframeAnimation* popInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	
	popInAnimation.duration = 0.15f;
	popInAnimation.values = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:1.0],
                                [NSNumber numberWithFloat:0.0],
                                nil];
    popInAnimation.keyTimes = [NSArray arrayWithObjects:
							   [NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:1.0], 
							   nil];	
	popInAnimation.delegate = self;
	
	[viewLayer addAnimation:popInAnimation forKey:@"transform.scale"];	
#endif
}

    
@end