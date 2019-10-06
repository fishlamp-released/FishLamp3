//
//  FLBarHighlightBackgound.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBarHighlightBackgoundLayer.h"
#import "FLColorModule.h"
#import "FLGeometry.h"

@implementation FLBarHighlightBackgoundLayer

+ (id) layer {
    return FLAutorelease([[[self class] alloc] init]);
}

@synthesize lineColor = _lineColor;

#if FL_MRC
- (void) dealloc {
    [_lineColor release];
    [super dealloc];
}
#endif

#define ArrowWidth 10

- (void)drawInContext:(CGContextRef) currentContext {
    
    [super drawInContext:currentContext];
    
    if(!_lineColor) {
        self.lineColor = [NSColor blackColor];
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectInset(self.bounds, 0.5, 0.5);
    CGPathMoveToPoint(path, nil, bounds.origin.x, CGRectGetBottom(bounds));
    CGPathAddLineToPoint(path, nil, CGRectGetRight(bounds)- ArrowWidth, CGRectGetBottom(bounds));
    CGPathAddLineToPoint(path, nil, CGRectGetRight(bounds), CGRectGetBottom(bounds) - (bounds.size.height / 2.0f));
    CGPathAddLineToPoint(path, nil, CGRectGetRight(bounds)- ArrowWidth, bounds.origin.y);
    CGPathAddLineToPoint(path, nil, bounds.origin.x, bounds.origin.y);
    CGPathAddLineToPoint(path, nil, bounds.origin.x, CGRectGetBottom(bounds));
	CGPathCloseSubpath(path);

    CGColorRef fillColor = [[NSColor whiteColor] copyCGColorRef];
    CGColorRef strokeColor = [_lineColor copyCGColorRef];
    
    CGContextAddPath(currentContext, path);
    CGContextSetFillColorWithColor(currentContext, fillColor);
    CGContextFillPath(currentContext);
    CGContextAddPath(currentContext, path);

    CGContextSetLineWidth(currentContext,1.0f);
    CGContextSetStrokeColorWithColor(currentContext, strokeColor);
    CGContextStrokePath(currentContext);
    
    CFRelease(path);
    CFRelease(fillColor);
    CFRelease(strokeColor);
}


@end
