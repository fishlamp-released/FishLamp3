//
//  FLMutableColorRange.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/13/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLColorRange.h"

@interface FLMutableColorRange : FLColorRange {
}

@property (readwrite, assign, nonatomic) CGFloat alpha;

@property (readwrite, strong, nonatomic) SDKColor* endColor;

@property (readwrite, strong, nonatomic) SDKColor* startColor;

- (void) setColorValues:(FLColorRangeColorValues) values;

@end

