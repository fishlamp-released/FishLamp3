//
//  FLMouseTrackingView.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"
#import "FLCompatibility.h"

#import <AppKit/AppKit.h>

// TODO: move to OSX

@protocol FLMouseHandler <NSObject>
- (void) handleMouseMoved:(CGPoint) location mouseIn:(BOOL) mouseIn mouseDown:(BOOL) mouseDown;
- (void) handleMouseUpInside:(CGPoint) location;
@end

@interface FLMouseTrackingView : NSView<FLMouseHandler> {
@private
    NSTrackingArea* _trackingArea;
    BOOL _mouseIn;
    BOOL _mouseDown;
}

- (void) handleMouseMoved:(CGPoint) location mouseIn:(BOOL) mouseIn mouseDown:(BOOL) mouseDown;
- (void) handleMouseUpInside:(CGPoint) location;

@end