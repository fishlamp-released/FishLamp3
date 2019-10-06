//
//  FLPanelManagerState.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 5/2/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPanelManagerState.h"

@implementation FLPanelManagerState

@synthesize selectedPanelIdentifier = _selectedPanelIdentifier;
@synthesize selectedPanelSavedState = _selectedPanelSavedState;

#if FL_MRC
- (void) dealloc {
	[_selectedPanelIdentifier release];
    [_selectedPanelSavedState release];
    [super dealloc];
}
#endif
@end
