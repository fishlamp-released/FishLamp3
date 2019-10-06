//
//  FLNavigationTitle.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLNavigationTitle.h"
#import "FLAttributedString.h"
#import "FLCoreText.h"
#import "FLColorModule.h"
#import "FLGeometry.h"

@interface FLNavigationTitle ()
@property (readwrite, strong, nonatomic) id identifier;
@end

@implementation FLNavigationTitle

@synthesize highlighted = _highlighted;
@synthesize enabled = _enabled;
@synthesize selected = _selected;
@synthesize identifier = _identifier;
@synthesize titleHeight = _titleHeight;

+ (id) layer {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {	
	return [self initWithIdentifier:nil ];
}

- (id) initWithIdentifier:(id) identifier {
	self = [super init];
	if(self) {
        _stringController = [[FLAttributedStringController alloc] init];
        _stringController.delegate = self;

        self.identifier = identifier;
        self.titleHeight = FLNavigationTitleDefaultHeight;
	}
	return self;
}

+ (id) navigationTitle:(id) identifier  {
    return FLAutorelease([[[self class] alloc] initWithIdentifier:identifier]);
}

#if FL_MRC
- (void) dealloc {
    [_identifier release];
    [_stringController release];
    [super dealloc];
}
#endif

- (void) attributedStringController:(FLAttributedStringController*) controller 
          addAttributesToDictionary:(NSMutableDictionary*) attr 
                    forDisplayState:(FLStringDisplayState) displayState {

    NSColor* bgColor = [NSColor clearColor];
    NSColor* fgColor = nil;
    NSColor* shadowColor = nil;
    
    switch(displayState) {
        case FLStringDisplayStateEnabled:
            fgColor = [NSColor darkGrayColor];
            shadowColor = [NSColor whiteColor];
        break;
        
        case FLStringDisplayStateDisabled:
            fgColor = [NSColor lightGrayColor];
            shadowColor = [NSColor whiteColor];
        break;

        case FLStringDisplayStateHighlighted:
        case FLStringDisplayStateMouseDownIn:
            fgColor = [NSColor whiteColor];
            bgColor = [NSColor darkGrayColor];
            shadowColor = [NSColor blackColor];
        break;
        
        case FLStringDisplayStateSelected:
            fgColor = FLColorFromHexColorString(@"#c56519");

//            [shadow setShadowColor:[NSColor gray85Color]];
//            [shadow setShadowColor:FLColorFromHexColorString(@"#ef8039" )];
//            shadow = nil;
        break;
        
        case FLStringDisplayStateHovering:
        case FLStringDisplayStateMouseDownOut:
            fgColor = [NSColor whiteColor];
            bgColor = [NSColor grayColor];
            shadowColor = [NSColor blackColor];
        break;
    }

    if(bgColor) {
        CGColorRef colorRef = [bgColor copyCGColorRef];
        [self setBackgroundColor:colorRef];
        CFRelease(colorRef);
    }

    if(shadowColor) {
        NSShadow* shadow = FLAutorelease([[NSShadow alloc] init]);
        [shadow setShadowColor:shadowColor];
        [shadow setShadowOffset:NSMakeSize( 1.0, -1.0 )];
        [shadow setShadowBlurRadius:1.0];        
        [attr setObject:shadow forKey:NSShadowAttributeName];
    }
    else {
        [attr removeObjectForKey:NSShadowAttributeName];
    }
    
    if(fgColor) {
        [attr setObject:fgColor forKey:NSForegroundColorAttributeName];
    }
    
    [attr setObject:[NSFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
}

- (void) stateDidChange {
    FLStringDisplayState displayState = FLStringDisplayStateDisabled;
    if(_enabled) {
        displayState = FLStringDisplayStateEnabled;        
        
        if(_selected) {
            displayState = FLStringDisplayStateSelected;
        }
        else if(_mouseDown) {
            if(_mouseIn) {
                displayState = FLStringDisplayStateMouseDownIn;
            }
            else {
                displayState = FLStringDisplayStateMouseDownOut;
            }
        }
        else if(_mouseIn) {
            displayState = FLStringDisplayStateHovering;
        }
    } 
    
    _stringController.displayState = displayState;
}

- (void) handleMouseMoved:(CGPoint) location mouseIn:(BOOL) mouseIn mouseDown:(BOOL) mouseDown {
    
    if(!_enabled) {
        return;
    }
    
    if(_mouseIn != mouseIn) {
        _mouseIn = mouseIn;
        [self stateDidChange];
    } 

    if(_mouseDown != mouseDown) {
        _mouseDown = mouseDown;
        [self stateDidChange];
    }
}

- (void) handleMouseUpInside:(CGPoint) location {
    [self stateDidChange];
}

- (void) setEnabled:(BOOL) enabled {
    if(_enabled != enabled) {
        _enabled = enabled;
        [self stateDidChange];
    }
}

- (void) setSelected:(BOOL)selected {
    if(_selected != selected) {
        _selected = selected;
        [self stateDidChange];
    }
}

- (void) setHighlighted:(BOOL)highlighted {
    if(_highlighted != highlighted) {
        _highlighted = highlighted;
        [self stateDidChange];
    }
}

- (void) attributedStringControllerDidChangeString:(FLAttributedStringController*) controller {
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef) context {
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext
        graphicsContextWithGraphicsPort:context flipped:NO]];

    NSAttributedString* string = _stringController.attributedString;

    CGContextSetTextMatrix(context, CGAffineTransformIdentity );
    CGRect frame = CGRectZero;
    frame.size = NSSizeToCGSize([string  size]);
    frame = CGRectOptimizedForViewLocation(CGRectCenterRectInRect(self.bounds, frame));
    [string  drawInRect:NSRectFromCGRect(frame)];
    [NSGraphicsContext restoreGraphicsState];

#if TRACE
    FLDebugLog(@"draw title: %@", _localizedTitle);
#endif    
}

- (void) setLocalizedTitle:(NSString*) localizedTitle {
    _stringController.string = localizedTitle;
}

- (NSString*) localizedTitle {
    return _stringController.string;
}

@end
