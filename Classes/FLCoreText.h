//
//  FLCoreText.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

#if __MAC_10_8
#import <CoreText/CoreText.h>
#endif
#import "FLCompatibility.h"

extern CGSize CTLineGetSize(CTLineRef line);
extern CGSize CTFrameGetSize(CTFrameRef frameRef);
extern CGSize CTRunGetSize(CTRunRef run);
extern CGRect CTRunGetRect(CTRunRef run, CTLineRef line, CGPoint origin);

extern CGFloat CGGetLineHeightForFont(CTFontRef iFont);

// attributed string drawing
extern CTFrameRef CTAttributedStringGetFrame(NSAttributedString* string, CGRect inBounds);
extern CGSize CTAttributedStringGetSize(NSAttributedString* string, CGRect inBounds);
extern void CGContextDrawAttributedString(CGContextRef context, NSAttributedString* string, CGRect rect);

@interface NSAttributedString (FLCoreText)
- (CGSize) sizeForDrawingInBounds:(CGRect) bounds;
- (void) drawInRectWithCoreText:(CGRect) rect;
@end



