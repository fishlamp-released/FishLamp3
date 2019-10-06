//
//  FLColorRange+Gradients.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/13/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLColorRange+Gradients.h"
#import "SDKColor+FLMoreColors.h"
#import "FLColorUtilities.h"

@implementation FLColorRange (FLGradientColors)

- (id) initWithStartColor:(SDKColor*) color 
                rangeSeperationPercentage:(CGFloat) percentage {
                
    FLColorValues rgbColorValues = color.rgbColorValues;
	FLColorValues startColor = FLColorValuesLighten(rgbColorValues, percentage);
	FLColorValues endColor = FLColorValuesDarken(rgbColorValues, percentage);

    return [self initWithStartColor:[SDKColor colorWithColorValues:startColor]
                           endColor:[SDKColor colorWithColorValues:endColor]];
}	


+ (id) gradientColorsFromColor:(SDKColor*) color 
                rangeSeperationPercentage:(CGFloat) percentage {
    return FLAutorelease([[[self class] alloc] initWithStartColor:color rangeSeperationPercentage:percentage]);
}

+ (FLColorRange*) iPhoneBlueGradientColorRange {

	FLReturnStaticObject( 
        [[FLColorRange alloc] initWithStartColor:[SDKColor iPhoneBlueColor] rangeSeperationPercentage:0.3f];
        );

}

+(FLColorRange*) redGradientColorRange {
	FLReturnStaticObject( 
        [[FLColorRange alloc] initWithStartColor:FLColorCreateWithRGBColorValues(236,19,20,1.0)  endColor:[SDKColor fireEngineRed]];
        );
}

+(FLColorRange*) paleBlueGradientColorRange {
	FLReturnStaticObject( 
        [[FLColorRange alloc] initWithStartColor:FLColorCreateWithRGBColorValues(74,108,155,1.0) endColor:FLColorCreateWithRGBColorValues(72,106,154,1.0)];
        );
}

+(FLColorRange*) brightBlueGradientColorRange {
	FLReturnStaticObject( 
        [[FLColorRange alloc] initWithStartColor:FLColorCreateWithRGBColorValues(36,99,222,1.0) endColor:FLColorCreateWithRGBColorValues(34,96,221,1.0)];
        );
}

+(FLColorRange*) darkGrayGradientColorRange {
	FLReturnStaticObject( 
        [[FLColorRange alloc] initWithStartColor:FLColorCreateWithRGBColorValues(71,71,73,1.0) endColor:FLColorCreateWithRGBColorValues(33,33,35,1.0)];
        );
}

+(FLColorRange*) darkGrayWithBlueTintGradientColorRange {
	FLReturnStaticObject( 
        [[FLColorRange alloc] initWithStartColor:FLColorCreateWithRGBColorValues(65,71,80,1.0) endColor:FLColorCreateWithRGBColorValues(43,50,59,1.0)];
        );
}

+(FLColorRange*) blackGradientColorRange {
	FLReturnStaticObject( 
        [[FLColorRange alloc] initWithStartColor:[SDKColor darkGrayColor] endColor:[SDKColor blackColor]];
        );
}

+(FLColorRange*) grayGradientColorRange {
	FLReturnStaticObject( 
        [[FLColorRange alloc] initWithStartColor:FLColorCreateWithRGBColorValues(71,71,73,1.0) endColor:FLColorCreateWithRGBColorValues(33,33,35,1.0)];
        );
}

+(FLColorRange*) lightGrayGradientColorRange {
	FLReturnStaticObject( 
        [[FLColorRange alloc] initWithStartColor:FLColorCreateWithRGBColorValues(128,128,128,1.0)  endColor:FLColorCreateWithRGBColorValues(71,71,73,1.0)];
        );
}

+(FLColorRange*) lightLightGrayGradientColorRange {
	FLReturnStaticObject( 
        [[FLColorRange alloc] initWithStartColor:FLColorCreateWithRGBColorValues(250,250,250,1.0)  endColor:FLColorCreateWithRGBColorValues(112,118,118,1.0)];
        );
}


+ (FLColorRange*) silverGradientColorRange {
	FLReturnStaticObject( 
        [[FLColorRange alloc] initWithStartColor:FLColorCreateWithRGBColorValues(170,170,170,1.0)  endColor:FLColorCreateWithRGBColorValues(192,192,192,1.0)];
        );
}

//Silver Chalice            172  172  172
//Silver Sand               191  193  194
//Silver Tree               102  181  143




//+ (FLGradientColorPair*) grayGradientColors
//{
//    FLSynchronizedStatic(s_color, FLGradientColorPair, [[FLGradientColorPair alloc] initWithStartColor:FLColorCreateWithRGBColorValues(71,71,73,1.0) endColor:FLColorCreateWithRGBColorValues(33,33,35,1.0)]);
//    return s_color;
//}

//+ (FLGradientColorPair*) deleteButtonRedGradientColors;
//{
//    FLSynchronizedStatic(s_color, FLGradientColorPair, [[FLGradientColorPair alloc] initWithStartColor:FLColorCreateWithRGBColorValues(240,127,136,1.0) endColor:[SDKColor fireEngineRed]]);
////    FLSynchronizedStatic(s_color, FLGradientColorPair, [[FLGradientColorPair alloc] initWithStartColor:FLColorCreateWithRGBColorValues(240,127,136,1.0) endColor:FLColorCreateWithRGBColorValues(231,53,66,1.0)]);
////    FLSynchronizedStatic(s_color, FLGradientColorPair, [[FLGradientColorPair alloc] initWithStartColor:FLColorCreateWithRGBColorValues(236,19,20,1.0)  endColor:[SDKColor fireEngineRed]]);
//    return s_color;
//}
//
//+ (FLGradientColorPair*) paleBlueGradientColors
//{
//    FLSynchronizedStatic(s_color, FLGradientColorPair, [[FLGradientColorPair alloc] initWithStartColor:FLColorCreateWithRGBColorValues(74,108,155,1.0) endColor:FLColorCreateWithRGBColorValues(72,106,154,1.0)]);
//    return s_color;
//}
//
//+ (FLGradientColorPair*) brightBlueGradientColors
//{
//    FLSynchronizedStatic(s_color, FLGradientColorPair, [[FLGradientColorPair alloc] initWithStartColor:FLColorCreateWithRGBColorValues(108,147,232,1.0) endColor:FLColorCreateWithRGBColorValues(57,112,224,1.0)]);
//    return s_color;
//}
//
//


@end