//
//  FLPanelWizard.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 4/17/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPanelManager.h"
#import "FLWizardNavigationViewController.h"
#import "NSWindowController+FLModalAdditions.h"

@class FLPanelViewController;

@interface FLPanelWizard : FLPanelManager<FLBreadcrumbBarViewControllerDelegate> {
@private
    IBOutlet FLWizardNavigationViewController* _navigationViewController;
}

@property (readonly, strong, nonatomic) FLWizardNavigationViewController* navigationViewController;

@end
