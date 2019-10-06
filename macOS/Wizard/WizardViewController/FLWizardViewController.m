//
//  FLWizardViewController.m
//  FishLamp
//
//  Created by Mike Fullerton on 12/4/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FLWizardViewController.h"
#import "FLAnimation.h"
#import "FLFadeAnimation.h"
#import "FLMoveAnimation.h"
#import "FLPanelViewController.h"
#import "FLWizardStyleViewTransition.h"
#import "NSBundle+FLCurrentBundle.h"

#import "FLNetworkActivity.h"

@interface FLWizardViewController ()
@end

@implementation FLWizardViewController

@synthesize buttonViewController = _buttonViewController;
@synthesize headerViewController = _headerViewController;

- (id) init {
    return [self initWithNibName:@"FLWizardViewController" bundle:[FLBundleStack currentBundle]];
}

+ (id) wizardViewController {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) updateButtonEnabledStates:(BOOL) animated {
    [self.buttonViewController updateButtons];
    [self.navigationViewController updateNavigationTitlesAnimated:animated];
}

- (void) showPanelsInWindow:(NSWindow*) window {
    [super showPanelsInWindow:window];
}


- (void) networkActivityDidStart:(FLNetworkActivity*) networkActivity {
    FLAssertNotNil(_progressView);
    FLAssert([NSThread isMainThread]);

    [_progressView startAnimation:self];
}

- (void) networkActivityDidStop:(FLNetworkActivity*) networkActivity {
    FLAssertNotNil(_progressView);
    FLAssert([NSThread isMainThread]);

    [_progressView stopAnimation:self];
}

- (void) awakeFromNib {
    [super awakeFromNib];

    if(!self.buttonViewController.delegate) {
        self.buttonViewController.delegate = self;

        [[FLGlobalNetworkActivity instance] addListener:self sendEventsOnMainThread:YES];

        [self addPanelArea:_headerViewController];
        [self addPanelArea:_buttonViewController];
    }
}

- (void)dealloc {
	[[FLGlobalNetworkActivity instance] removeListener:self];
#if FL_MRC
	[super dealloc];
#endif
}

- (void) removePanel:(FLPanelViewController*) panel {
    [self removePanel:panel];
    [self updateButtonEnabledStates:NO];
}

#pragma mark button view controller delegate

- (void) wizardButtonViewControllerRespondToNextButton:(FLWizardButtonViewController*) controller {
    BOOL handled = NO;
    [self.selectedPanel respondToNextButton:&handled];

    if(!handled) {
        [self selectNextPanelAnimated:YES completion:nil];
    }
}

- (void) wizardButtonViewControllerRespondToBackButton:(FLWizardButtonViewController*) controller {
    BOOL handled = NO;
    [self.selectedPanel respondToBackButton:&handled];

    if(!handled) {
        [self selectPreviousPanelAnimated:YES completion:nil];
    }
}

- (void) wizardButtonViewControllerRespondToOtherButton:(FLWizardButtonViewController*) controller {
    BOOL handled = NO;
    [self.selectedPanel respondToOtherButton:&handled];
}

- (void) wizardButtonViewControllerUpdateButtonStates:(FLWizardButtonViewController*) controller {
    
    BOOL backEnabled = !self.isFirstPanelSelected;

    BOOL nextEnabled = [self selectedPanel].canOpenNextPanel && ![self isLastPanelSelected];

    if(backEnabled != self.buttonViewController.backButton.isEnabled) {
        self.buttonViewController.backButton.enabled = backEnabled;
    }
    
    if(nextEnabled != self.buttonViewController.nextButton.isEnabled) {
        self.buttonViewController.nextButton.enabled = nextEnabled;
        
        if(nextEnabled) {
            [self.view.window setDefaultButtonCell:[self.buttonViewController.nextButton cell]];
        }
    }
}

- (void) setLogoImage:(NSImage*) image {
    _logoImageView.image = image;
}

#pragma mark panel manager 

- (void) panelStateDidChange:(FLPanelViewController*) panel {
    [super panelStateDidChange:panel];
    [self updateButtonEnabledStates:YES];
}

- (void) didAddPanel:(FLPanelViewController*) panel {
    panel.buttons = self.buttonViewController;
    panel.header = self.headerViewController;
    [super didAddPanel:panel];
}
       
- (void)  willShowPanel:(FLPanelViewController*) toShow {
    self.buttonViewController.nextButton.enabled = NO;
    self.buttonViewController.backButton.enabled = NO;
    self.buttonViewController.otherButton.hidden = YES;
    [self.headerViewController setPrompt:toShow.prompt animated:YES];
    [super willShowPanel:toShow];
}

- (BOOL) canShowNextPanelWithIdentifier:(id) identifier {

    return YES;
}

@end

