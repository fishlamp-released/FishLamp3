//
//  FLAnimatedImageView.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/11/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAnimatedImageView.h"
#import "FLRotateAnimation.h"
#import "FLCompatibility.h"

@implementation FLAnimatedImageView

@synthesize image = _image;
@synthesize animate = _animate;
@synthesize displayedWhenStopped = _displayedWhenStopped;
@synthesize animation = _animation;
@synthesize animationLayer = _animationLayer;

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if FL_MRC
    [_animation release];
    [_animationLayer release];
    [super dealloc];
#endif
}

- (void) willInitAnimationLayer {
    self.autoresizesSubviews = NO;
    self.autoresizingMask = 0;

    self.wantsLayer = YES;
    self.layer = [CALayer layer];
    
    _animation = [[FLSomersaultAnimation alloc] init];
    _animation.duration = 0.1f;
    _animation.direction = FLAnimationDirectionRight;
    _animation.axis = FLAnimationAxisZ;
    _animation.timing = FLAnimationTimingLinear;
    _animation.duration = 1.0f;
    
    _animationLayer = [[CALayer alloc] init];
    _animationLayer.position = CGPointMake(self.bounds.size.width/2.0,self.bounds.size.height/2.0);
    _animationLayer.bounds = CGRectMake(0,0,self.bounds.size.width, self.bounds.size.height);
    [self.layer addSublayer:_animationLayer];
}

- (void) setDisplayedWhenStopped:(BOOL) visible {
    _displayedWhenStopped = visible;
    if(_displayedWhenStopped) {
        
        if(self.isHidden) {
            self.hidden = NO;
        }
    }
    else {
        BOOL hide = !_animate;
        if(self.isHidden != hide) {
            self.hidden = hide;
        }
    }
}

//- (id) initWithCoder:(NSCoder *)aDecoder {
//    return [[super initWithCoder:aDecoder] setupAnimatedImageView];
//}

- (id)initWithFrame:(NSRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        if(!_animation) {
            [self willInitAnimationLayer];
        }

        if(!self.isHidden) {
            self.hidden = YES;   
        }
    }
    
    return self;
}

- (void) setImage:(SDKImage*) image {
    FLSetObjectWithRetain(_image, image);

    if(_animationLayer) {
        _animationLayer.contents = image;
    }
}

- (void) viewDidMoveToSuperview {
    [super viewDidMoveToSuperview];
    
    if(self.superview) {
        if(_animate) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startAnimating];
            });
        }
        if(_displayedWhenStopped) {
            if(self.isHidden) {
                self.hidden = NO;
            }
        }
    }
    else {
        _animate = NO;
        _animationIsAnimating = NO;
    }
}

- (void) didStartAnimating {

    if(_animation) {
        [_animation startAnimating:_animationLayer completion:^{
            [self didStopAnimating];
            
            if(self->_animate) {
                [self startAnimating];
            }
            else {
                [self stopAnimating];
            }
        }];
        [self setNeedsDisplay:YES];
    }
    
}
- (void) startAnimating {
    _animate = YES;
    
    if(self.isHidden) {
        self.hidden = NO;
    }
          
    if(!_animationIsAnimating) {
        _animationIsAnimating = YES;
        [self didStartAnimating];
    }
    
}

- (void) didStopAnimating {
    _animationIsAnimating = NO;
    
   if(!_displayedWhenStopped) {
        if(!self.isHidden) {
            self.hidden = YES;
        }
    }
}

- (void) stopAnimating {
    _animate = NO;
    [self didStopAnimating];
}

- (void) showNetworkProgress:(id) sender {
    [self startAnimating];
}

- (void) hideNetworkProgress:(id) sender {
    [self stopAnimating];
}

- (void) setImageWithNameInBundle:(NSString*) name {
#if __MAC_10_8
    if(OSXVersionIsAtLeast10_7()) {
        self.image = [[NSBundle mainBundle] imageForResource:[name stringByDeletingPathExtension]];
    }
    else
#endif         
        {
        NSString* defaultImagePath = [[NSBundle mainBundle] pathForImageResource:name];
        self.image = FLAutorelease([[NSImage alloc] initWithContentsOfFile:defaultImagePath]);
    }
}


@end
