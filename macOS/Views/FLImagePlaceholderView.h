//
//  FLImagePlaceholderView.h
//  FishLampOSX
//
//  Created by Mike Fullerton on 3/11/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampOSX.h"
#import "FLSpinningProgressView.h"
#import "FLFramedView.h"

@interface FLImagePlaceholderView : FLFramedView {
@private
    FLSpinningProgressView* _progress;
    IBOutlet NSImageView* _imageView;
    CGFloat _frameWidth;
    BOOL _alwaysProportionallyResize;
    BOOL _animating;
}
@property (readwrite, assign, nonatomic) CGFloat frameWidth;

//@property (readwrite, strong, nonatomic) NSImageView* imageView;
@property (readwrite, assign, nonatomic) BOOL alwaysProportionallyResize;

- (void) startAnimating;
- (void) stopAnimating;

- (void) resizeToProportionalImageSize;

- (void) setImage:(NSImage*) image;

- (void) removeImage;

@end
