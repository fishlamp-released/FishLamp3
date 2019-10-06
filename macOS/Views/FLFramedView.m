//
//  FLFramedView.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFramedView.h"
#import "SDKColor+FLMoreColors.h"
#import "FLGeometry.h"

@implementation FLFramedView

@synthesize frameColor = _frameColor;
@synthesize backgroundColor = _backgroundColor;
@synthesize borderWidth = _borderWidth;

- (void) setDefaults {
    self.frameColor = [SDKColor gray85Color];
    self.backgroundColor = [SDKColor whiteColor];
    self.borderWidth = 1.0;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    [self setDefaults];
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_backgroundColor release];
    [_frameColor release];
    [super dealloc];
}
#endif

- (void)drawRect:(NSRect)dirtyRect {

    CGContextRef context = CGGetCurrentContext();

    [_backgroundColor setFill];
    NSRectFill(dirtyRect);

    CGRect bounds = NSRectToCGRect(self.bounds);
    bounds.origin.x += 0.5f;
    bounds.origin.y += 0.5f;
    bounds.size.width -= 1.0f;
    bounds.size.height -= 1.0f;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, bounds.origin.x, bounds.origin.y); //start point
    CGContextAddLineToPoint(context, CGRectGetRight(bounds), bounds.origin.y);
    CGContextAddLineToPoint(context, CGRectGetRight(bounds), CGRectGetBottom(bounds));
    CGContextAddLineToPoint(context, bounds.origin.x, CGRectGetBottom(bounds)); // end path
    CGContextClosePath(context); // close path

    [_frameColor set];
    CGContextSetLineWidth(context,self.borderWidth);
    CGContextStrokePath(context);
    
}

@end

@implementation FLGrayFilledFramedView

- (void) awakeFromNib {
    [super awakeFromNib];
    
    self.borderWidth = 2.0f;
    self.backgroundColor = [NSColor gray95Color];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth = 2.0f;
        self.backgroundColor = [NSColor gray95Color];
    }
    
    return self;
}

@end
