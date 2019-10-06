//
//  FLAttributedString.m
//  FishLamp-iOS-Lib
//
//  Created by Mike Fullerton on 1/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAttributedString.h"
#import "FLObjectDescriber.h"
#import "FLCompatibility.h"

@interface FLTextStyle ()
@end

@implementation FLTextStyle
@synthesize textColor = _textColor;
@synthesize shadowColor = _shadowColor;
@synthesize underlined = _underlined;
@synthesize textFont = _textFont;

- (id) init {
    self = [super init];
    if(self) {
        self.textColor = [SDKColor blackColor];
        self.shadowColor = [SDKColor whiteColor];
    }
    return self;
}

- (id) initWithTextColor:(SDKColor*) textColor shadowColor:(SDKColor*) shadowColor {
    self = [super init];
    if(self) {
        self.textColor = textColor;
        self.shadowColor = shadowColor;
    }
    return self;
}

+ (id) textStyle {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) textStyle:(SDKColor*) textColor shadowColor:(SDKColor*) shadowColor {
    return FLAutorelease([[[self class] alloc] initWithTextColor:textColor shadowColor:shadowColor]);
}

#if FL_MRC
- (void) dealloc {
    [_textColor release];
    [_shadowColor release];
    [_textFont release];
    [super dealloc];
}
#endif

//- (id) copyWithZone:(NSZone *)zone {
//    FLTextStyle* style = [[FLTextStyle alloc] init];
//    style.textColor = self.textColor;
//    style.shadowColor = self.shadowColor;
//    style.textFont = self.textFont;
//    style.underlined = self.isUnderlined;
//    return style;
//}

@end

@implementation FLStringDisplayStyle 

@synthesize enabledStyle = _enabledStyle;
@synthesize disabledStyle = _disabledStyle;
@synthesize highlightedStyle = _highlightedStyle;
@synthesize selectedStyle = _selectedStyle;
@synthesize hoveringStyle = _hoveringStyle;
@synthesize textFont = _textFont;

+ (id) stringDisplayStyle {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {
    self = [super init];
    if(self) {
        _selectedStyle = [[FLTextStyle alloc] init];
        _enabledStyle = [[FLTextStyle alloc] init];
        _disabledStyle = [[FLTextStyle alloc] init];
        _highlightedStyle = [[FLTextStyle alloc] init];
        _hoveringStyle = [[FLTextStyle alloc] init];
    }
    return self;
}

- (void) setToControlDefaults {
    [self setTextFont:[SDKFont systemFontOfSize:[SDKFont systemFontSize]]];

#if OSX
    [self visitStyles:^(FLTextStyle* style){
        style.shadowColor = [SDKColor shadowColor];
    }];

    self.enabledStyle.textColor = [NSColor textColor];
    self.disabledStyle.textColor = [NSColor disabledControlTextColor];
    self.selectedStyle.textColor = [NSColor selectedControlTextColor];
    self.highlightedStyle.textColor = [NSColor highlightColor];
    self.hoveringStyle = self.highlightedStyle;

#endif       

}

#if FL_MRC
- (void) dealloc {
    [_textFont release];
    [_enabledStyle release];
    [_disabledStyle release];
    [_highlightedStyle release];
    [_selectedStyle release];
    [_hoveringStyle release];
    [super dealloc];
}
#endif

//- (id) copyWithZone:(NSZone*) zone {
//    FLStringDisplayStyle* colors = [[FLStringDisplayStyle alloc] init];
//    colors.textFont = self.textFont;
//    colors.enabledStyle = self.enabledStyle;
//    colors.disabledStyle = self.disabledStyle;
//    colors.highlightedStyle = self.highlightedStyle;
//    colors.selectedStyle = self.selectedStyle;
//    colors.hoveringStyle = self.hoveringStyle;
//    colors.selectedStyle = self.selectedStyle;
//    return colors;
//}

- (void) visitStyles:(void (^)(FLTextStyle* style)) visitor {
    visitor(self.selectedStyle);
    visitor(self.enabledStyle);
    visitor(self.disabledStyle);
    visitor(self.highlightedStyle);
    visitor(self.hoveringStyle);
}

- (void) setTextFont:(SDKFont*) font {
    FLSetObjectWithRetain(_textFont, font);
    
    [self visitStyles:^(FLTextStyle* style){
        if(style.textFont == nil) {
            style.textFont = font;
        }
    }];
}

@end

@implementation NSAttributedString (FLAdditions)
- (NSRange) entireRange {
    return NSMakeRange(0, self.length);
}

//+ (id) attributedStringWithString:(NSString*) string 
//                    withTextStyle:(FLTextStyle*) textStyle {
//
//    FLAssertNotNil(textStyle, @"no text style attributed string");
//    NSMutableAttributedString* attrString =
//        FLAutorelease([[NSMutableAttributedString alloc] initWithString:string]);
//
//    [attrString setTextStyle:textStyle forRange:attrString.entireRange];
//    return attrString;
//}

//- (CGColorRef) colorForRange:(NSRange) range {
//
//    return FLBridge(CGColorRef, [self attribute:(NSString*) kCTForegroundColorAttributeName 
//        atIndex:0 effectiveRange:&range]);
//}
//
//- (CTFontRef) fontForRange:(NSRange) range {
//    return FLBridge(CTFontRef, [self attribute:(NSString*) kCTFontAttributeName 
//        atIndex:0 effectiveRange:&range]);
//}

@end

//CTFontRef CTFontCreateFromSDKFont(SDKFont *font)
//{
//    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, 
//                                            font.pointSize, 
//                                            NULL);
//    return ctFont;
//}

@implementation NSMutableDictionary (FLAttributedStringAdditions)


//- (void) setTextStyle:(FLTextStyle*) style forRange:(NSRange) range {
////    if(style.textFont) {
////        [self setFont:style.textFont forRange:range];
////    }
////    if(style.textColor) {
////        [self setColor:style.textColor forRange:range];
////    }
////    if(style.shadowColor) {
////        [self setShadowColor:style.shadowColor forRange:range];
////    }
////    if(style.isUnderlined) {
////        [self setUnderlined:YES forRange:range];
////    }
////    [self addAttribute:@"com.fishlamp.string" value:self range:range];
//}
//
//- (void) setAttribute:(id) object forName:(NSString*) name forRange:(NSRange) range {
////    if(object) {
////        [self addAttribute:name value:object range:range];
////    }
////    else {
////        [self removeAttribute:name range:range];
////    }
//}
//
//- (void) setFont:(SDKFont*) font forRange:(NSRange) range {
//    FLAssertNotNil(font); 
//    
////    CTFontRef fontRef = CTFontCreateWithName(FLBridge(CFStringRef, font.fontName), font.pointSize, NULL);
////    FLAssertNotNil(fontRef);
////    
////    if(fontRef) {
////        [self setAttribute:FLBridge(id, fontRef) forName:(NSString*) kCTFontAttributeName forRange:range];
////    
//////        [self addAttribute:(NSString*) kCTFontAttributeName
//////            value:FLBridge(id, fontRef) 
//////            range:range];
////
////        CFRelease(fontRef);
////    }
//}

- (void) setAttributedStringFont:(SDKFont*) font {
    [self setObject:font forKey:NSFontAttributeName];
}

- (void) setAttributedStringUnderlined {
    [self setObject:[NSNumber numberWithBool:YES] forKey:NSUnderlineStyleAttributeName];
}

- (void) setAttributedStringColor:(SDKColor*) color {
    [self setObject:color forKey:NSForegroundColorAttributeName];
}

//#if OSX
//    CGColorRef colorRef = [color copyCGColorRef];
//#else
//    CGColorRef colorRef  = [color CGColor];
//#endif
////    [self setAttribute:FLBridge(id, colorRef) forName:NSForegroundColorAttributeName forRange:range];
//
////    [self addAttribute:NSForegroundColorAttributeName value:FLBridge(id, colorRef) range:range];
//
//#if OSX
//    if(colorRef) {
//        CFRelease(colorRef);
//    }
//#endif    
//
////    if(color) {
////        [self addAttribute:(NSString*) kCTForegroundColorAttributeName 
////        value:FLBridge(id, [NSColor NSColorToCGColor:color])
////        range:range];
////    }
////    else {
////    
////    }
//}

//- (void) setShadowColor:(NSColor*) color forRange:(NSRange) range {
//
//
//#if OSX
//    CGColorRef colorRef = [color copyCGColorRef];
//#else
//    CGColorRef colorRef  = [color CGColor];
//#endif
//
////    [self setAttribute:FLBridge(id, colorRef) forName:(NSString*) NSShadowAttributeName forRange:range];
//#if OSX
//    if(colorRef) {
//        CFRelease(colorRef);
//    }
//#endif    
////    if(color) {
////        [self addAttribute:(NSString*) NSShadowAttributeName 
////        value:FLBridge(id, [NSColor NSColorToCGColor:color])
////        range:range];
////    }
////    else {
////        [self removeAttribute:(NSString*) NSShadowAttributeName forRange:range];
////    }
//}

//- (void) setUnderlined:(BOOL) underlined forRange:(NSRange) range {
//
//  //  [self setAttribute:underlined ? [NSNumber numberWithBool:YES] : nil forName:(NSString*) NSUnderlineStyleAttributeName  forRange:range];
//
//
////    [self addAttribute:(NSString*) NSUnderlineStyleAttributeName 
////        value:[NSNumber numberWithBool:YES]
////        range:range];
//}

//- (void) setURL:(NSURL*) url forRange:(NSRange) range {
//    [self setAttribute:url forName:(NSString*) NSLinkAttributeName forRange:range];
//}
//
//+ (id) mutableAttributedString {
//    return FLAutorelease([[[self class] alloc] init]);
//}
//+ (id) mutableAttributedString:(NSString*) string {
//    return FLAutorelease([[[self class] alloc] initWithString:string]);
//}
//
//- (id) initWithString:(NSString*) string url:(NSURL*) url color:(NSColor*) color underline:(BOOL) underline {
//    self = [self initWithString:string];
//    if(self) {
//        NSRange range = self.entireRange;
//        [self setURL:url forRange:range];
//        [self setColor:color forRange:range];
//        [self setUnderlined:underline forRange:range];
//    }
//    return self;
//}
//
//+ (id) mutableAttributedString:(NSString*) string url:(NSURL*) url color:(NSColor*) color underline:(BOOL) underline {
//    return FLAutorelease([[[self class] alloc] initWithString:string url:url color:color underline:underline]);
//}

@end
