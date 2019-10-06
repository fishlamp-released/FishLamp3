//
//  NSTextView+FLTextWrapping.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 6/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "NSTextView+FLTextWrapping.h"

@implementation NSTextView (FLTextWrapping)
- (void) setWrappingDisabled {
    NSSize bigSize = NSMakeSize(FLT_MAX, FLT_MAX);
    
    [[self enclosingScrollView] setHasHorizontalScroller:YES];
    [self setHorizontallyResizable:YES];
    [self setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    
    [[self textContainer] setContainerSize:bigSize];
    [[self textContainer] setWidthTracksTextView:NO];
}
@end
