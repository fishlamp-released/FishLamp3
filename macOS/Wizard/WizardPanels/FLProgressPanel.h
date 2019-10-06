//
//  FLProgressPanel.h
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/28/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPanelViewController.h"

@interface FLProgressPanel : FLPanelViewController {
@private
    IBOutlet NSProgressIndicator* _progress;
    IBOutlet NSButton* _cancelButton;
    IBOutlet NSTextField* _textField;
}

+ (id) progressPanel;

- (IBAction) cancelButtonWasPushed:(id) button;

- (void) setProgressText:(NSString*) text;

@end

@protocol FLProgressPanelDelegate <NSObject>
- (void) progressPanelWasCancelled:(FLProgressPanel*) panel;
@end