//
//  FLCompatibleViewController.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#if 0

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

#import "FLCompatibleView+OSX.h"
#import "NSViewController+FLCompatibility.h"

@interface FLCompatibleViewController : NSViewController {
@private
    BOOL _viewLoaded;
    __weak NSViewController* _parentViewController;
    NSMutableArray* _childViewControllers;
}

- (void) viewDidLoad;
- (void) viewDidUnload;

- (void) viewWillLayoutSubviews;
- (void) viewDidLayoutSubviews;

- (void) viewWillDisappear:(BOOL) animated;
- (void) viewDidDisappear:(BOOL) animated;

- (void) viewWillAppear:(BOOL) animated;
- (void) viewDidAppear:(BOOL) animated;

- (void) didReceiveMemoryWarning;

- (void) viewControllerWillAppear;

@end



#endif
