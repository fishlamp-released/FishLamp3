//
//  FLButtonCell.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 3/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLButtonCell.h"
#import "FLGeometry.h"

@implementation FLButtonCell 

- (float) vertAdjustment {
    return 0;
}
- (float) horizAdjustment {
    return 0;
}

- (NSRect)titleRectForBounds:(NSRect)bounds {

    float horizontalAdjust = self.horizAdjustment;

    NSRect titleFrame = [super titleRectForBounds:bounds];
    
    bounds.origin.x = titleFrame.origin.x;
    bounds.size.width -= (titleFrame.origin.x + horizontalAdjust);
    
    NSRect textRect = [self.title boundingRectWithSize:bounds.size
                                               options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin 
                                            attributes:nil];
       
    textRect.origin = bounds.origin;
    textRect.origin.x += horizontalAdjust;

    if (textRect.size.height < bounds.size.height) {
        textRect = NSRectCenterRectInRectVertically(bounds, textRect);
        textRect.origin.y += self.vertAdjustment;
        
        return NSRectOptimizedForViewSize(textRect);
    }
    return titleFrame;
}

//- (NSRect)drawTitle:(NSAttributedString*)title withFrame:(NSRect)frame inView:(NSMatrix*)controlView {
//
//    NSInteger row = 0;
//    NSInteger col = 0;
//    if([controlView getRow:&row column:&col ofCell:self]) {
//        NSRect cellFrame = [controlView cellFrameAtRow:row column:0];
//        frame = NSRectCenterRectInRectVertically(cellFrame, frame);
//    }
//
//
//    return [super drawTitle:title withFrame:frame inView:controlView];
//}


@end

@implementation FLRadioButtonCell

- (float) vertAdjustment {
    return 2.0;
}

- (float) horizAdjustment {
    return 4.0;
}

@end

@implementation FLSwitchButtonCell

- (float) vertAdjustment {
    return 1.0;
}

- (float) horizAdjustment {
    return 1.0;
}


@end
