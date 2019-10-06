//
//  FLLinkTextField.h
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/28/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"

@interface FLLinkTextField : NSTextField {
@private
    BOOL _mouseDown;
    BOOL _mouseIn;
    NSTrackingRectTag _boundsTrackingTag;
    NSTrackingArea* _trackingArea;
}

@end
