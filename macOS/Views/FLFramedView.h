//
//  FLFramedView.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"

@interface FLFramedView : NSView {
@private
    NSColor* _frameColor;
    NSColor* _backgroundColor;
    CGFloat _borderWidth;
}
@property (readwrite, assign, nonatomic) CGFloat borderWidth;
@property (readwrite, strong, nonatomic) NSColor* frameColor;
@property (readwrite, strong, nonatomic) NSColor* backgroundColor;
@end

@interface FLGrayFilledFramedView : FLFramedView

@end