//
//  FLLoginPanel.m
//  FishLamp
//
//  Created by Mike Fullerton on 12/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FLLoginPanel.h"
#import "FLKeychain.h"
#import "FLProgressPanel.h"
#import "NSViewController+FLErrorSheet.h"
#import "NSBundle+FLCurrentBundle.h"
#import "FLAuthenticationHandler.h"

@interface FLLoginPanel ()
- (void) updateNextButton;
- (IBAction) resetLogin:(id) sender;
- (IBAction) startLogin:(id) sender;
- (IBAction) passwordCheckboxToggled:(id) sender;
- (void) setNextResponderIfNeeded;
@end

@implementation FLLoginPanel

@synthesize authenticationHandler = _authenticationHandler;

- (id) init {
    return [self initWithNibName:@"FLLoginPanel" bundle:[FLBundleStack currentBundle]];
}

- (void) windowDidUpdate:(id) update {
    [self setNextResponderIfNeeded];
}

- (void) awakeFromNib {
    [super awakeFromNib];

    self.title = NSLocalizedString(@"Login", nil);
    self.prompt =  NSLocalizedString(@"Login to your account", nil);
    self.panelFillsView = NO;

// APPLE DOESN'T LIKE THE RESET PW LINK
// TODO: fix this

    _forgotPasswordButton.hidden = YES;
}

+ (id) loginPanel {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

#if FL_MRC
    [_authenticationHandler release];
    [super dealloc];
#endif
}

- (void) loadView {
    [super loadView];
    
    [self view];
    _userNameTextField.nextKeyView = _passwordEntryField;
    _passwordEntryField.nextKeyView = _userNameTextField;
}

- (void) setUserName:(NSString*) userName {
    [_userNameTextField setStringValue:FLEmptyStringOrString(userName)];
}

- (NSString *)userName {
	return [_userNameTextField stringValue];
}

- (void) setPassword:(NSString*) password {
    [_passwordEntryField setStringValue:FLEmptyStringOrString(password)];
}

- (NSString *)password {
	return [_passwordEntryField stringValue];
}

- (BOOL) savePasswordInKeychain {
    return [_savePasswordCheckBox integerValue] == 1;
}

- (void) setSavePasswordInKeychain:(BOOL) saveIt {
    [_savePasswordCheckBox setIntegerValue:saveIt];
}

- (BOOL) canLogin {
	return FLStringIsNotEmpty(self.userName) && FLStringIsNotEmpty(self.password);
}

- (void) updateNextButton {
    _loginButton.enabled = self.canLogin;
    self.canOpenNextPanel = _loginButton.isEnabled && [[self.authenticationHandler authenticatedEntity] isAuthenticated];
}

- (FLAuthenticationCredentials*) currentCredentials {
    return [FLAuthenticationCredentials authenticationCredentials:self.userName password:self.password];
}

- (void) updateCredentials {
    [self.authenticationHandler setAuthenticationCredentials:[self currentCredentials]];
}

- (void)controlTextDidChange:(NSNotification *)note {
    [self updateNextButton];
}

- (void)controlTextDidEndEditing:(NSNotification *) note {

    NSNumber *reason = [[note userInfo] objectForKey:@"NSTextMovement"];
    if ([reason intValue] == NSReturnTextMovement) {
        [self updateNextButton];

        //	leave time for text field to clean up repainting
        if(self.canLogin && !self.canOpenNextPanel) {
            
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [_loginButton performClick:self];
            });
        }
    }
}

- (void) setNextResponderIfNeeded {

    [self updateNextButton];

    if( [[NSApplication sharedApplication] keyWindow ] == self.view.window &&
        [self.view.window attachedSheet] == nil ) {

        id nextResponder = [self.view.window firstResponder];
        while(nextResponder) {
            if( nextResponder == _userNameTextField ||
                nextResponder == _passwordEntryField ) {
                return;
            }

            nextResponder = [nextResponder nextResponder];
        }

        if(FLStringIsEmpty(self.userName)) {
            [self.view.window makeFirstResponder:_userNameTextField];
        }
        else {
            [self.view.window makeFirstResponder:_passwordEntryField];
        }
    }
}

- (void) showEntryFields:(BOOL) animated completion:(dispatch_block_t) completion {

    if(self.isSelected) {
        completion = FLCopyWithAutorelease(completion);

        [self.panelManager showAlertView:self 
                      overViewController:self.alertViewController 
                          withTransition:nil 
                          completion:^{
                          
            [self setNextResponderIfNeeded];
            
            if(completion) {
                completion();
            }
        }];
    }
    self.alertViewController = nil;
}

- (void) progressPanelWasCancelled:(FLProgressPanel*) panel {
    [self.authenticationHandler cancelAuthentication];
    [self showEntryFields:YES completion:nil];
}

- (void) beginAuthenticating {

    [self updateCredentials];

    [self.authenticationHandler beginAuthenticating:^(FLPromisedResult result) {

        dispatch_async(dispatch_get_main_queue(), ^{
            if([result isError]) {
                [self showEntryFields:YES completion:^{
                    [self.delegate loginPanel:self authenticationFailed:result];
                }];
            }
            else {
                [self setCanOpenNextPanel:YES];
                [self.delegate loginPanelDidAuthenticate:self];
            }
        });
    }];
}

- (IBAction) startLogin:(id) sender {
    [self updateNextButton];

//    if(self.canOpenNextPanel) {
//        [self.delegate loginPanelDidAuthenticate:self];
//    }
//    else {

        FLProgressPanel* panel = [FLProgressPanel progressPanel];
        panel.delegate = self;
        [[panel view] setFrame:self.view.frame];
        [panel setProgressText:NSLocalizedString(@"Logging into your account…", nil)];
        
        self.alertViewController = panel;
        
        [self.panelManager showAlertView:self.alertViewController 
                      overViewController:self withTransition:nil 
                      completion:^{
            [self beginAuthenticating];
        }];
//    }
}

- (IBAction) resetLogin:(id) sender {
    // this is from the "forgot login" button
    
    [self.delegate loginPanelForgotPasswordButtonWasClicked:self];
}

- (void) loadCredentials {
    id<FLAuthenticationCredentials> credentials = [self.authenticationHandler authenticationCredentials];
    [self setUserName:credentials.userName];
    [self setPassword:credentials.password];
}

- (IBAction) passwordCheckboxToggled:(id) sender {
    [self.authenticationHandler setShouldSavePassword:self.savePasswordInKeychain];
}

- (void) respondToNextButton:(BOOL*) handledIt {
    if(self.canLogin) {
        [self updateCredentials];
    }
    else {
        *handledIt = YES; 
    }
}

- (void) panelDidAppear {
    [super panelDidAppear];
    [self updateNextButton];
    [self setNextResponderIfNeeded];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidUpdate:)
        name:NSWindowDidUpdateNotification object:nil];

}

- (void) panelWillAppear {
    [super panelWillAppear];
    _userNameTextField.stringValue = @"";
    _passwordEntryField.stringValue = @"";

    _passwordEntryField.delegate = self;
    _userNameTextField.delegate = self;

    [self setSavePasswordInKeychain:[self.authenticationHandler shouldSavePassword]];
    [self loadCredentials];
    [self updateNextButton];
}

- (void) panelWillDisappear {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidUpdateNotification object:nil];

    [self.view.window makeFirstResponder:nil];
    [super panelWillDisappear];
    [self updateCredentials];
}

- (void) panelDidDisappear {
    [super panelDidDisappear];
    
    _userNameTextField.stringValue = @"";
    _passwordEntryField.stringValue = @"";
    
    self.alertViewController = nil;
}

@end

