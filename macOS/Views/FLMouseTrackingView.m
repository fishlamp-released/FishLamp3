//
//  FLMouseTrackingView.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLMouseTrackingView.h"

@interface FLMouseTrackingView ()
@property (readwrite, strong, nonatomic) NSTrackingArea* trackingArea;
@end


@implementation FLMouseTrackingView 

@synthesize trackingArea = _trackingArea;

#if FL_MRC
- (void) dealloc {
    [_trackingArea release];
    [super dealloc];
}
#endif

- (void) setFrame:(NSRect) frame {
    [super setFrame:frame];
    
    if(self.trackingArea) {
        [self removeTrackingArea:self.trackingArea];
        self.trackingArea = nil;
    }
    
    NSTrackingAreaOptions trackingOptions =         NSTrackingMouseEnteredAndExited | 
                                                    NSTrackingMouseMoved | 
                                                    NSTrackingActiveAlways | 
                                                    NSTrackingAssumeInside |
                                                    NSTrackingEnabledDuringMouseDrag;
                                            
    _trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:trackingOptions
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void) handleMouseUpInside:(CGPoint) location {

}

- (void) handleMouseMoved:(CGPoint) location mouseIn:(BOOL) mouseIn mouseDown:(BOOL) mouseDown {

}

- (CGPoint) mouseUpdate:(NSEvent*) event {
    CGPoint location = NSPointToCGPoint([self convertPoint:[event locationInWindow] fromView:nil]);
    BOOL mouseIn = CGRectContainsPoint(NSRectToCGRect(self.bounds), location);
    if(mouseIn != _mouseIn) {
        _mouseIn = mouseIn;
    }
    
    [self handleMouseMoved:location mouseIn:_mouseIn mouseDown:_mouseDown];
        
    return location;
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseDown = YES;
    [self mouseUpdate:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _mouseDown = NO;
    CGPoint point = [self mouseUpdate:theEvent];

    if(_mouseIn) {
        [self handleMouseUpInside:point];
    }
}

- (void)mouseEntered:(NSEvent *)event  {
    [self mouseUpdate:event];
}

- (void) mouseDragged:(NSEvent *)event {
    [self mouseUpdate:event];
}

- (void)mouseExited:(NSEvent *)event {
    [self mouseUpdate:event];
}

- (void)mouseMoved:(NSEvent *)event {
    [self mouseUpdate:event];
}

@end
