//
//  FLWizardButtonViewController.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"
#import "FLPanelViewController.h"

@protocol FLWizardButtonViewControllerDelegate;
@interface FLWizardButtonViewController : NSViewController<FLPanelButtons> {
@private
    IBOutlet NSButton* _nextButton;
    IBOutlet NSButton* _backButton;
    IBOutlet NSButton* _otherButton;
    IBOutlet NSView* _contentView;
    
    __weak id<FLWizardButtonViewControllerDelegate> _delegate;
}
@property (readwrite, weak, nonatomic) id<FLWizardButtonViewControllerDelegate> delegate;
@property (readonly, strong, nonatomic) NSButton* nextButton;
@property (readonly, strong, nonatomic) NSButton* backButton;
@property (readonly, strong, nonatomic) NSButton* otherButton;
@property (readonly, strong, nonatomic) NSView* contentView;

- (void) updateButtons;

@end

@protocol FLWizardButtonViewControllerDelegate <NSObject>
- (void) wizardButtonViewControllerUpdateButtonStates:(FLWizardButtonViewController*) controller;
- (void) wizardButtonViewControllerRespondToNextButton:(FLWizardButtonViewController*) controller;
- (void) wizardButtonViewControllerRespondToBackButton:(FLWizardButtonViewController*) controller;
- (void) wizardButtonViewControllerRespondToOtherButton:(FLWizardButtonViewController*) controller;
@end
