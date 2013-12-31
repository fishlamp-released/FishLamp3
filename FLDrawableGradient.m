//
//  FLGradientDrawing.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 12/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDrawableGradient.h"
#import "FLGeometry.h"
#import "FLCompatibility.h"

@implementation FLDrawableGradient

@synthesize colorRange = _colorRange;

- (id) initWithColorRange:(FLColorRange*) colorRange {
    self = [super init];
    if(self) {
        self.colorRange = colorRange;
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_colorRange release];
    [super dealloc];
}
#endif

- (void) drawRect:(CGRect) drawRect
        withFrame:(CGRect) frame 
         inParent:(id) inParent
drawEnclosedBlock:(void (^)(void)) drawEnclosedBlock {

return;
#if IOS
	CGContextRef context = CGGetCurrentContext();
	CGContextSaveGState(context);

	FLColorRangeColorValues colors = _colorRange.decimalColorRangeValues;
    
//    CGFloat alpha = self.alpha;

	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colorArray[] = {
		colors.startColor.red, colors.startColor.green, colors.startColor.blue, colors.startColor.alpha,
		colors.endColor.red, colors.endColor.green, colors.endColor.blue, colors.endColor.alpha,
	};
    
	CGGradientRef	gradient = CGGradientCreateWithColorComponents(rgb, colorArray, NULL, sizeof(colorArray)/(sizeof(colorArray[0])*4));
	CGColorSpaceRelease(rgb);	 
	
    CGContextClipToRect(context, frame);
	CGContextDrawLinearGradient(context, gradient, 
		frame.origin, 
		CGPointMake(frame.origin.x, CGRectGetBottom(frame)),
		0);
    
    if(drawEnclosedBlock) {
        drawEnclosedBlock();
    }
    
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
#else 

//    NSColor* startColor = [_colorRange startColor];
//    NSColor* endColor = [_colorRange endColor];

#if __MAC_10_8

    CGContextRef context = CGGetCurrentContext();
    CGContextSaveGState(context);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = {0.0, 1.0};

    NSMutableArray *colors = [NSMutableArray arrayWithObjects:
        (id)[[SDKColor darkGrayColor] CGColor],
        (id)[[SDKColor lightGrayColor] CGColor],
        nil];
    
//    NSMutableArray *colors = [NSMutableArray arrayWithObjects:
//        (id)[[_colorRange endColor] CGColor],
//        (id)[[_colorRange startColor] CGColor],
//        nil];

    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, FLBridge(CFArrayRef, colors), locations);
    CGColorSpaceRelease(colorSpace);  // Release owned Core Foundation object.
    
//    CGPoint startPoint = CGPointMake(0.0, 0.0);
//    CGPoint endPoint = CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame));
//    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,
//                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);

    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint  endPoint = CGRectGetBottomLeft(frame);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0); 
//                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);


//#if IOS
//	CGContextDrawLinearGradient(context, gradient, 
//		frame.origin, 
//		CGPointMake(frame.origin.x, FLRectGetBottom(frame)),
//		0);
//#else
//	CGContextDrawLinearGradient(context, gradient, 
//        FLRectGetTopLeft(frame),
//        FLRectGetBottomLeft(frame),
//		kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
//#endif        

    CGGradientRelease(gradient);  // Release owned Core Foundation object.

    CGContextRestoreGState(context);
#endif

#endif
}


@end
