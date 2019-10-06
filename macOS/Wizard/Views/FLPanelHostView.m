//
//  FLPanelHostView.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/15/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPanelHostView.h"

@implementation FLPanelHostView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = NO;
    }
    
    return self;
}

- (NSRect) subviewFrame {
    NSRect bounds = self.bounds;
    bounds.origin = NSMakePoint(1,1);
    bounds.size.width -= 2;
    bounds.size.height -= 2;
    return bounds;
} 

- (void) didAddSubview:(NSView *)subview {
    subview.frame = self.subviewFrame;
    [super didAddSubview:subview];
}

- (void) setFrame:(NSRect) frame {
    [super setFrame:frame];
    for(NSView* view in self.subviews) {
        view.frame = self.subviewFrame;
    }
}


@end
