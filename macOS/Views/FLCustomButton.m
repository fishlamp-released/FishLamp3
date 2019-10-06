//
//  FLCustomButton.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/28/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCustomButton.h"
#import "FLAttributedString.h"
#import "FLColorModule.h"
#import "FLGeometry.h"

@implementation FLCustomButton

//- (id)initWithFrame:(NSRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code here.
//    }
//    
//    return self;
//}

//- (void)drawRect:(NSRect)dirtyRect
//{
//    // Drawing code here.
//}


- (void) awakeFromNib {
    [super awakeFromNib];
    



//    [[self cell] setBackgroundColor:[NSColor colorWithRGBRed:203 green:102 blue:10 alpha:1.0]];
}


@end


@implementation FLCustomButtonCell


- (void) updateString {
    NSRange range = self.attributedTitle.entireRange;
    
    NSMutableDictionary *attributes = FLMutableCopyWithAutorelease([self.attributedTitle attributesAtIndex:0 effectiveRange:&range]);
    
    if([self isEnabled]) {
        [attributes setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    else {
        [attributes setObject:[NSColor lightGrayColor] forKey:NSForegroundColorAttributeName];
    }
    
    [attributes setObject:[NSFont boldSystemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]] forKey:NSFontAttributeName];

    NSMutableAttributedString* string = 
        FLAutorelease([[NSMutableAttributedString alloc] initWithString:self.title attributes:attributes]);
            
    [self setAttributedTitle:string];
//    203, 102, 10,1.0
}


- (void) setEnabled:(BOOL) enabled {
    [super setEnabled:enabled];
    [self updateString];
}




- (void)drawImage:(NSImage*)image withFrame:(NSRect)frame inView:(NSView*)controlView
{
    if(image) {
        NSRect bounds = controlView.bounds;
    
        NSRect iconFrame = NSRectMake(0,0,16,16);
        
        iconFrame = NSRectCenterRectInRectVertically(bounds, iconFrame);
        iconFrame.origin = NSPointMake(NSRectGetRight(bounds) - iconFrame.size.width - 10, iconFrame.origin.y);

    
//        iconFrame.size.width = iconFrame.size.height;
//        iconFrame.origin.x = frame.origin.x + 6;
        // NSRectOptimizedForViewLocation(NSRectCenterRectInRectVertically(frame,  iconFrame)) 
        
        [image drawInRect:iconFrame
                fromRect:NSZeroRect
               operation:NSCompositeSourceOver
                fraction:1.0
          respectFlipped:YES
                   hints:nil];
    }
    

//    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
//    CGContextRef contextRef = [ctx graphicsPort];
//    
//    NSData *data = [image TIFFRepresentation];
//    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)data, NULL);
//    if(source) {
//        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
//        CFRelease(source);
//        
//        CGContextSaveGState(contextRef);
//        {
//            NSRect rect = NSOffsetRect(frame, 0.0f, 1.0f);
//            CGFloat white = [self isHighlighted] ? 0.2f : 0.35f;
//            CGContextClipToMask(contextRef, NSRectToCGRect(rect), imageRef);
//            [[NSColor colorWithDeviceWhite:white alpha:1.0f] setFill];
//            NSRectFill(rect);
//        } 
//        CGContextRestoreGState(contextRef);
//        
//        CGContextSaveGState(contextRef);
//        {
//            NSRect rect = frame;
//            CGContextClipToMask(contextRef, NSRectToCGRect(rect), imageRef);
//            [[NSColor colorWithDeviceWhite:0.1f alpha:1.0f] setFill];
//            NSRectFill(rect);
//        } 
//        CGContextRestoreGState(contextRef);        
//                
//        CFRelease(imageRef);
//    }
}
//
//- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
//
//
//}
//
- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    
    CGFloat roundedRadius = 3.0f;
    
    BOOL outer = NO;
    BOOL background = YES;
    BOOL stroke = NO;
    BOOL innerStroke = NO;
    
    if(outer) {
        [ctx saveGraphicsState];
        NSBezierPath *outerClip = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:roundedRadius yRadius:roundedRadius];
        [outerClip setClip];

        NSGradient *outerGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                     [NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.0f, 
                                     [NSColor colorWithDeviceWhite:0.21f alpha:1.0f], 1.0f, 
                                     nil];
        
        [outerGradient drawInRect:[outerClip bounds] angle:90.0f];
        FLRelease(outerGradient);
        [ctx restoreGraphicsState];
    }
     
    if(background) {
        [ctx saveGraphicsState];
        
        NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.0f, 2.0f) xRadius:roundedRadius yRadius:roundedRadius];
        [backgroundPath setClip];
        
//        NSGradient *backgroundGradient = [[NSGradient alloc] initWithColorsAndLocations:
//                                          [NSColor colorWithDeviceWhite:0.17f alpha:1.0f], 0.0f, 
//                                          [NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.12f, 
//                                          [NSColor colorWithDeviceWhite:0.27f alpha:1.0f], 0.5f, 
//                                          [NSColor colorWithDeviceWhite:0.30f alpha:1.0f], 0.5f, 
//                                          [NSColor colorWithDeviceWhite:0.42f alpha:1.0f], 0.98f, 
//                                          [NSColor colorWithDeviceWhite:0.50f alpha:1.0f], 1.0f, 
//                                          nil];
//        
//        [backgroundGradient drawInRect:[backgroundPath bounds] angle:270.0f];
//        [backgroundGradient release];

        if([self isEnabled]) {
            [[NSColor colorWithRGBRed:203 green:102 blue:10 alpha:1.0] set];
        }
        else {
            [[NSColor lightGrayColor] set];
        }
        NSRectFill(frame);

        [ctx restoreGraphicsState];
    }
    
    if(stroke) {
        [ctx saveGraphicsState];
        [[NSColor colorWithDeviceWhite:0.12f alpha:1.0f] setStroke];
        [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 1.5f, 1.5f) xRadius:roundedRadius yRadius:roundedRadius] stroke];
        [ctx restoreGraphicsState];
    }
    
    if(innerStroke) {
        [ctx saveGraphicsState];
        [[NSColor colorWithDeviceWhite:1.0f alpha:0.05f] setStroke];
        [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.5f, 2.5f) xRadius:roundedRadius yRadius:roundedRadius] stroke];
        [ctx restoreGraphicsState];        
    }
    
    if([self isHighlighted]) {
        [ctx saveGraphicsState];
        [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.0f, 2.0f) xRadius:roundedRadius yRadius:roundedRadius] setClip];
        [[NSColor colorWithCalibratedWhite:0.0f alpha:0.35] setFill];
        NSRectFillUsingOperation(frame, NSCompositeSourceOver);
        [ctx restoreGraphicsState];
    }
}

@end
