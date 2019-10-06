//
//  NSViewController+FLCompatibility.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/23/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if OSX
#import <Cocoa/Cocoa.h>

@interface NSViewController (FLCompatibleViewController)

@property (readwrite, strong, nonatomic) NSArray *childViewControllers;
@property (readwrite, assign, nonatomic) NSViewController* parentViewController;

// this pretty much returns YES on OSX
@property (readwrite, assign, nonatomic, getter=isViewLoaded) BOOL viewLoaded;

- (void) addChildViewController:(NSViewController*) viewController;
- (void) removeFromParentViewController;
- (void) willMoveToParentViewController:(NSViewController *)parent;
- (void) didMoveToParentViewController:(NSViewController *)parent;

@end
#endif