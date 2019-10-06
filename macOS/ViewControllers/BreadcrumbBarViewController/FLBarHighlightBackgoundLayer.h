//
//  FLBarHighlightBackgound.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <QuartzCore/QuartzCore.h>
#import "FishLampOSX.h"

@interface FLBarHighlightBackgoundLayer : CALayer {
@private
    NSColor* _lineColor;
}
@property (readwrite, strong, nonatomic) NSColor* lineColor;

@end
