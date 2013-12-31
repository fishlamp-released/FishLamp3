//
//  FLGradientDrawing.h
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 12/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDrawable.h"
#import "FLColorRange.h"

@interface FLDrawableGradient : NSObject<FLDrawable> {
@private
    FLColorRange* _colorRange;
}
@property (readwrite, strong, nonatomic) FLColorRange* colorRange;

- (id) initWithColorRange:(FLColorRange*) colorRange;

@end
