//
//  FLDrawingUtils.m
//  FishLamp-iOS
//
//  Created by Mike Fullerton on 5/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDrawingUtils.h"
#import "FLCoreFoundation.h"

void FLDrawLinearGradient(CGContextRef context, 
    CGRect rect, 
    CGColorRef startColor, 
    CGColorRef endColor) {

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat locations[] = { 0.0, 1.0 };
	
	NSArray *colors = [NSArray arrayWithObjects:FLBridge(id, startColor), FLBridge(id, endColor), nil];
	
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, FLBridge(CFArrayRef, colors), locations);
	
	CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
	CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
	
	CGContextSaveGState(context);
	CGContextAddRect(context, rect);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	CGContextRestoreGState(context);
	
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
}

void FLDrawLine(CGContextRef context, FLLine_t line) {
	CGContextSaveGState(context);
	CGContextSetLineCap(context, line.cap); // kCGLineCapSquare
	CGContextSetStrokeColorWithColor(context, line.color);
	CGContextSetLineWidth(context, line.width);
	CGContextMoveToPoint(context, line.startPoint.x + 0.5, line.startPoint.y + 0.5);
	CGContextAddLineToPoint(context, line.endPoint.x + 0.5, line.endPoint.y + 0.5);
	CGContextStrokePath(context);
	CGContextRestoreGState(context);		
}