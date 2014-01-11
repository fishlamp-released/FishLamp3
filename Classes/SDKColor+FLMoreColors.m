//
//  SDKColor+Colors.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FLColorUtilities.h"
#import "SDKColor+FLMoreColors.h"

@implementation SDKColor (FLMoreColors)

+ (SDKColor*) iPhoneBlueColor
{
	//	return [SDKColor colorWithHue:0.6 saturation:0.33 brightness:0.69 alpha:0];
	
	FLReturnColorWithRGBRed(36,99,222, 1.0); // 0.035294117647059, 0.388235294117647, 0.870588235294118
}

+ (SDKColor*) standardLabelColor
{
	return [SDKColor blackColor];
}

+ (SDKColor*) standardTextFieldColor
{
	return [SDKColor blueLabelColor];
}	

+ (SDKColor*) disabledControlColor
{
	return [SDKColor lightGrayColor];
}

+ (SDKColor*)indigoColor
{
	FLReturnColorWithDecimalRed(.294f, 0.0f, .509f, 1.0);
}

+ (SDKColor*)tealColor
{
	FLReturnColorWithDecimalRed(0.0f, 0.5f, 0.5f, 1.0);
}

+ (SDKColor*)violetColor
{
	FLReturnColorWithDecimalRed (.498f, 0.0f, 1.0f, 1.0); 
}

+ (SDKColor*)electricVioletColor
{
	FLReturnColorWithDecimalRed(.506f, 0.0f, 1.0f, 1.0);
}

+ (SDKColor*)vividVioletColor
{
	FLReturnColorWithDecimalRed(.506f, 0.0f, 1.0f, 1.0);
}

+ (SDKColor*)darkVioletColor
{
	FLReturnColorWithDecimalRed(.58f, 0.0f, .827f, 1.0);
}

+ (SDKColor*)amberColor
{
	FLReturnColorWithDecimalRed(1.0f, .75f, 0.0f, 1.0);
}

+ (SDKColor*)darkAmberColor
{
	FLReturnColorWithDecimalRed(1.0f, .494f, 0.0f, 1.0);
}

+ (SDKColor*)lemonColor
{
	FLReturnColorWithDecimalRed(1.0f, .914f, .0627f, 1.0);
}

+ (SDKColor*) paleYellowColor
{
	FLReturnColorWithDecimalRed(1.0f, .914f, .0627f, 1.0);
}

+ (SDKColor*)roseColor
{
	FLReturnColorWithDecimalRed(1.0f, 0.0f, 0.5f, 1.0);
}

+ (SDKColor*)rubyColor
{
	FLReturnColorWithDecimalRed(0.8784f, .06667f, .3725f, 1.0);
}

+ (SDKColor*)fireEngineRed
{
	FLReturnColorWithDecimalRed(0.8078f, 0.0863f, 0.1255f, 1.0);
}

+ (SDKColor*)darkBlueColor
{
	FLReturnColorWithDecimalRed(0.0f, 0.0f, 0.25f, 1.0);
}

+ (SDKColor*) skyBlueColor
{
	FLReturnColorWithRGBRed(135,206,235, 1.0);
}

+ (SDKColor*) lightSkyBlueColor
{
	FLReturnColorWithRGBRed(135,206,250, 1.0);
}
+ (SDKColor*) lightBlueColor
{
	FLReturnColorWithRGBRed(173,206,230, 1.0);
}

+ (SDKColor*) darkGreenColor
{
	FLReturnColorWithRGBRed(0x2f, 0x4f, 0x2f, 1.0);
}

+ (SDKColor*) blueLabelColor
{
	FLReturnColorWithRGBRed(50.0,79.0,133.0, 1.0);
}

+ (SDKColor*) silverColor
{
	FLReturnColorWithRGBRed(192,192,192, 1.0);
}

+ (SDKColor*) gray10Color
{
    FLReturnColorWithDecimalRed(0.1f, 0.1f, 0.1f, 1.0);
}

+ (SDKColor*)gray75Color
{
	FLReturnColorWithDecimalRed(0.75f, 0.75f, 0.75f, 1.0);
}

+ (SDKColor*)gray85Color
{
	FLReturnColorWithDecimalRed(0.85f, 0.85f, 0.85f, 1.0);
}

+ (SDKColor*)gray15Color
{
	FLReturnColorWithDecimalRed(0.15f, 0.15f, 0.15f, 1.0);
}

+ (SDKColor*) gray95Color
{
	FLReturnColorWithDecimalRed(0.95f, 0.95f, 0.95f, 1.0);
}


+ (SDKColor*) gray45Color
{
	FLReturnColorWithDecimalRed(0.45f, 0.45f, 0.45f, 1.0);
}

+ (SDKColor*) gray25Color
{
	FLReturnColorWithDecimalRed(0.25f, 0.25f, 0.25f, 1.0);
}

+ (SDKColor*) gray33Color
{
	return [SDKColor darkGrayColor];
}

+ (SDKColor*) gray66Color
{
	return [SDKColor lightGrayColor];
}

+ (SDKColor*) gray20Color
{
    FLReturnColorWithDecimalRed(0.2f, 0.2f, 0.2f, 1.0);
}

+ (SDKColor*) gray50Color
{
	return [SDKColor grayColor];
}

+ (SDKColor*) gray237Color {
	FLReturnColorWithRGBRed(237,237,237, 1.0);
}

+ (SDKColor*) lightBlueTintedGrayColor
{
	FLReturnColorWithRGBRed(80,80,83, 1.0);
}


+ (SDKColor*) blueTintedGrayColor
{
	FLReturnColorWithRGBRed(69,69,71, 1.0);
}

+ (SDKColor*) darkBlueTintedGrayColor
{
	FLReturnColorWithRGBRed(41,41,42, 1.0);
}

+ (SDKColor*) darkDarkBlueTintedGrayColor
{
	FLReturnColorWithRGBRed(20,20,24, 1.0);
}


//+ (SDKColor*) darkBlueTintedGrayColor
//{
//	FLReturnColorWithRGBRed(41,41,42, 1.0);
//}
//
//+ (SDKColor*) mediumGrayColor
//{
//	FLReturnColorWithRGBRed(79,81,82, 1.0);
//}
//
//+ (SDKColor*) blueTextColor
//{
//	FLReturnColorWithRGBRed(171,197,225, 1.0);
//}

+ (SDKColor*) grayGlossyButtonColor
{
	FLReturnColorWithRGBRed(235, 235, 237, 1.0f);
}

+ (SDKColor*) redGlossyButtonColor
{
	FLReturnColorWithRGBRed(160, 1, 20, 1.0f);
}

+ (SDKColor*) greenGlossyButtonColor
{
	FLReturnColorWithRGBRed(24, 157, 22, 1.0f);
}

+ (SDKColor*) yellowGlossyButtonColor
{
	FLReturnColorWithRGBRed(240, 191, 34, 1.0f);
}

+ (SDKColor*) blackGlossyButtonColor
{
	return [SDKColor gray10Color];
}


@end
