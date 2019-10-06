//
//  FLViewTransition.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLViewTransition.h"

@interface FLAbstractViewTransition ()
@property (readwrite, strong, nonatomic) SDKView* viewToShow;
@property (readwrite, strong, nonatomic) SDKView* viewToHide; 
@end

@implementation FLAbstractViewTransition

@synthesize viewToShow = _viewToShow;
@synthesize viewToHide = _viewToHide;

- (id) init {

    self = [super init];
    if(self) {
        self.duration = 0.5;
    }

    return self;
}

#if FL_MRC
- (void) dealloc {
    [_viewToShow release];
    [_viewToHide release];
    [super dealloc];
}
#endif

- (void) prepareTransition:(CALayer*) showLayer hideLayer:(CALayer*) hideLayer {
}

- (void) commitTransition:(CALayer*) showLayer hideLayer:(CALayer*) hideLayer {
}

- (void) finishTransition:(CALayer*) showLayer hideLayer:(CALayer*) hideLayer {
}

- (void) startShowingView:(SDKView*) viewToShow 
               viewToHide:(SDKView*) viewToHide
               completion:(fl_block_t) completion {
    
    FLAssertNotNil(viewToShow);
    FLAssertNotNil(viewToShow.superview);
  
    self.viewToShow = viewToShow;
    if(viewToHide) {
        FLAssertNotNil(viewToHide.superview);
        self.viewToHide = viewToHide;
    }
    
    CALayer* showLayer = [_viewToShow layer];
    CALayer* hideLayer = [_viewToHide layer];
    
    [self startAnimationWithPrepareBlock:^{ 
            viewToShow.hidden = NO;
            viewToHide.hidden = NO;
            [self prepareTransition:showLayer hideLayer:hideLayer]; 
        }
        commitBlock:^{ 
            [self commitTransition:showLayer hideLayer:hideLayer]; 
        }
        finishBlock:^{ 
            viewToHide.hidden = YES;
            [self finishTransition:showLayer hideLayer:hideLayer]; 
        }
        completionBlock:completion];
}                            
@end

@implementation FLViewTransition

@synthesize showAnimation = _showAnimation;
@synthesize hideAnimation = _hideAnimation;

#if FL_MRC
- (void) dealloc {
	[_showAnimation release];
    [_hideAnimation release];
    [super dealloc];
}
#endif

- (void) setShowAnimation:(FLAnimation*) animation {
    if(_showAnimation) {
        _showAnimation.parentAnimation = nil;
    }
    FLSetObjectWithRetain(_showAnimation, animation);
    _showAnimation.parentAnimation = self;
}


- (void) setHideAnimation:(FLAnimation*) animation {
    if(_showAnimation) {
        _showAnimation.parentAnimation = nil;
    }
    FLSetObjectWithRetain(_showAnimation, animation);
    _showAnimation.parentAnimation = self;
}

- (void) prepareTransition:(CALayer*) showLayer hideLayer:(CALayer*) hideLayer {
    [self.hideAnimation prepareAnimation:hideLayer];
    [self.showAnimation prepareAnimation:showLayer];
}

- (void) commitTransition:(CALayer*) showLayer hideLayer:(CALayer*) hideLayer {
    [self.hideAnimation commitAnimation:hideLayer];
    [self.showAnimation commitAnimation:showLayer];
}

- (void) finishTransition:(CALayer*) showLayer hideLayer:(CALayer*) hideLayer {
    [self.hideAnimation finishAnimation:hideLayer];
    [self.showAnimation finishAnimation:showLayer];
}

@end

@implementation FLBatchViewTransition
- (id) init {

    self = [super init];
    if(self) {
        _showAnimations = [[NSMutableArray alloc] init];
        _hideAnimations = [[NSMutableArray alloc] init];
    }

    return self;
}

#if FL_MRC
- (void) dealloc {
    [_showAnimations release];
    [_hideAnimations release];
    [super dealloc];
}
#endif

- (void) addShowAnimation:(FLAnimation*) animation {
    animation.parentAnimation = self;

    [_showAnimations addObject:animation];
}

- (void) addHideAnimation:(FLAnimation*) animation {
    animation.parentAnimation = self;

    [_hideAnimations addObject:animation];
}

- (void) commitTransition:(CALayer*) showLayer hideLayer:(CALayer*) hideLayer {
    for(FLAnimation* animation in _hideAnimations) {
        [animation commitAnimation:hideLayer];
    }
    for(FLAnimation* animation in _showAnimations) {
        [animation commitAnimation:showLayer];
    }
}

- (void) finishTransition:(CALayer*) showLayer hideLayer:(CALayer*) hideLayer {
    for(FLAnimation* animation in _hideAnimations) {
        [animation finishAnimation:hideLayer];
    }
    for(FLAnimation* animation in _showAnimations) {
        [animation finishAnimation:showLayer];
    }
}

- (void) prepareTransition:(CALayer*) showLayer hideLayer:(CALayer*) hideLayer {


//    if(viewToShow.superview == nil) {
//        [viewToHide.superview addSubview:viewToShow 
//                              positioned:NSWindowBelow 
//                              relativeTo:viewToHide];
//    }

    for(FLAnimation* animation in _hideAnimations) {
        [animation prepareAnimation:hideLayer];
    }

    for(FLAnimation* animation in _showAnimations) {
        [animation prepareAnimation:showLayer];
    }
}



@end

