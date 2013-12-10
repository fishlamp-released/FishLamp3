//
//  SDKColor+Utils.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "SDKColor+FLUtils.h"
#import "FLColorUtilities.h"
#import "FLColorValues.h"

@implementation SDKColor (FLUtils)

+ (SDKColor*) colorWithRGBRed:(CGFloat) red
                       green:(CGFloat) green
                        blue:(CGFloat) blue
                       alpha:(CGFloat) alpha {

#if OSX
	return [NSColor colorWithDeviceRed:FLRgbColorToDecimalColor(red)
                           green:FLRgbColorToDecimalColor(green)
                            blue:FLRgbColorToDecimalColor(blue)
                           alpha:alpha ];
#else

    return nil;

#endif
}


- (BOOL) isLightColor
{
#if IOS
	const CGFloat *componentColors = CGColorGetComponents(self.CGColor);

	CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
	return (colorBrightness > 0.5);
#endif 

    return NO;
}

- (SDKColor*) colorWithDarkening:(CGFloat) byPercentageAmount {
    return [SDKColor colorWithColorValues:FLColorValuesDarken(self.rgbColorValues, byPercentageAmount)];
}

- (SDKColor*) colorWithLightening:(CGFloat) byPercentageAmount {
    return [SDKColor colorWithColorValues:FLColorValuesLighten(self.rgbColorValues, byPercentageAmount)];
}




@end

