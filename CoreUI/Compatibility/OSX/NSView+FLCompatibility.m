//
//  NSView+FLCompatibility.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/23/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//


#if OSX
#import "NSView+FLCompatibility.h"

@implementation NSView (FLCompatibility)

FLSynthesizeAssociatedBOOLProperty(needsLayout, setNeedsLayout);

//- (void) setNeedsDisplay {
//    [self setNeedsDisplay:YES];
//}

- (void) insertSubview:(NSView*) view 
          belowSubview:(NSView*) subview {
    [self addSubview:view positioned:NSWindowBelow relativeTo:subview];
}

- (void) insertSubview:(NSView*) view 
          aboveSubview:(NSView*) subview {
    [self addSubview:view positioned:NSWindowAbove relativeTo:subview];
}

- (void) insertSubview:(NSView*) view 
               atIndex:(NSUInteger) atIndex {

    [self addSubview:view positioned:NSWindowAbove relativeTo:[self.subviews objectAtIndex:atIndex]];
}

- (void) bringSubviewToFront:(NSView*) view {
    id superView = [self superview]; 
    if (superView) {
        FLAutoreleaseObject(FLRetain(self));
        [self removeFromSuperview];
        [superView addSubview:self];
    }
}

- (void) bringToFront {
    [self.superview bringSubviewToFront:self];
}

- (void)sendToBack {
    id superView = [self superview]; 
    if (superView) {
        FLAutoreleaseObject(FLRetain(self));
        [self removeFromSuperview];
        [superView addSubview:self positioned:NSWindowBelow relativeTo:nil];
    }
}

- (void) layoutSubviews {
    for(NSView* view in self.subviews) {
        if([view respondsToSelector:@selector(layoutSubviews)]) {
            [view layoutSubviews];
        }
    }
}

@end

#endif