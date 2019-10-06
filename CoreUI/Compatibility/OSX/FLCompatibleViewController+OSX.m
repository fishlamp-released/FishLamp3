//
//  FLCompatibleViewController.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#if 0 

#import "FLCompatibleViewController+OSX.h"

//@interface NSView (FLCompatibleInternal)
////@property (readwrite, assign, nonatomic, getter=isViewLoaded) BOOL viewLoaded;
////@property (readwrite, strong, nonatomic) NSArray *childViewControllers;
////@property (readwrite, assign, nonatomic) NSViewController* parentViewController;
//@end


@interface FLCompatibleViewController ()
@property (readwrite, assign, nonatomic, getter=isViewLoaded) BOOL viewLoaded;
@property (readwrite, strong, nonatomic) NSArray *childViewControllers;
@property (readwrite, assign, nonatomic) NSViewController* parentViewController;
@end

@implementation FLCompatibleViewController

@synthesize viewLoaded = _viewLoaded;
@synthesize parentViewController = _parentViewController;
@synthesize childViewControllers = _childViewControllers;

#if FL_MRC
- (void) dealloc {
	[_childViewControllers release];
	[super dealloc];
}
#endif

#pragma mark -- view layout

- (void) viewDidLayoutSubviews {
}

- (void) viewWillLayoutSubviews {
}


#pragma mark -- view appear/disappear

- (void) viewWillDisappear:(BOOL) animated {
}

- (void) viewDidDisappear:(BOOL) animated {
}

- (void) viewWillAppear:(BOOL) animated {
}

- (void) viewDidAppear:(BOOL) animated {
}

#pragma mark -- loading


- (void) viewDidLoad {
}

- (void) viewDidUnload {
}

- (void) viewWillUnload {
}
       

//- (void) unloadLoadedView {
//    if(self.isViewLoaded) { 
//        [self viewWillUnload];
//        UIView* theView = FLRetainWithAutorelease(self.view);
//        theView.viewController = nil;
//        self.viewLoaded = NO;
//        [self setView:nil];
//        [self viewDidUnload];
//        [self didUnloadViewForCompatibility:theView];
//    }
//}

- (void)didReceiveMemoryWarning {

}

//- (void) setViewLoaded {
//    if(!self.isViewLoaded){
//        UIView* theView = self.view;
//        if(theView) {
//            theView.viewController = self;
//            self.viewLoaded = YES;
//            [self viewDidLoad];
//            [self didLoadViewForCompatibility:theView];
//        }
//    }
//}

#pragma mark -- transitions

- (NSViewController*) presentedViewController {
    return nil;
}

- (NSViewController*) presentingViewController {
    return nil;
}

- (BOOL)isBeingPresented {
    return NO;
}

- (BOOL)isBeingDismissed {
    return NO;
}

- (BOOL)isMovingToParentViewController {
    return NO;
}

- (BOOL)isMovingFromParentViewController {
    return NO;
}

#if REFACTOR
- (void)transitionFromViewController:(NSViewController *)fromViewController
                    toViewController:(NSViewController *)toViewController
                            duration:(NSTimeInterval)duration
                             options:(UIViewAnimationOptions)options
                          animations:(void (^)(void))animations
                          completion:(void (^)(BOOL finished))completion {
    
}
#endif

- (void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated {

}

- (void)endAppearanceTransition {
}

- (void)presentViewController:(NSViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^)(void))completion {
    
}

- (void)hideViewController:(BOOL)flag
                           completion: (void (^)(void))completion {
    
}

- (void) viewControllerWillAppear {

}

#pragma mark -- swizzled for compatibility

- (void) setView:(NSView*) aView {
    
    if(self.isViewLoaded) {
        [self viewWillUnload];
    }

    [super setView:aView];

    if(self.isViewLoaded) {
        self.viewLoaded = NO;
        [self viewDidUnload];
    }

    if(aView) {
        self.viewLoaded = YES;
        [self viewDidLoad];
    }
}

//- (void) compatibleLoadView {
//    [self viewWillLoad];
//    [self compatibleLoadView];
//    self.viewLoaded = YES;
//    [self viewDidLoad];
//}

//+ (void) initUIKitCompatibility {
////    FLSwizzleInstanceMethod([NSViewController class], @selector(compatibleLoadView), @selector(loadView));
//    FLSwizzleInstanceMethod([UIViewController class], @selector(compatibleSetView:), @selector(setView:));
//}



@end

#endif
