//
//  FLDrawableBorder.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 12/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDrawable.h"

@interface FLDrawableBorder : NSObject<FLDrawable> {
@private
	CGFloat _cornerRadius;
	SDKColor* _borderColor;
	CGFloat _lineWidth;
}

@property (readwrite, assign, nonatomic) CGFloat lineWidth;
@property (readwrite, assign, nonatomic) CGFloat cornerRadius;
@property (readwrite, strong, nonatomic) SDKColor* borderColor;

@end
