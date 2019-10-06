//
//  FLImagePlaceholderView.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 3/11/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLImagePlaceholderView.h"
#import "FLGeometry.h"

@interface FLImagePlaceholderView ()
//@property (readwrite, assign, nonatomic) CGFloat frameWidth;
@end

@implementation FLImagePlaceholderView

@synthesize frameWidth = _frameWidth;
@synthesize alwaysProportionallyResize = _alwaysProportionallyResize;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = NO;
        
        _alwaysProportionallyResize = YES;
        _frameWidth = 4.0;
        self.autoresizesSubviews = NO;
        
//        self.backgroundColor = [NSColor gray95Color];
        _progress = [[FLSpinningProgressView alloc] initWithFrame:NSRectMake(0,0,19,19)];
        _progress.frame = NSRectCenterRectInRect(self.bounds, _progress.frame);
    }

    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    _imageView.imageAlignment = NSImageAlignCenter;
    _imageView.imageScaling = NSImageScaleProportionallyDown;
    _imageView.imageFrameStyle = NSImageFrameNone;
    _imageView.hidden = NO;
}

#if FL_MRC
- (void) dealloc {
    [_progress release];
    [super dealloc];
}
#endif

- (void) setFrame:(NSRect) frame {
    [super setFrame:frame];
    
    _progress.frame = NSRectOptimizedForViewLocation(NSRectCenterRectInRect(self.bounds, _progress.frame));
    _imageView.frame = NSRectMake(_frameWidth, _frameWidth, self.bounds.size.width - (_frameWidth*2), self.bounds.size.height - (_frameWidth*2));
}

- (void) resizeToProportionalImageSize {
    if(_imageView.image) {
        
        NSRect bounds = self.superview.bounds;
    
        NSRect frame = NSInsetRect(bounds, _frameWidth, _frameWidth);
        frame = NSRectFitInRectInRectProportionally(frame, NSRectMake(0,0,_imageView.image.size.width, _imageView.image.size.height));
        frame.size.width += (_frameWidth*2);
        frame.size.height += (_frameWidth*2);
        frame.origin.x = bounds.size.width - frame.size.width;
        
        frame = NSRectOptimizedForViewLocation(
                    NSRectCenterRectInRectVertically(self.superview.bounds, frame));

    // image view frame is set in self setFrame
        self.frame = frame;
    }
}

- (void) startAnimating {
    _animating = YES;
    [_imageView removeFromSuperview];
    _imageView.image = nil;
    [self addSubview:_progress];
    [_progress startAnimation:self];
    self.frame = self.superview.bounds;
}

- (void) stopAnimating {
    _animating = NO;
    [_progress stopAnimation:self];
    [_progress removeFromSuperview];
    [self addSubview:_imageView];
}

- (void) viewDidMoveToSuperview {
    [super viewDidMoveToSuperview];
    if(self.superview) {
        self.frame = self.superview.bounds;
    }
}

- (void) setImage:(NSImage*) image {
    
    _imageView.image = image;
    if(image) {
        [self stopAnimating];
        
        if(_alwaysProportionallyResize) {
            [self resizeToProportionalImageSize];
        }
    }
    else {
        [self startAnimating];
    }
}

- (void) removeImage {
    _imageView.image = nil;
}

@end
