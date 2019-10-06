//
//  FLWizardHeaderViewController.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"
#import "FLPanelViewController.h"

@interface FLWizardHeaderViewController : NSViewController<FLPanelHeader> {
@private
    IBOutlet NSTextField* _titleView;
    IBOutlet NSView* _logoView;
    IBOutlet NSButton* _logoutButton;
    IBOutlet NSTextField* _welcomeText;
}

@property (readonly, strong, nonatomic) NSTextField* promptTextField;

- (void) setPrompt:(NSString*) title animated:(BOOL) animated;
- (void) setTextNextToLogoutButton:(NSString*) welcomeText;

@end
