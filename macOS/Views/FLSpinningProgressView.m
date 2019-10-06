//
//  FLSpinningProgressView.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/10/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSpinningProgressView.h"

//@interface FLSpinningProgressView : FLAnimatedImageView {
//@private
//    NSProgressIndicator* _spinner;
//} 
//
//- (void) setRespondsToGlobalNetworkActivity;
//
//@end

//@implementation FLSpinningProgressView
//
//#if FL_MRC
//- (void) dealloc {
//	[self release];
//	[super dealloc];
//}
//#endif
//
//- (void) willInitAnimationLayer {
//
//#if CUSTOMself
//    if(OSXVersionIsAtLeast10_8()) {
//        [super willInitAnimationLayer];
//        [self setImageWithNameInBundle:@"chasingarrows.png"];
//    }
//    else
//#endif 
//    {
//        self = [[NSProgressIndicator alloc] initWithFrame:CGRectZero];
//        [self setIndeterminate:YES];
//        [self setDisplayedWhenStopped:NO];
//        [self setStyle:NSProgressIndicatorSpinningStyle];
//        [self setBezeled: NO];
//        [self setControlSize:NSSmallControlSize];
//        [self setControlTint:NSDefaultControlTint];
//        [self sizeToFit];
//        [self addSubview:self];
//    }
//}
//
//- (void) setFrame:(SDKRect) frame {
//    [super setFrame:frame];
//    if(self) {
//        self.frame = FLRectOptimizedForViewLocation(FLRectCenterRectInRect(self.bounds, self.frame));
//    }
//}
//
//- (void) didStartAnimating {
//    if(self) {
//        [self startAnimation:nil];
//    }
//    [super didStartAnimating];
//}
//
//- (void) didStopAnimating {
//    if(self) {
//        [self stopAnimation:nil];
//    }
//    [super didStopAnimating];
//
//}
//
//@end

@implementation FLSpinningProgressView

- (void) awakeFromNib {
    [super awakeFromNib];
    [self setIndeterminate:YES];
    [self setDisplayedWhenStopped:NO];
    [self setStyle:NSProgressIndicatorSpinningStyle];
    [self setBezeled: NO];
    [self setControlSize:NSSmallControlSize];
    [self setControlTint:NSDefaultControlTint];
    [self sizeToFit];
//    self.wantsLayer = YES;
}

#if TRACE
- (void) startAnimation:(id) sender {
    [super startAnimation:sender];
    
    FLTrace(@"show animation");
}

- (void) stopAnimation:(id) sender {
    [super stopAnimation:sender];
    
    FLTrace(@"stop animation");
}
#endif

@end