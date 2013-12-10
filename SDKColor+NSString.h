//
//  FLNamedCssColors.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/26/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCompatibility.h"

// see http://www.w3schools.com/cssref/css_colornames.asp
#import "FLHexColorDefines.h"

// decoding
extern SDKColor* FLColorFromRGBString(NSString* string); // rgb(155,3,555,1.0)
extern SDKColor* FLColorFromHexColorString(NSString* string); // AABBCC or #AABBCC
extern SDKColor* FLColorFromHexColorName(NSString* string); // white, black, green, etc..

extern SDKColor* FLColorFromString(NSString* string); // AABBCC or #AABBCC or rgb(155,3,555,1.0) or white or black or any color in FLHexColorDefines

// encoding
extern NSString* FLRgbStringFromColor(SDKColor* color); //rgb(11,11,11,0.5)
extern NSString* FLCssColorStringFromColor(SDKColor* color);  // #AABBCC
extern NSString* FLHexColorStringFromColor(SDKColor* color); // AABBCC

