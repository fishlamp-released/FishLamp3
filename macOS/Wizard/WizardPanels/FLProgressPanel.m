//
//  FLProgressPanel.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/28/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLProgressPanel.h"
#import "FLWizardViewController.h"
#import "NSBundle+FLCurrentBundle.h"

@interface FLProgressPanel ()

@end

@implementation FLProgressPanel

- (id) init {
    return [self initWithNibName:@"FLProgressPanel" bundle:[FLBundleStack currentBundle]];
}

+ (id) progressPanel {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [_progress startAnimation:self];
}

- (void) setProgressText:(NSString*) text {
    _textField.stringValue = text;
}

- (IBAction) cancelButtonWasPushed:(id) button {
    [self.delegate progressPanelWasCancelled:self];
}

@end
