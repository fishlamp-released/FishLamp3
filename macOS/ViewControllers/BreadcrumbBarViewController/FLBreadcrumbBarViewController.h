//
//  FLBreadcrumbBarViewController.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/15/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"

#import "FLBreadcrumbBarView.h"
#import "FLNavigationTitle.h"

@protocol FLBreadcrumbBarViewControllerDelegate;

@interface FLBreadcrumbBarViewController : NSViewController<FLBreadcrumbBarViewDelegate> {
@private
    __weak id<FLBreadcrumbBarViewControllerDelegate> _delegate;
}

@property (readwrite, weak, nonatomic) id<FLBreadcrumbBarViewControllerDelegate> delegate;

- (void) addNavigationTitle:(FLNavigationTitle*) title;
- (void) removeNavigationTitleForIdentifier:(id) identifier;

- (void) updateNavigationTitlesAnimated:(BOOL) animated;

@end

typedef struct {
    BOOL selected;
    BOOL hidden;
    BOOL enabled;
} FLNavigationTitleState;

NS_INLINE
FLNavigationTitleState FLNavigationTitleStateMake(BOOL selected, BOOL hidden, BOOL enabled) {
    FLNavigationTitleState state =  { selected, hidden, enabled };
    return state;
}

@protocol FLBreadcrumbBarViewControllerDelegate <NSObject>

- (FLNavigationTitleState) titleNavigationController:(FLBreadcrumbBarViewController*) controller 
                                navigationTitleState:(FLNavigationTitle*) title;

- (void) titleNavigationController:(FLBreadcrumbBarViewController*) controller 
         navigationTitleWasSelected:(FLNavigationTitle*) title;

- (void) titleNavigationController:(FLBreadcrumbBarViewController*) controller 
             didAddNavigationTitle:(FLNavigationTitle*) title;

@end

