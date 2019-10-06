//
//  FLLoginPanel.h
//  FishLamp
//
//  Created by Mike Fullerton on 12/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"
#import "FLPanelViewController.h"
#import "FLWizardViewController.h"
#import "FLProgressPanel.h"
#import "FLAuthenticationCredentials.h"
#import "FishLampAsync.h"
#import "FLLinkTextField.h"

@protocol FLLoginPanelDelegate;
@protocol FLAuthenticationHandler;

@interface FLLoginPanel : FLPanelViewController<NSTextFieldDelegate, FLProgressPanelDelegate>  {
@private
    IBOutlet NSTextField* _userNameTextField;
    IBOutlet NSSecureTextField* _passwordEntryField;
    IBOutlet NSButton* _savePasswordCheckBox;
    IBOutlet FLLinkTextField* _forgotPasswordButton;
    IBOutlet NSButton* _loginButton;
    id<FLAuthenticationHandler> _authenticationHandler;
}
+ (id) loginPanel;
@property (readwrite, strong, nonatomic) id<FLAuthenticationHandler> authenticationHandler;
@end

@protocol FLLoginPanelDelegate <NSObject>
- (void) loginPanelForgotPasswordButtonWasClicked:(FLLoginPanel*) panel;
- (void) loginPanel:(FLLoginPanel*) panel authenticationFailed:(NSError*) error;
- (void) loginPanelDidAuthenticate:(FLLoginPanel*) panel;
@end

