//
//  SDKColor+Utils.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLCompatibility.h"

@interface SDKColor (FLUtils)

+ (SDKColor*) colorWithRGBRed:(CGFloat) rgbRed
                       green:(CGFloat) rgbGreen
                        blue:(CGFloat) rgbBlue
                       alpha:(CGFloat) alpha;


- (BOOL) isLightColor;

- (SDKColor*) colorWithDarkening:(CGFloat) byPercentageAmount;

- (SDKColor*) colorWithLightening:(CGFloat) byPercentageAmount;

@end

