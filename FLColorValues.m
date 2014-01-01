//
//  FLColorUtils.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/14/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLColorValues.h"

// TODO: this clips the individual rgb values
// it'd be nice if the min/max scaled all the same not matter what.

FLColorValues FLColorValuesDarken(FLColorValues values, CGFloat byPercent) {
    FLColorValues newValues = FLColorValuesRgbToDecimal(values);
	newValues.red = MIN(1.0f, (newValues.red * (1.0f + byPercent)));
	newValues.green = MIN(1.0f, (newValues.green * (1.0f + byPercent)));
	newValues.blue = MIN(1.0f, (newValues.blue * (1.0f + byPercent)));
	return values.valuesAreRGB ? FLColorValuesDecimalToRgb(newValues) : newValues;
}

FLColorValues FLColorValuesLighten(FLColorValues values, CGFloat byPercent) {
    FLColorValues newValues = FLColorValuesRgbToDecimal(values);
	newValues.red = MAX(0.0f, (newValues.red * (1.0f - byPercent)));
	newValues.green = MAX(0.0f, (newValues.green * (1.0f - byPercent)));
	newValues.blue = MAX(0.0f, (newValues.blue * (1.0f - byPercent)));
	return values.valuesAreRGB ? FLColorValuesDecimalToRgb(newValues) : newValues;
}

@implementation SDKColor (FLColorValues)

+ (SDKColor*) colorWithColorValues:(FLColorValues) values {
    
    values = FLColorValuesRgbToDecimal(values);
    return [SDKColor colorWithRed:values.red
                           green:values.green
                            blue:values.blue
                           alpha:values.alpha ];
}

- (FLColorValues) decimalColorValues {

    FLColorValues values = { 0, 0, 0, 0, NO };
    
#if IOS
	CGColorRef color = self.CGColor;
	int numComponents = CGColorGetNumberOfComponents(color);
	 
	if (numComponents == 2)
	{
		const CGFloat *components = CGColorGetComponents(color);
		CGFloat all = components[0];
		values.red = all;
		values.green = all;
		values.blue = all;
		values.alpha = components[1];
	}
	else
	{
		FLAssert(numComponents == 4, @"didn't get 4 componants");
	
		const CGFloat *components = CGColorGetComponents(color);
		values.red = components[0];
		values.green = components[1];
		values.blue = components[2];
        values.alpha = components[3];
	}
#else

    NSColor* color = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    [color getRed:&values.red green:&values.green blue:&values.blue alpha:&values.alpha];
    
#endif   

    return values;
}

- (FLColorValues) rgbColorValues {
    return FLColorValuesDecimalToRgb(self.decimalColorValues);
}

@end