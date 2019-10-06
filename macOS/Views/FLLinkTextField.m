//
//  FLLinkTextField.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/28/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLLinkTextField.h"
#import "FLAttributedString.h"
#import "FLColorModule.h"

@interface FLLinkTextField ()
@property (readwrite, strong, nonatomic) NSTrackingArea* trackingArea;
@end

@implementation FLLinkTextField

@synthesize trackingArea = _trackingArea;

#if FL_MRC
- (void) dealloc {
    [_trackingArea release];
    [super dealloc];
}
#endif


- (NSColor*) enabledColor {
    return [NSColor colorWithRGBRed:203 green:102 blue:10 alpha:1.0];
}

- (void) updateText {
    NSRange range = self.attributedStringValue.entireRange;
    NSMutableDictionary* attr = FLMutableCopyWithAutorelease([[self attributedStringValue] attributesAtIndex:0 effectiveRange:&range]);
    
    [attr setObject:[NSNumber numberWithBool:_mouseIn] forKey:NSUnderlineStyleAttributeName];

    if(_mouseDown && _mouseIn) {
        [attr setObject:[NSColor grayColor] forKey:NSForegroundColorAttributeName];
    }
    else {
        [attr setObject:[self enabledColor] forKey:NSForegroundColorAttributeName];
    }
    
    
    NSAttributedString* newString = FLAutorelease([[NSAttributedString alloc] initWithString:self.stringValue attributes:attr]);
    
    [self setAttributedStringValue:newString];
    [self setNeedsDisplay:YES];

}

- (void) awakeFromNib {
    [super awakeFromNib];

    [self updateTracking];
    [self updateText];
}

- (void) updateTracking {
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

    [self discardCursorRects];
	[self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
}

- (void) setFrame:(NSRect) frame {
    [super setFrame:frame];
    [self updateTracking];
}

- (void) handleMouseUpInside:(CGPoint) location {
    [self performClick:self];
}

- (void) handleMouseMoved:(CGPoint) location mouseIn:(BOOL) mouseIn mouseDown:(BOOL) mouseDown {
    [self updateText];
    [self setNeedsDisplay:YES];
}

- (CGPoint) mouseUpdate:(NSEvent*) event {
    CGPoint location = NSPointToCGPoint([self convertPoint:[event locationInWindow] fromView:nil]);
    _mouseIn = CGRectContainsPoint(NSRectToCGRect(self.bounds), location);

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


//- (void)mouseUp:(NSEvent *)mouseEvent {
//    _mouseDown = NO;
//    [self updateText];
//
//    if(_mouseIn) {
//        [self performClick:self];
//    }
//}
//
//- (void)mouseDown:(NSEvent *)theEvent  {
//    _mouseDown = YES;
//    [self updateText];
//}
//
//- (void)mouseEntered:(NSEvent *)theEvent {
//    _mouseIn = YES;
//    
//    [self updateText];
//    
//    [self setNeedsDisplay:YES];
//}
//
//- (void)mouseExited:(NSEvent *)theEvent {
//    _mouseIn = NO;
//
//    [self updateText];
//
//    [self setNeedsDisplay:YES];
//}
//
//- (void)viewWillMoveToWindow:(NSWindow*) window {
//    
//    if(!window) {
//        [self removeTrackingTags];
//    }
//    else {
//        [self updateBoundsTrackingTag];
//    }
//    
//    [super viewWillMoveToWindow:window];
//}

//- (void)removeTrackingTags {
//    if(_boundsTrackingTag) {
//        [self removeTrackingRect:_boundsTrackingTag];
//        _boundsTrackingTag = 0;
//    }
//}
//
//- (void) dealloc {
//    [self removeTrackingTags];
//#if FL_MRC
//	[super dealloc];
//#endif
//}

//- (void)updateBoundsTrackingTag {
//    [self removeTrackingTags];
//    
//    NSPoint loc = [self convertPoint:[[self window] mouseLocationOutsideOfEventStream] fromView:nil];
//   
//    BOOL inside = ([self hitTest:loc] == self);
//   
//    if (inside) {
//        [[self window] makeFirstResponder:self]; // if the view accepts first responder status
//    }
//   
//   _boundsTrackingTag = [self addTrackingRect:[self visibleRect] owner:self userData:nil assumeInside:inside];
//}

//- (BOOL)acceptsFirstResponder { 
//    return YES;
//} 
//
//- (BOOL)becomeFirstResponder {
//    return YES;
//}

//- (void)resetCursorRects {
//	[self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
//    [self updateBoundsTrackingTag];
//}

//- (void)mouseMoved:(NSEvent *)theEvent {
//}
