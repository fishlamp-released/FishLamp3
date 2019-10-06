//
//  FLView.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/6/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if 0

#import "FLCompatibleView+OSX.h"
#import "FLCompatibleViewController+OSX.h"

@implementation FLCompatibleView 

//@synthesize backgroundColor = _backgroundColor;

//- (void)drawRect:(NSRect)dirtyRect {
//    // set any NSColor for filling, say white:
//    SDKColor* bgColor = self.backgroundColor;
//    if(bgColor) {
//        [bgColor setFill];
//        NSRectFill(dirtyRect);
//    }
//}

//- (void) setNeedsLayout {
//    [self setNeedsDisplay:YES];
//}

//- (void) setNeedsDisplay {
//    [self setNeedsDisplay:YES];
//}

- (void) layoutIfNeeded {
//    if(_needsLayout) {
//        _needsLayout = NO;
//        
////        UIViewController* controller = self.viewController;
////        if(controller) {
////            [controller viewWillLayoutSubviews];
////        }
//        [self layoutSubviews];
////        if(controller) {
////            [controller viewDidLayoutSubviews];
////        }
//    }
}

- (void) setNeedsLayout {
//    _needsLayout = YES;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self layoutIfNeeded];
//    });

}

- (BOOL) setFrameIfChanged:(SDKRect) newFrame {
	
    if(!CGRectEqualToRect(newFrame, self.frame)) {
		self.frame = newFrame;
		return YES;
	}
	
	return NO;
}

- (CGFloat) alpha {
    return self.alphaValue;
}

- (void) setAlpha:(CGFloat) alpha {
    self.alphaValue = alpha;
}

- (void) setBackgroundColor:(NSColor*) color {
    if(color) {
//        self.wantsLayer = YES;
//        
//        
//        
//        self.layer.backgroundColor = color;
    }
}

- (NSColor*) backgroundColor {
    return nil;
//    return self.layer ? self.layer.backgroundColor : nil;
}

- (BOOL) userInteractionEnabled {
    return NO;
}

- (void) setUserInteractionEnabled:(BOOL) enabled {
}


@end



//@implementation NSView (FLCompatibleView)
//- (void) bringSubviewToFront:(UIView*) view {
//    id superView = [self superview]; 
//    if (superView) {
//        FLAutoreleaseObject(FLRetain(self));
//        [self removeFromSuperview];
//        [superView addSubview:self];
//    }
//}
//
//- (void) bringToFront {
//    [self.superview bringSubviewToFront:self];
//}
//
//- (void)sendToBack {
//    id superView = [self superview]; 
//    if (superView) {
//        FLAutoreleaseObject(FLRetain(self));
//        [self removeFromSuperview];
//        [superView addSubview:self positioned:NSWindowBelow relativeTo:nil];
//    }
//}
//@end

//@implementation FLCompatibleView 
//
//@end

#endif


