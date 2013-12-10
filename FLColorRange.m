// [Generated]
//
// FLColorRange.m
// Project: FishLamp Themes
// Schema: FLColorObject
//
// Copywrite (C) 2012 GreenTongue Software, LLC. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
// [/Generated]

#import "FLColorRange.h"
#import "SDKColor+FLMoreColors.h"

@interface FLColorRange ()
@property (readwrite, assign, nonatomic) CGFloat alpha;
@property (readwrite, strong, nonatomic) SDKColor* endColor;
@property (readwrite, strong, nonatomic) SDKColor* startColor;
@end

@implementation FLColorRange

@synthesize alpha = _alpha;
@synthesize endColor = _endColor;
@synthesize startColor = _startColor;

- (id) initWithStartColor:(SDKColor*) startColor
                 endColor:(SDKColor*) endColor
{
    self = [super init];
    if(self) {
        self.startColor = startColor;
        self.endColor = endColor;
    }
    
    return self;
}

+ (FLColorRange*) colorRange:(SDKColor*) startColor
                    endColor:(SDKColor*) endColor {
    return FLAutorelease([[[self class] alloc] initWithStartColor:startColor endColor:endColor]);
}

#if FL_MRC
- (void) dealloc
{
	FLRelease(_startColor);
	FLRelease(_endColor);
	FLSuperDealloc();
}
#endif

- (id) init {
	if((self = [self initWithStartColor:nil endColor:nil])) {
	}
	return self;
}

- (FLColorRangeColorValues) decimalColorRangeValues {
//    FLColorRangeColorValues values = {
//        
//    
//        
//    };


    return FLColorRangeMakeDecimal(self.startColor.rgbColorValues, self.endColor.rgbColorValues);
}

- (FLColorRangeColorValues) rgbColorRangeValues {
    return FLColorRangeMakeRGB(self.startColor.rgbColorValues, self.endColor.rgbColorValues);
}


- (id) initWithColorValues:(FLColorRangeColorValues) colorValues {
    return [self initWithStartColor:[SDKColor colorWithColorValues:colorValues.startColor]
                           endColor:[SDKColor colorWithColorValues:colorValues.endColor]];
}

+ (id) colorRangeWithColorValues:(FLColorRangeColorValues) colorValues {
    return FLAutorelease([[[self class] alloc] initWithColorValues:colorValues]);
}


@end




