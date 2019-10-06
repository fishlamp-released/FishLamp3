//
//  NSView+FLCompatibility.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/23/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if OSX
#import <Cocoa/Cocoa.h>

@interface NSView (FLCompatility)
//- (void) setNeedsDisplay; // setNeedsDisplay:YES

// note that view layer doesn't work for POOPY in OSX because
// when a view becomes the responder it moves forward (I think)
- (void) bringSubviewToFront:(NSView*) view;
- (void) bringToFront;
- (void) sendToBack;
- (void) insertSubview:(NSView*) view belowSubview:(NSView*) subview;
- (void) insertSubview:(NSView*) view aboveSubview:(NSView*) subview;
- (void) insertSubview:(NSView*) view atIndex:(NSUInteger) atIndex;

- (void) layoutSubviews;
@end
#endif