//
//  FLBreadcrumbBarViewController.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/15/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBreadcrumbBarViewController.h"
#import "FLBreadcrumbBarView.h"
#import "FLAttributedString.h"
#import "FLMoveAnimation.h"
#import "FLBarHighlightBackgoundLayer.h"
#import "SDKColor+FLMoreColors.h"

@interface FLBreadcrumbBarViewController ()
@end

@implementation FLBreadcrumbBarViewController

@synthesize delegate = _delegate;

#if FL_MRC
- (void) dealloc {
    [super dealloc];
}
#endif

- (FLBreadcrumbBarView*) breadcrumbView {
    return (FLBreadcrumbBarView*) self.view; 
}

- (void) awakeFromNib {
    [super awakeFromNib];
    self.breadcrumbView.delegate = self;
}

- (BOOL)acceptsFirstResponder {
    return NO;
}   

- (void) updateTitle:(FLNavigationTitle*) title withState:(FLNavigationTitleState) state {
    if(state.hidden != title.hidden) {
        title.hidden = state.hidden;
    }
    title.enabled = state.enabled;
    title.selected = state.selected;

}

- (void) updateNavigationTitlesAnimated:(BOOL) animated {
    
//    BOOL selected = NO;

    for(FLNavigationTitle* title in self.breadcrumbView.titles) {
        FLNavigationTitleState state = 
            [self.delegate titleNavigationController:self navigationTitleState:title];
    
        [self updateTitle:title withState:state];
        
//        if(state.selected) {
//            selected = YES;
//        }
    }
    
    [self.breadcrumbView updateLayout:animated];
}

- (void) addNavigationTitle:(FLNavigationTitle*) title {

    FLAssertStringIsNotEmpty(title.localizedTitle);
    FLAssertNotNil(title.identifier);
    [self.breadcrumbView addTitle:title];
    [self updateNavigationTitlesAnimated:NO];
    [self.delegate titleNavigationController:self didAddNavigationTitle:title];
    
    [self.view setNeedsDisplay:YES];
}

- (void) removeNavigationTitleForIdentifier:(id) identifier {

}
- (void) titleNavigationController:(FLBreadcrumbBarView*) view
           handleMouseMovedInTitle:(FLNavigationTitle*) title  
                           mouseIn:(BOOL) mouseIn {

    FLNavigationTitleState state = 
        [self.delegate titleNavigationController:self navigationTitleState:title];

    [self updateTitle:title withState:state];
}

- (void) titleNavigationController:(FLBreadcrumbBarView*) view 
            handleMouseDownInTitle:(FLNavigationTitle*) title {


    FLNavigationTitleState state = 
        [self.delegate titleNavigationController:self navigationTitleState:title];

    [self updateTitle:title withState:state];
            
    if(title.enabled && !title.selected) {
        [self.delegate titleNavigationController:self navigationTitleWasSelected:title];
    }
    
    [self updateNavigationTitlesAnimated:YES];
}

            

@end



