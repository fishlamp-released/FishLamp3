// [Generated]
//
// FLColorRange.h
// Project: FishLamp Themes
// Schema: FLColorObject
//
// Copywrite (C) 2012 GreenTongue Software, LLC. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
// [/Generated]
#import "FishLampCore.h"
#import "FLColorRangeColorValues.h"

@interface FLColorRange : NSObject { 
@private
	SDKColor* _startColor;
	SDKColor* _endColor;
	CGFloat _alpha;
} 

@property (readonly, assign, nonatomic) CGFloat alpha;

@property (readonly, strong, nonatomic) SDKColor* endColor;

@property (readonly, strong, nonatomic) SDKColor* startColor;

@property (readonly, assign, nonatomic) FLColorRangeColorValues rgbColorRangeValues;

@property (readonly, assign, nonatomic) FLColorRangeColorValues decimalColorRangeValues;

- (id) initWithStartColor:(SDKColor*) startColor
                 endColor:(SDKColor*) endColor;

+ (FLColorRange*) colorRange:(SDKColor*) startColor
                    endColor:(SDKColor*) endColor;

- (id) initWithColorValues:(FLColorRangeColorValues) colorValues;

+ (id) colorRangeWithColorValues:(FLColorRangeColorValues) colorValues;


@end






