//
//  FLColorRangeColorValues.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/13/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLColorValues.h"
#import "FLColorUtilities.h"

typedef struct {
	FLColorValues startColor;
	FLColorValues endColor;
    BOOL valuesAreRGB;
} FLColorRangeColorValues;

NS_INLINE
FLColorRangeColorValues FLColorRangeMakeDecimal(FLColorValues start, FLColorValues end) {
    FLColorRangeColorValues range = {
        FLColorValuesRgbToDecimal(start),
        FLColorValuesRgbToDecimal(end),
        NO };
    return range;
}

NS_INLINE
FLColorRangeColorValues FLColorRangeMakeRGB(FLColorValues start, FLColorValues end) {
    FLColorRangeColorValues range = {
        FLColorValuesDecimalToRgb(start),
        FLColorValuesDecimalToRgb(end),
        YES };

    return range;
}