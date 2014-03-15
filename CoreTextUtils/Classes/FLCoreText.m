//
//  FLCoreText.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCoreText.h"


//+ (CGSize) lineSize:(CTLineRef) line {
//	CGFloat ascent = 0;
//    CGFloat descent = 0; 
//    CGFloat leading = 0;
//    
//	CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
//	CGFloat height = ascent + descent + leading;
//	
//    return CGSizeMake(ceil(width), ceil(height));
//}

CGSize CTLineGetSize(CTLineRef line) {
	CGFloat ascent = 0;
    CGFloat descent = 0; 
    CGFloat leading = 0;
    
	CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
	CGFloat height = ascent + descent; // + leading;
	
    return CGSizeMake(width, height);
}

// see http://lists.apple.com/archives/quartz-dev/2008/Mar/msg00079.html


CGSize CTFrameGetSize(CTFrameRef frameRef) {
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    if(lineCount == 0) {
        return CGSizeZero;
    }

    CGSize outSize = { 0, 0 };
    for(int i = 0; i < lineCount; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGSize size = CTLineGetSize(line);
        outSize.width = MAX(size.width, outSize.width);
        outSize.height += size.height;
    }
    return outSize;

//    CGFloat ascent = 0;
//    CGFloat descent = 0; 
//    CGFloat leading = 0;
//    CTLineGetTypographicBounds(CFArrayGetValueAtIndex(lines, lineCount - 1), &ascent, &descent, &leading);
//
//    CGFloat lineHeight = ascent + descent + leading;
//
//    CGPoint lastLineOrigin = { 0, 0 };
//    CTFrameGetLineOrigins(frameRef, CFRangeMake(lineCount - 1, 0), &lastLineOrigin);
//    CGRect frameRect = CGPathGetBoundingBox(CTFrameGetPath(frameRef));

    // The height needed to draw the text is from the bottom of the last line
    // to the top of the frame.
//    return CGSizeMake(ceil(width), ceil(frameRect.size.height - (lastLineOrigin.y + lineHeight)));


}

CTFrameRef CTAttributedStringGetFrame(NSAttributedString* string, CGRect bounds) {
       
    CTFramesetterRef framesetter = nil;
    CGMutablePathRef path = CGPathCreateMutable();
    if(!path) {
        return nil;
    }

    @try {
    
        CGPathAddRect(path, NULL, bounds);

        framesetter = CTFramesetterCreateWithAttributedString(FLBridge(CFAttributedStringRef, string));
        if(!framesetter) {
            return nil;
        }

        return CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    }
    @finally {
        if(path) {
            CFRelease(path);
        } 
        if(framesetter) {
            CFRelease(framesetter);
        }
    }

    return nil;
}

CGSize CTRunGetSize(CTRunRef run) {    
    CGFloat ascent = 0;//height above the baseline
    CGFloat descent = 0;//height below the baseline
    
    CGSize size;
    size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
    size.height = ascent + descent;
    return size;
}

CGRect CTRunGetRect(CTRunRef run, CTLineRef line, CGPoint origin) {

    CGFloat ascent = 0;//height above the baseline
    CGFloat descent = 0;//height below the baseline
    
    CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);

    CGRect bounds;
    bounds.origin.x = origin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
    bounds.origin.y = origin.y - descent;
    bounds.size.width = width;
    bounds.size.height = ascent + descent;
    return bounds;
}

CGSize CTAttributedStringGetSize(NSAttributedString* string, CGRect inBounds) {
    CTFrameRef frameRef = CTAttributedStringGetFrame(string, inBounds);
    CGSize size = CTFrameGetSize(frameRef);
    CFRelease(frameRef);
    return size;
}

void CGContextDrawAttributedString(CGContextRef context, NSAttributedString* string, CGRect rect) {

    CGContextSaveGState(context);

#if OSX
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
#endif

#if IOS
    // flip to context coordinates for drawing text.
    CGRect bounds = rect;
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
#endif
    
    CTFrameRef frameRef = CTAttributedStringGetFrame(string, rect);
    if(frameRef) {
        CTFrameDraw(frameRef, context);
        CFRelease(frameRef);
    }

    CGContextRestoreGState(context);
}


@implementation NSAttributedString (FLCoreText)
       
- (CGSize) sizeForDrawingInBounds:(CGRect) bounds {
    return CTAttributedStringGetSize(self, bounds);
}                   

- (void) drawInRectWithCoreText:(CGRect) rect {
    CGContextDrawAttributedString(CGGetCurrentContext(), self, rect);
}

@end

CGFloat CGGetLineHeightForFont(CTFontRef iFont)
{
    CGFloat lineHeight = 0.0;
 
//    check(iFont != NULL);
 
    // Get the ascent from the font, already scaled for the font's size
    lineHeight += CTFontGetAscent(iFont);
 
    // Get the descent from the font, already scaled for the font's size
    lineHeight += CTFontGetDescent(iFont);
 
    // Get the leading from the font, already scaled for the font's size
    lineHeight += CTFontGetLeading(iFont);
 
    return lineHeight;
}



//#define max_buf_size 128
//
//- (FLBatchDictionary*) runFramesForString:(NSAttributedString*) string
//                                withFrame:(CTFrameRef) frameRef 
//                                 inBounds:(CGRect) bounds
//                  withTextAlignmentOffset:(CGPoint) offset {
//
//    CFArrayRef lines = CTFrameGetLines(frameRef);
//    CFIndex lineCount = CFArrayGetCount(lines);
//    if(lineCount) {
//        CGPoint* origins = malloc(sizeof(CGPoint*) * lineCount);
//        
//        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
//
//        for(CFIndex i = 0; i < lineCount; i++) {
//
//            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
//
//            CFArrayRef runs = CTLineGetGlyphRuns(line);
//            for(CFIndex j = 0; j < CFArrayGetCount(runs); j++) {
//                CTRunRef run = CFArrayGetValueAtIndex(runs, j);
//                CGRect runBounds = [self runBounds:run inLine:line lineOrigin:origins[i]];
//
////                CGFloat ascent = 0;//height above the baseline
////                CGFloat descent = 0;//height below the baseline
////                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
////                runBounds.size.height = ascent + descent;
////
////                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
////                runBounds.origin.x = origins[lineIndex].x /*+ bounds.origin.x*/ + xOffset;
////                runBounds.origin.y = origins[lineIndex].y /*+ bounds.origin.y*/;
////                runBounds.origin.y -= descent;
//
//#if IOS
//                // convert Rectangle back to view coordinates
//                runBounds = CGRectApplyAffineTransform(runBounds, CGAffineTransformMakeScale(1, -1));
//                runBounds = FLRectMoveVertically(runBounds, (bounds.size.height - offset.height));
//#endif
//
//                NSDictionary* attributes = FLBridge(NSDictionary*, CTRunGetAttributes(run));
//                FLAttributedString* breadcrumb = [attributes objectForKey:@"com.fishlamp.breadcrumb"];
//                if(breadcrumb) {
//                    [breadcrumb addRunFrame:runBounds];
//                }
//            }
//         }
//         
//         free(origins);
//    }
//}

//+ (CGRect) rectForTextAlignment:(FLTextAlignment) textAlignment 
//                         withFrame:(CTFrameRef) frameRef 
//                          inBounds:(CGRect) bounds {
//
//    CGSize size = [self frameSize:frameRef];
////    size.height += 2.0f;
//    
//    CGRect frame = CGRectMake(bounds.origin.x, bounds.origin.y, size.width, size.height);
//            
//    if(size.height < bounds.size.height) {
//        switch(textAlignment.vertical) {
//            case FLVerticalTextAlignmentTop:
//            
//            break;
//            
//            case FLVerticalTextAlignmentCenter:
//                frame = FLRectCenterRectInRectVertically(bounds, frame);
//            
//            
////                offset.y = (-((bounds.size.height / 2.0f) - (size.height / 2.0f)) - 2);
//            break;
//            
//            case FLVerticalTextAlignmentBottom:
//                frame.origin.y = FLRectGetBottom(bounds) - frame.size.height;
//            
////                offset.y = -(bounds.size.height - size.height);
//            break;
//        }
//    }
//    
//    
//    if(size.width < bounds.size.width) {
//        switch(textAlignment.horizontal) {
//            case FLHorizontalTextAlignmentLeft:
//                
//            break;
//
//            case FLHorizontalTextAlignmentCenter:
//                frame = FLRectCenterRectInRectHorizontally(bounds, frame);
//            
////                offset.x = FLRectGetCenter(bounds).x - (size.width / 2.0f);
//            break;
//
//            case FLHorizontalTextAlignmentRight:
//                frame.origin.x = FLRectGetRight(bounds) - frame.size.width;
//            break;
//        }
//    }
//    
//    return frame;
//}