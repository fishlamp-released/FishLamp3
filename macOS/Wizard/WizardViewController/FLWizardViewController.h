//
//  FLWizardViewController.h
//  FishLamp
//
//  Created by Mike Fullerton on 12/4/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"
#import "FLPanelWizard.h"

#import "FLWizardHeaderViewController.h"
#import "FLWizardButtonViewController.h"
#import "FLSpinningProgressView.h"
//

@interface FLWizardViewController : FLPanelWizard<FLWizardButtonViewControllerDelegate> {
@private
    IBOutlet FLWizardHeaderViewController* _headerViewController;
    IBOutlet FLWizardButtonViewController* _buttonViewController;
    
    IBOutlet FLSpinningProgressView* _progressView;
    
    IBOutlet NSImageView* _logoImageView;
}

// views
@property (readonly, strong, nonatomic) FLWizardHeaderViewController* headerViewController;
@property (readonly, strong, nonatomic) FLWizardButtonViewController* buttonViewController;

+ (id) wizardViewController;

- (void) setLogoImage:(NSImage*) image;

- (BOOL) canShowNextPanelWithIdentifier:(id) identifier;

@end

