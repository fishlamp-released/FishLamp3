//
//  FLBreadcrumbBarView.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 1/15/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBreadcrumbBarView.h"
#import "FLCoreText.h"
#import "FLColorRange+Gradients.h"
#import "FLColorUtilities.h"
#import "FLGeometry.h"

#define ArrowWidth 10.0f
#define kWideWidth 100
#define kTallHeight 50

@interface FLBreadcrumbBarView ()
@end

@implementation FLBreadcrumbBarView  

@synthesize delegate = _delegate;
@synthesize titles = _titles;
@synthesize highlightLayer = _highlightLayer;
@synthesize titleTop = _titleTop;

#if FL_MRC
- (void) dealloc {
    [_titles release];
    [_highlightLayer release];
    [super dealloc];
}
#endif

- (void) awakeFromNib {
    [super awakeFromNib];
    _titleTop = (kTallHeight*4);

    if(!_titles) {
        _titles = [[NSMutableArray alloc] init];

        self.wantsLayer = YES;
        self.layer = [CALayer layer];
        
        CGColorRef colorRef = [[NSColor gray237Color] copyCGColorRef];
        self.layer.backgroundColor = colorRef;
        CFRelease(colorRef);
        
        _highlightLayer = [[FLBarHighlightBackgoundLayer alloc] init];
        _highlightLayer.hidden = YES;
        _highlightLayer.lineColor = [SDKColor gray85Color];
    
        [self.layer addSublayer:_highlightLayer];
    }
    
//    [self setNeedsDisplay:YES];
}

- (void) updateLayout:(BOOL) animated {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

    FLNavigationTitle* highlightedTitle = nil;

    CGRect bounds = NSRectToCGRect(self.bounds);
    CGFloat top = NSMaxY(NSRectFromCGRect(bounds));

    for(FLNavigationTitle* title in _titles) {
        
        if(title.isHidden) {
            continue;
        }

        CGRect frame = bounds;
        frame.size.height = title.titleHeight; 
        frame.origin.y = top - frame.size.height;

        if(!CGRectEqualToRect(title.frame, frame)) {
            title.frame = frame;
        }
        [title setNeedsDisplay];
        if(title.isSelected) {
            highlightedTitle = title;
        }
        top -= frame.size.height;
    }

    [CATransaction commit];
    
    if(highlightedTitle) {
        if(!animated) {
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        }
                
        if(_highlightLayer.isHidden) {
            _highlightLayer.hidden = NO;
        }
        
        CGRect highlightFrame = CGRectSetWidth(highlightedTitle.frame, highlightedTitle.frame.size.width + 11);
        if(!CGRectEqualToRect(_highlightLayer.frame, highlightFrame)) {
            _highlightLayer.frame = highlightFrame;
        }
        
        if(!animated) {
            [CATransaction commit];
        }

        [_highlightLayer setNeedsDisplay];
    }
    else {
        if(!_highlightLayer.isHidden) {
            _highlightLayer.hidden = YES;
        }
    }

    [self setNeedsDisplay:YES];
        
}

- (void) addTitle:(FLNavigationTitle*) title {
    [_titles addObject:title];
    [self.layer addSublayer:title];
    
    if(!title.isHidden) {
        [title setNeedsDisplay];
        [self updateLayout:NO];
        self.needsDisplay = YES;
    }
}

- (void) handleMouseMoved:(CGPoint) location mouseIn:(BOOL) mouseIn mouseDown:(BOOL) mouseDown {
    for(FLNavigationTitle* title in _titles) {
        if(title.isHidden) {
            continue;
        }
        
        BOOL mouseInTitle = CGRectContainsPoint(title.frame, location);
        [self.delegate titleNavigationController:self handleMouseMovedInTitle:title mouseIn:mouseInTitle];
        
        if(mouseInTitle) {
            [title handleMouseMoved:location mouseIn:YES mouseDown:mouseDown];
        }
        else {
            [title handleMouseMoved:location mouseIn:NO mouseDown:NO];
        }
    }
}

- (void) handleMouseUpInside:(CGPoint) location {
    for(FLNavigationTitle* title in _titles) {
        if(title.isHidden) {
            continue;
        }
        
        if(CGRectContainsPoint(title.frame, location)) {
            [self.delegate titleNavigationController:self handleMouseDownInTitle:title];
            break;
        }
    }
}

- (void) setFrame:(NSRect) frame {
    [super setFrame:frame];
    [self updateLayout:NO];
}



@end


