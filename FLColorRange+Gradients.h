//
//  FLColorRange+Gradients.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/13/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLColorRange.h"

@interface FLColorRange (FLGradientColors)
// utils
// premade gradients

- (id) initWithStartColor:(SDKColor*) color 
                rangeSeperationPercentage:(CGFloat) percentage;

+ (id) gradientColorsFromColor:(SDKColor*) color 
                rangeSeperationPercentage:(CGFloat) percentage; // .3 is typical

+ (FLColorRange*) iPhoneBlueGradientColorRange;

+ (FLColorRange*) redGradientColorRange;
+ (FLColorRange*) paleBlueGradientColorRange;
+ (FLColorRange*) brightBlueGradientColorRange;
+ (FLColorRange*) darkGrayGradientColorRange;
+ (FLColorRange*) darkGrayWithBlueTintGradientColorRange;
+ (FLColorRange*) blackGradientColorRange;
+ (FLColorRange*) grayGradientColorRange;
+ (FLColorRange*) lightGrayGradientColorRange;
+ (FLColorRange*) lightLightGrayGradientColorRange;

+ (FLColorRange*) silverGradientColorRange;
@end