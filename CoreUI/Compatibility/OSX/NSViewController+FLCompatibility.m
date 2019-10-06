//
//  NSViewController+FLCompatibility.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/23/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if OSX

#import "NSViewController+FLCompatibility.h"

@implementation NSViewController (FLCompatibleViewController)

#pragma mark -- child view controllers

FLSynthesizeAssociatedProperty(FLAssociationPolicyAssignNonatomic, parentViewController, setParentViewController, NSViewController*);
FLSynthesizeAssociatedProperty(FLAssociationPolicyRetainNonatomic, childViewControllers, setChildViewControllers, NSArray*);
@dynamic viewLoaded;

- (void) addChildViewController:(NSViewController*) viewController {
    
    NSMutableArray* children = (NSMutableArray*) self.childViewControllers;
    if(!children) {
        children = [NSMutableArray array];
        self.childViewControllers = children;
    }
    
    [viewController removeFromParentViewController];
    
    [viewController willMoveToParentViewController:self];
    [children addObject:viewController];
    viewController.parentViewController = self;
   [self didMoveToParentViewController:viewController];
}

- (void) removeViewController:(NSViewController*) viewController {
    if(viewController.parentViewController == self) {
        [viewController willMoveToParentViewController:nil];
        
        NSMutableArray* children = (NSMutableArray*) self.childViewControllers;
        [children removeObject:viewController];

        viewController.parentViewController = nil;
        [self didMoveToParentViewController:nil];
    }
}

- (void) removeFromParentViewController {
    if(self.parentViewController) {
        [self.parentViewController removeViewController:self];
    }
}

- (void)willMoveToParentViewController:(NSViewController *)parent {
}

- (void)didMoveToParentViewController:(NSViewController *)parent {
}

- (BOOL) isViewLoaded {
    return [self view] != nil; // of course this always loads the view. whatever osx, whatever.
}

@end

#endif
