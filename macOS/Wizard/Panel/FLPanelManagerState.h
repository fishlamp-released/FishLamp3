//
//  FLPanelManagerState.h
//  FishLampOSX
//
//  Created by Mike Fullerton on 5/2/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLModelObject.h"
#import "FLBroadcaster.h"

@interface FLPanelManagerState : FLModelObject {
@private
    id _selectedPanelIdentifier;
    id _selectedPanelSavedState;
}
@property (readwrite, strong, nonatomic) id selectedPanelIdentifier;
@property (readwrite, strong, nonatomic) id selectedPanelSavedState;

@end
