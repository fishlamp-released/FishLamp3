//
//  FLDrawableShape.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 12/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDrawableShape.h"
#import "FLPathUtilities.h"

@implementation FLDrawableShape

@synthesize edgeInsetColor = _edgeInsetColor;
@synthesize edgeInset = _edgeInset;
@synthesize cornerRadius = _cornerRadius;
@synthesize borderGradient = _borderGradient;
@synthesize backgroundColor = _backgroundColor;

-(void) createPathForShapeInRect:(CGMutablePathRef) path rect:(CGRect) rect {
}

- (id) init {
    self = [super init];
    if(self) {
        _edgeInset = 0.0f;
        _cornerRadius = 1.0f;

#if 0		
        // the border gradient is NOT a subwidget because we don't want it to be drawn
        // when we call [super drawRect], we're rendering it ourselves for the fram
		_borderGradient = [[FLDrawableGradient alloc] init];
		[_borderGradient setColorRange:[FLColorRange colorRange:[SDKColor blackColor] endColor:[SDKColor grayColor]]];
#endif        

    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_backgroundColor release];
    [_borderGradient release];
    [super dealloc];
}
#endif

- (void) drawBackgoundInRect:(CGRect) shapeRect withColor:(SDKColor*) inColor {

    CGContextRef context = CGGetCurrentContext();
    CGContextSaveGState(context);
    
    if(inColor) {
        FLColorValues color = inColor.decimalColorValues;
        
        CGContextSetRGBFillColor(context, color.red, color.green, color.blue, color.alpha);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineWidth(context, 1.0);
        CGContextSetRGBStrokeColor(context, color.red, color.green, color.blue, color.alpha);
    
        CGMutablePathRef path = CGPathCreateMutable();
        [self createPathForShapeInRect:path rect:shapeRect];
        CGContextAddPath(context, path);
        CGContextFillPath(context);
        CGContextStrokePath(context);
        CGPathRelease(path);
    } 
    else {
        CGMutablePathRef path = CGPathCreateMutable();
        [self createPathForShapeInRect:path rect:shapeRect];
        CGContextAddPath(context, path);
        CGContextClearRect(context, shapeRect);
        CGPathRelease(path);
    }

    CGContextRestoreGState(context);
}

//- (void) drawInsetInRect:(CGRect) shapeRect {
//
//    CGContextRef context = CGGetCurrentContext();
//    CGContextSaveGState(context);
//    
//    if(_backgroundColor) {
//        FLColorValues color = _backgroundColor.decimalColorValues;
//        
//        CGContextSetRGBFillColor(context, color.red, color.green, color.blue, color.alpha);
//        CGContextSetLineJoin(context, kCGLineJoinRound);
//        CGContextSetLineWidth(context, 1.0);
//        CGContextSetRGBStrokeColor(context, color.red, color.green, color.blue, color.alpha);
//    
//        CGMutablePathRef path = CGPathCreateMutable();
//        [self createPathForShapeInRect:path rect:shapeRect];
//        CGContextAddPath(context, path);
//        CGContextFillPath(context);
//        CGContextStrokePath(context);
//        CGPathRelease(path);
//    } 
//    else {
//        CGMutablePathRef path = CGPathCreateMutable();
//        [self createPathForShapeInRect:path rect:shapeRect];
//        CGContextAddPath(context, path);
//        CGContextClearRect(context, shapeRect);
//        CGPathRelease(path);
//    }
//
//    CGContextRestoreGState(context);
//
//}


- (void) drawRect:(CGRect) drawRect 
        withFrame:(CGRect) frame 
         inParent:(id) parent
drawEnclosedBlock:(void (^)(void)) drawEnclosedBlock {
	
    CGRect shapeRect = frame; //CGRectInset(frame, 1, 1);
    
    if(_edgeInset > 0) {
        [self drawBackgoundInRect:shapeRect withColor:_edgeInsetColor];;
        shapeRect = CGRectInset(shapeRect, _edgeInset, _edgeInset);
    }
    
    [self drawBackgoundInRect:shapeRect withColor:_backgroundColor];;
    
    if(drawEnclosedBlock) {
        CGContextRef context = CGGetCurrentContext();
        CGContextSaveGState(context);
        CGMutablePathRef path = CGPathCreateMutable();
        [self createPathForShapeInRect:path rect:shapeRect];
        CGContextAddPath(context, path);
        CGContextClip(context);
        drawEnclosedBlock();
        CGPathRelease(path);
        CGContextRestoreGState(context);
    }

    
// now draw inner border around subWidgets if we have a border color
    
//    if(_edgeInsetColor) {
//        // TODO: use color components instead of SDKColor+t
//        FLColorValues borderColorValues = _edgeInsetColor.rgbColorValues;
//        CGContextSetRGBStrokeColor(context, borderColorValues.red, borderColorValues.green, borderColorValues.blue, borderColorValues.alpha);
//        CGContextSetLineWidth(context, _edgeInset);
////        CGContextAddPath(context, innerShapePath);
////        CGContextClip(context);
//        CGContextStrokePath(context);
//    }
    
//    CGPathRelease(shapePath);
}      

@end

@implementation FLDrawableBackButtonShape

@synthesize shapeSize = _shapeSize;

- (id) initWithShapeSize:(CGFloat) shapeSize {
    self = [super init];
    if(self) {
        self.shapeSize = shapeSize;
    }
    
    return self;
}

-(void) createPathForShapeInRect:(CGMutablePathRef) path rect:(CGRect) rect {
	FLCreateRectPathBackButtonShape(path, rect, self.cornerRadius, _shapeSize);
}

@end

@implementation FLDrawableForwardButtonShape

@synthesize shapeSize = _shapeSize;

- (id) initWithShapeSize:(CGFloat) shapeSize {
    self = [super init];
    if(self) {
        self.shapeSize = shapeSize;
    }
    
    return self;
}

-(void) createPathForShapeInRect:(CGMutablePathRef) path rect:(CGRect) rect {
	FLCreateRectPathForwardButtonShape(path, rect, self.cornerRadius, _shapeSize);
}

@end

