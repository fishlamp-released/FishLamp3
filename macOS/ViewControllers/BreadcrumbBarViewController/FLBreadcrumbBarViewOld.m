//
//  FLBreadcrumbBarView.m
//  FishLamp-iOS-Lib
//
//  Created by Mike Fullerton on 1/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

//#import "FLBreadcrumbBarViewOld.h"
//#import "FLCoreText.h"

//@implementation FLBreadcrumbBarViewOld
//
//@synthesize strings = _strings;
//@synthesize verticalTextAlignment = _verticalTextAlignment;
//@synthesize enabledTextColor = _enabledTextColor;
//@synthesize disabledTextColor = _disabledTextColor;
//@synthesize highlightedTextColor = _highlightedTextColor;
//@synthesize textFont = _textFont;
//
//- (id) initWithFrame:(CGRect) frame {
//    if((self = [super initWithFrame:frame])) {
//        self.userInteractionEnabled = YES; 
//
//#if IOS
//        self.backgroundColor = [SDKColor clearColor];
//#endif
//        
//        self.enabledTextColor = [SDKColor blackColor];
//        self.disabledTextColor = [SDKColor grayColor];
//        self.highlightedTextColor = [SDKColor blueColor];
//        self.textFont = [SDKFont boldSystemFontOfSize:[SDKFont systemFontSize]];
//
//        _strings = [[FLOrderedCollection alloc] init];
//    }
//    
//    return self;
//}
//
//#if FL_MRC
//- (void) dealloc {
//    [_runFrames release];
//    [_enabledTextColor release];
//    [_disabledTextColor release];
//    [_highlightedTextColor release];
//    [_textFont release];
//    [_strings release];
//    [_runFrames release];
//    [super dealloc];
//}
//#endif
//
//- (FLAttributedString*) stringAtIndex:(NSUInteger) index {
//    return [_strings objectAtIndex:index];
//}
//
//- (FLAttributedString*) stringForKey:(NSString*) key {
//    return [_strings objectForKey:key];
//}
//
//- (void) setString:(NSString*) string 
//          atIndex:(NSUInteger) stringIndex {
//    [[_strings objectAtIndex:stringIndex] setString:string];
//    [self setNeedsLayout];
//}
//
//- (void) setString:(NSString*) string 
//            forKey:(NSString*) key {
//    [[_strings objectForKey:key] setString:string];
//    [self setNeedsLayout];
//}
//
//- (void) setAttributedString:(FLAttributedString*) string 
//                forKey:(NSString*) key  {
//
//    FLAssertStringIsNotEmpty(key);
//    FLAssertNotNil(string);
//                
////    if(!string.enabledColor) {
////        string.enabledColor = self.enabledTextColor;
////    }
////    if(!string.disabledColor) {
////        string.disabledColor = self.disabledTextColor;
////    }
////    if(!string.highlightedColor) {
////        string.highlightedColor = self.highlightedTextColor;
////    }
////    if(!string.textFont) {
////        string.textFont = self.textFont;
////    }
//
//    [_strings addOrReplaceObject:string forKey:key];
//    [self setNeedsLayout];
//}
//
//- (void) setStringForAllStrings:(NSString*) aString {
//    for(FLAttributedString* string in _strings.forwardObjectEnumerator) {
//        string.string = aString;
//    }
//    
//    [self setNeedsLayout];
//}
//
//- (NSAttributedString*) buildAttributedString {
//    NSMutableAttributedString* outString = FLAutorelease([[NSMutableAttributedString alloc] init]);
//    for(FLAttributedString* string in _strings.forwardObjectEnumerator) {
//        if(FLStringIsEmpty(string.string) || string.isHidden) {
//            continue;
//        }
//    
//        [outString appendAttributedString:string.attributedString];
//    }
//    
//    return outString;
//}
//
//- (void) setStringRunFrames:(CTFrameRef) frameRef 
//                      offset:(CGFloat) offset {
//
//    if(_runFrames) {
//        return;
//    }
//    _runFrames = [[FLMutableBatchDictionary alloc] init];
//
//    CFArrayRef lines = CTFrameGetLines(frameRef);
//    CFIndex lineCount = CFArrayGetCount(lines);
//    if(lineCount) {
//        CGPoint origins[lineCount];
//        
//        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
//
//        for(CFIndex lineIndex = 0; lineIndex < lineCount; lineIndex++) {
//            CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
//
//            CFArrayRef runs = CTLineGetGlyphRuns(line);
//            for(CFIndex j = 0; j < CFArrayGetCount(runs); j++) {
//                CTRunRef run = CFArrayGetValueAtIndex(runs, j);
//                CGRect runBounds = CGRectZero;
//
//                CGFloat ascent = 0;//height above the baseline
//                CGFloat descent = 0;//height below the baseline
//                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
//                runBounds.size.height = ascent + descent;
//
//                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
//                runBounds.origin.x = origins[lineIndex].x /*+ bounds.origin.x*/ + xOffset;
//                runBounds.origin.y = origins[lineIndex].y /*+ bounds.origin.y*/;
//                runBounds.origin.y -= descent;
//
//#if IOS
//                // convert Rectangle back to view coordinates
//                CGRect bounds = self.bounds;
//                runBounds = CGRectApplyAffineTransform(runBounds, CGAffineTransformMakeScale(1, -1));
//                runBounds = FLRectMoveVertically(runBounds, (bounds.size.height - offset));
//#endif
//
//                NSDictionary* attributes = FLBridge(NSDictionary*, CTRunGetAttributes(run));
//                FLAttributedString* str = [attributes objectForKey:@"com.fishlamp.string"];
//                if(str) {
//                    [_runFrames addObject:[NSValue valueWithCGRect:runBounds] forKey:str.string];
//                }
//            }
//         }
//    }
//}
//
//- (CTFrameRef) createFrameForCGContext:(CGContextRef) context {
//    NSAttributedString* attributedStringToDraw = [self buildAttributedString];
//
//    CGRect bounds = self.bounds;
//    
//    CTFramesetterRef framesetter = nil;
//    CGMutablePathRef path = CGPathCreateMutable();
//    if(!path) {
//        return nil;
//    }
//
//    @try {
//    
//        CGPathAddRect(path, NULL, bounds);
//
//        framesetter = CTFramesetterCreateWithAttributedString(FLBridge(CFAttributedStringRef, attributedStringToDraw));
//        if(!framesetter) {
//            return nil;
//        }
//   
//        // Create the frame and draw it into the graphics context
//        CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter,
//                                          CFRangeMake(0, 0), path, NULL);
//    
//        if(!frameRef) {
//            return nil;
//        }
//        
//        CGFloat boxOffset = 0.0f;
//
//        CFArrayRef lines = CTFrameGetLines(frameRef);
//        CFIndex lineCount = CFArrayGetCount(lines);
//        if(lineCount) {
//            CGFloat size = 0;
//            
//            for(CFIndex lineIndex = 0; lineIndex < lineCount; lineIndex++) {
//                CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
//                CGRect lineBounds = CTLineGetImageBounds(line, context);
//                size += lineBounds.size.height;
//            }
//         
//            size = ceilf(size);
//            size += 2.0f;
//            
//            if(size < bounds.size.height) {
//                switch(_verticalTextAlignment) {
//                    case FLVerticalTextAlignmentTop:
//                    break;
//                    
//                    case FLVerticalTextAlignmentCenter:
//                        boxOffset = -((bounds.size.height / 2.0f) - (size / 2.0f));
//                    break;
//                    
//                    case FLVerticalTextAlignmentBottom:
//                        boxOffset = -(bounds.size.height - size);
//                    break;
//                }
//                
//                if(boxOffset != 0.0f) {
//                    CGContextTranslateCTM(context, 0.0, boxOffset);
//                }
//            }
//        }
//        
//        [self setStringRunFrames:frameRef offset:boxOffset];
//
//        return frameRef;
//    }
//    @finally {
//        if(path) {
//            CFRelease(path);
//        } 
//        if(framesetter) {
//            CFRelease(framesetter);
//        }
//    }
//
//    return nil;
//}
//
////- (void) drawRect:(CGRect) drawRect {
////    [super drawRect:drawRect];
////
////    CGContextRef context = CGGetCurrentContext();
////    CGContextSaveGState(context);
////#if OSX
////    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
////#endif
////
////
////#if IOS
////    // flip to context coordinates for drawing text.
////    CGRect bounds = self.bounds;
////    CGContextTranslateCTM(context, 0.0, bounds.size.height);
////    CGContextScaleCTM(context, 1.0, -1.0);
////#endif
////
////    CTFrameRef frameRef = [self createFrameForCGContext:context];
////    @try {
////        if(frameRef) {
////            CTFrameDraw(frameRef, context);
////        }
////    }
////    @finally {
////        if(frameRef) {
////            CFRelease(frameRef);
////        }
////        
////        CGContextRestoreGState(context);
////    }
////     
////}
//
//- (void) drawRect:(CGRect) rect {
//    FLTextAlignment align = { FLVerticalTextAlignmentCenter, 0 };
//    
//    [FLCoreText drawString:[self buildAttributedString] withTextAlignment:align inBounds:self.bounds];
//}
//
//- (FLAttributedString*) stringAtPoint:(CGPoint) point {
//
//    for(NSString* string in _runFrames) {
//        for(NSValue* value in [_runFrames objectsForKey:string]) {
//            if(CGRectContainsPoint([value CGRectValue], point)) {
//                return [self stringForKey:string];
//            }
//        }
//    }
//
//    return nil;
//}
//
//- (void) setNeedsLayout {
//    [super setNeedsLayout];
//    FLReleaseWithNil(_runFrames);
//    [self setNeedsDisplay];
//}
//
//
//#if IOS
//- (void) _updateTouch:(NSSet *)touches 
//    withEvent:(UIEvent *)event 
//    isTouching:(BOOL) isTouching {
//    UITouch* touch = [touches anyObject];
//    CGPoint pt = [touch locationInView:self];
//    FLAttributedString* touchingstring = [self stringForPoint:pt];
//
//	for(FLAttributedString* string in _strings.forwardObjectEnumerator) {
//        if(string.isHighlighted != isTouching) {
//            if(touchingstring == string && string.isTouchable) {
//                if(string.isTouchable) {
//                    touchingstring.highlighted = isTouching;
//                    FLAssert(touchingstring.highlighted == isTouching, @"switch failed");
//                    FLDebugLog(@"touched %@", string.text);
//                }
//            }
//            else {
//                string.highlighted = NO;
//            }
//        }
//    }
//    
//    [self setNeedsLayout];
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self _updateTouch:touches withEvent:event isTouching:YES];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self _updateTouch:touches withEvent:event isTouching:YES];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self _updateTouch:touches withEvent:event isTouching:NO];
//}
//
//-(void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event  {	
//    [self _updateTouch:touches withEvent:event isTouching:NO];
//}
//#endif
//
//
//@end
