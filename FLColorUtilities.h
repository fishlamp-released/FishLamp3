//
//  FLColorUtilities.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/13/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "SDKColor+FLUtils.h"
#import "SDKColor+FLMoreColors.h"
#import "SDKColor+NSString.h"

@class SDKColor;

NS_INLINE
BOOL FLColorValueIsDecimal(CGFloat value) {
    return value >= 0.0f && value <= 1.0f;
}

NS_INLINE
BOOL FLColorValueIsRGB(CGFloat value) {
    return value >= 0.0f && value <= 255.0f;
}


#define FLAssertColorValueIsRGB(__VALUE__) \
            FLCAssert(FLColorValueIsRGB(__VALUE__), @"%f should be between 1 and 255", __VALUE__)

#define FLAssertColorValueIsDecimal(__VALUE__) \
            FLCAssert(FLColorValueIsDecimal(__VALUE__), @"%f should be between 0.0 and 1.0", __VALUE__)



#define FLDecimalColorToRgbColor(__DECIMAL__)   (__DECIMAL__ * 255.0f)

#define FLRgbColorToDecimalColor(__RGB__)       (__RGB__ / 255.0f)


#if IOS
#define FLColorCreateWithRGBColorValues(__RED__,__GREEN__,__BLUE__,__ALPHA__) \
            [UIColor colorWithRed:FLRgbColorToDecimalColor(__RED__) \
                            green:FLRgbColorToDecimalColor(__GREEN__) \
                             blue:FLRgbColorToDecimalColor(__BLUE__) \
                            alpha:__ALPHA__]

#define FLColorCreateWithDecimalColorValues(__RED__,__GREEN__,__BLUE__,__ALPHA__) \
            [UIColor colorWithRed:__RED__ \
                            green:__GREEN__ \
                             blue:__BLUE__ \
                            alpha:__ALPHA__]
#else
#define FLColorCreateWithRGBColorValues(__RED__,__GREEN__,__BLUE__,__ALPHA__) \
            [NSColor colorWithCalibratedRed:FLRgbColorToDecimalColor(__RED__) \
                            green:FLRgbColorToDecimalColor(__GREEN__) \
                             blue:FLRgbColorToDecimalColor(__BLUE__) \
                            alpha:__ALPHA__]

#define FLColorCreateWithDecimalColorValues(__RED__,__GREEN__,__BLUE__,__ALPHA__) \
            [NSColor colorWithCalibratedRed:__RED__ \
                            green:__GREEN__ \
                             blue:__BLUE__ \
                            alpha:__ALPHA__]


#endif


#define FLReturnColorWithRGBRed(__RED__,__GREEN__,__BLUE__,__ALPHA__) \
            FLReturnStaticObject(FLRetain(FLColorCreateWithRGBColorValues(__RED__, __GREEN__,__BLUE__, __ALPHA__)))

#define FLReturnColorWithDecimalRed(__RED__,__GREEN__,__BLUE__,__ALPHA__) \
            FLReturnStaticObject(FLRetain(FLColorCreateWithDecimalColorValues(__RED__, __GREEN__,__BLUE__, __ALPHA__)))



#if OSX
@interface CIColor (FLColorConversions)
- (CGColorRef) copyCGColorRef;
@end

@interface NSColor (FLColorConversions)
- (CGColorRef) copyCGColorRef;
+ (NSColor *) colorWithCGColorRef: (CGColorRef) cgColor;
@end
#endif