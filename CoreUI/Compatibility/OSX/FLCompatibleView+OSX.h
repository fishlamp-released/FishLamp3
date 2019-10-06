//
//  FLView.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/6/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#if 0

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

#import "NSColor+FLCompatibility.h"
#import "NSView+FLCompatibility.h"

#if REFACTOR
// temp
typedef enum {
    UIViewContentModeScaleToFill,
    UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
    UIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
    UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
    UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
    UIViewContentModeTop,
    UIViewContentModeBottom,
    UIViewContentModeLeft,
    UIViewContentModeRight,
    UIViewContentModeTopLeft,
    UIViewContentModeTopRight,
    UIViewContentModeBottomLeft,
    UIViewContentModeBottomRight,
} UIViewContentMode;

typedef NSUInteger UIViewAnimationOptions;
#endif

@interface FLCompatibleView : NSView {
@private
//    NSColor* _backgroundColor;
//    BOOL _needsLayout;
}

// note this sets the color in the layer (if there is one)
@property (readwrite, strong, nonatomic) NSColor* backgroundColor;
@property (readwrite, assign, nonatomic) BOOL userInteractionEnabled;
@property (readwrite, assign, nonatomic) CGFloat alpha;

- (void) setNeedsLayout;    // calls setNeedsDisplay:YES
- (void) layoutIfNeeded;
@end


#endif