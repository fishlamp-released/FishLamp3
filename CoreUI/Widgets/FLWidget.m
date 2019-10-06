//
//	FLTableViewCellwidgetBehavior.m
//	FishLamp
//
//	Created by Mike Fullerton on 3/5/11.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLWidget.h"
//#import "SDKView+FLViewGeometry.h"
#import "FLGeometry.h"

#import "FishLampSimpleLogger.h"

@interface FLWidget ()
@property (readwrite, assign, nonatomic, getter=isParentHidden) BOOL parentHidden;
@property (readwrite, assign, nonatomic) id parent;

@end

@interface SDKView (FLWidgetPrivate)
- (SDKView*) view;
@end

@implementation SDKView (FLWidgetPrivate)
- (SDKView*) view {
    return self;
}   
@end

@implementation FLWidget 
@synthesize subWidgets = _subWidgets;
@synthesize parent = _parent;
@synthesize backgroundColor = _backgroundColor;

#if INTERACTIVE
@synthesize touchHandler = _touchHandler;
@synthesize userInteractionEnabled = _userInteractionEnabled;
#endif

@synthesize parentHidden = _parentHidden;
@synthesize alpha = _alpha;
#if ARRANGEMENT 
@synthesize subWidgetArrangement = _arrangement;
#endif
#if LAYOUT
@synthesize positionInParent = _positionInParent;
#endif

@synthesize frame = _frame;
@synthesize drawable = _drawable;

//
//- (void) setLayoutFrame:(CGRect) layoutFrame {
//    [self setFrameOptimizedForLocation:layoutFrame];
//}

- (id) init {
	return [self initWithFrame:CGRectZero];
}

- (id) initWithWidgetFrame:(CGRect) frame {
    self = [super init];
	if(self) {
        _frame = frame;
        _alpha = 1.0;
	}
	
	return self;
}

- (id) initWithFrame:(CGRect) frame {
    return [self initWithWidgetFrame:frame];
}

+ (id) widgetWithFrame:(CGRect) frame {
	return FLAutorelease([[[self class] alloc] initWithWidgetFrame:frame]);
}

+ (id) widget {
	return FLAutorelease([[[self class] alloc] init]);
}

- (void) setBackgroundColor:(SDKColor*) color {
	FLSetObjectWithRetain(_backgroundColor, color);
    [self setNeedsDisplay];
}

- (void) removeAllSubWidgets {   
    NSArray* widgets = _subWidgets;
    _subWidgets = nil;

    for(FLWidget* widget in widgets) {
        [widget removeFromParent];
    }

	FLRelease(widgets);
}

- (void) setAlpha:(CGFloat) alpha {
    if(!FLFloatEqualToFloat(alpha, alpha)) {
        _alpha = alpha;
        [self setNeedsDisplay];
    }
}

- (void) dealloc {
    [self removeAllSubWidgets];

#if INTERACTIVE
    _touchHandler.touchableObject = nil;
#endif    

#if FL_MRC

#if ARRANGEMENT 
    [_arrangement release];
#endif

#if INTERACTIVE
    [_touchHandler release];
#endif    

    [_drawable release];
    [_backgroundColor release];
    [super dealloc];
#endif    
}

- (void) layoutIfNeeded {
    [self layoutSubWidgets];
    [self setNeedsDisplay];
}

- (void) setNeedsLayout {
    [self layoutIfNeeded];

    for(FLWidget* widget in _subWidgets) {
        
#if LAYOUT
        widget.frame = FLRectLayoutRectInRect(self.frame, widget.frame,widget.positionInParent);
#endif                
        [widget setNeedsLayout];
    }
           
    [self setNeedsDisplay];
}

- (void) visitWidgets:(void (^)(id widget, BOOL* stop)) visitor stop:(BOOL*) stop {
    for(FLWidget* widget in self.subWidgets) {

        visitor(widget, stop);

        if(*stop) {
            return;
        }
        
        [widget visitWidgets:visitor stop:stop];
        
        if(*stop) {
            return;
        }
        
    }
}

- (void) visitWidgets:(void (^)(id widget, BOOL* stop)) visitor {
	FLAssertNotNil(visitor);
    BOOL stop = NO;
    [self visitWidgets:visitor stop:&stop];
}

- (NSString*) description {
    id parent = self.parent;

	return [NSString stringWithFormat:@"%@: parent:%@; frame:%@; in view:%@",
		[super description],
		NSStringFromClass([parent class]),
		NSStringFromCGRect(self.frame),
		[self.view description]
		];
}

- (void) layoutSubWidgets {
}

- (void) setFrame:(CGRect) frame {
#if DEBUG
	if(frame.origin.x > 5000 || frame.origin.x < -5000) {
		FLDebugLog(@"widget frame is out of bounds");
	}
#endif

	if(!CGRectEqualToRect(frame, self.frame)) {
#if DEBUG
#if IOS
		if(!CGRectIsIntegral(frame)) {
			FLDebugLog(@"Warning setting non-integral rect in widget: %@", NSStringFromCGRect(frame));
		}
#endif        
#endif	
	
		CGPoint offset = CGPointSubtractPointFromPoint(frame.origin, self.frame.origin);
		if(!CGPointEqualToPoint(offset, CGPointZero)) {
			for(FLWidget* widget in _subWidgets) {
				widget.frame = CGRectMoveWithPoint(widget.frame, offset);
			}
		}
		
		_frame = frame;

		[self setNeedsDisplay];
		[self didChangeFrame];
   
#if 0
		[SDKView warnIfNonIntegralFramesInViewHierarchy:self.view];
#endif
	}
}

- (void) updateParentHidden {
    id parent = _parent;
    self.parentHidden = [parent isHidden];
    [self visitWidgets:^(id widget, BOOL* stop){
        [widget updateParentHidden];
    }];
}

- (BOOL) isHidden {
	return  _hidden || _parentHidden;
}

- (void) setHidden:(BOOL) hidden {
	if(_hidden != hidden) {
		_hidden = hidden;
        [self updateParentHidden];
        [self didChangeHidden];
		[self setNeedsDisplay];
	}
}

#if CONTROLS
- (void) setControlState:(FLControlState) controlState {
    [super setControlState:controlState];
        
    [self visitWidgets:^(id widget, BOOL* stop) {
        [widget setControlState:controlState];
    }];

    [self.view setNeedsDisplay];
}
#endif

- (BOOL) pointIsInside:(CGPoint)point {
	return CGRectContainsPoint(self.frame, point);
}	

- (FLWidget *)hitTest:(CGPoint)point {
	for(FLWidget* widget in _subWidgets) {
		if(!widget.isHidden && CGRectContainsPoint(widget.frame, point)) {
			FLWidget* touched = [widget hitTest:point];
			if(touched) {
				return touched;
			}
		}
	}
	
	if([self pointIsInside:point]) {
		return self;
	} 
	
	return nil;
}

- (void) didChangeFrame {
}


- (void) didChangeHidden {
}

- (void) setNeedsDisplay {
	if(self.view) {
#if IOS
		[self.view setNeedsDisplayInRect:CGRectInset(self.frame, -4.0,-4.0)];
#else
    FLAssertFailed();
#endif
	}
}

- (void) didMoveToParent:(id) parent {
}

- (FLWidget*) widgetAtIndex:(NSUInteger) widgetIndex {
    return [_subWidgets objectAtIndex:widgetIndex];
}

- (void) addWidget:(FLWidget*) widget  {
    [self insertWidget:widget atIndex:_subWidgets ? _subWidgets.count : 0];
}

- (void) insertWidget:(FLWidget*) widget atIndex:(NSUInteger) index {
	if(!_subWidgets) {
		_subWidgets = [[NSMutableArray alloc] init];
	}
	
    FLAssert(widget != self, @"can't add yourself to your subWidgets!");
    FLAssert(widget != self.parent, @"can't add your parent to your subWidgets!");
    
	[_subWidgets insertObject:widget atIndex:index];
	if(widget.parent) {
        [widget removeFromParent];
    }

	widget.parent = self;
}

- (void) willRemoveSubWidget:(FLWidget*) widget {
}

- (void) didRemoveSubWidget:(FLWidget*) widget {
}

- (void) removeWidget:(FLWidget*) widget {
	FLAssert(widget.parent == self, @"attempting to remove subwidget from non-owning superwidget");
    if(_subWidgets && widget.parent == self) {
        [self willRemoveSubWidget:widget];
        [_subWidgets removeObject:FLRetainWithAutorelease(widget)];
        widget.parent = nil;
        [self didRemoveSubWidget:widget];
        [self setNeedsDisplay];
    }    
}

- (void) setParent:(id) parent {
    _parent = parent;
    [self updateParentHidden];
    [self didMoveToParent:parent];
}

- (void) addToView:(SDKView*) view {
    self.parent = view;
}

- (void) removeFromParent {
    id parent = _parent;
    if(parent) {
        [parent removeWidget:self];
    }
}

- (CGRect) bounds {
    return _frame;
}

- (void) drawBackgroundColor:(CGRect) drawRect {
//  The color with alpha can be created when either the background color or alpha is changed 
//  and it can be member data instead of the SDKColor for the background.

//  I Also don't ike the comparison for check the clear color. 
//  When setting the color property for a widget if the color is the clear color, just
//  set the background color to nil, then we can avoid the comparison while drawing.

TODO("MF: optimize this.")

#if IOS
    if(self.backgroundColor && ![self.backgroundColor isEqual:[SDKColor clearColor]]) {
        CGContextRef context = CGGetCurrentContext();
        CGContextSaveGState(context);
        CGColorRef fillColor = CGColorCreateCopyWithAlpha(self.backgroundColor.CGColor, self.alpha);
        CGContextSetFillColorWithColor(context, fillColor);
        CGContextFillRect( context , CGRectIntersection(self.frame, drawRect) );
        CGContextRestoreGState(context);
        CGColorRelease(fillColor);
    }
#endif    
}

- (void) drawSubWidgets:(CGRect) drawRect {
     for(FLWidget* widget in _subWidgets) {
         if(CGRectIntersectsRect(widget.frame, drawRect) &&  // if widget intersects drawing area.
            CGRectIntersectsRect(widget.frame, self.frame)) { // if widget intersects parent frame
             [widget drawWidget:drawRect];
         }
     }
}

- (void) drawWidget:(CGRect) drawRect {
    FLAssertNotNil(self.view);

// TODO: investigate coordinate system
//                    CGContextTranslateCTM(context, 0.0, boxOffset);
    
  	if(!self.isHidden && CGRectIntersectsRect(self.frame, drawRect)) {
        
        [self drawBackgroundColor:drawRect];
        
        __block BOOL didDrawSubWidgets = NO;
        dispatch_block_t block = ^{
            didDrawSubWidgets = YES;
            [self drawSubWidgets:drawRect];
        };
                
        if(_drawable) {
            [_drawable drawRect:drawRect withFrame:_frame inParent:_parent drawEnclosedBlock:block];
        }
        else {
            [self drawRect:drawRect drawSubWidgets:block];
        }

        if(!didDrawSubWidgets) {
            [self drawSubWidgets:drawRect];
        }
    }
}

- (void) drawRect:(CGRect) rect 
   drawSubWidgets:(dispatch_block_t) drawSubWidgets {

    [self drawRect:rect];
}

- (void) drawRect:(CGRect) rect {
}

- (SDKView*) view {
    id parent = _parent;
    return parent ? [parent view] : nil;
}

#if INTERACTIVE
- (FLWidget *)hitTest:(CGPoint)point interactiveCellsOnly:(BOOL) interactiveCellsOnly {
	for(FLWidget* widget in _subWidgets) {
		if(!widget.isHidden && CGRectContainsPoint(widget.frame, point)) {
			FLWidget* touched = [widget hitTest:point interactiveCellsOnly:interactiveCellsOnly];
			if(touched) {
				return touched;
			}
		}
	}
	
	if([self pointIsInside:point] && (self.canBeTouched || !interactiveCellsOnly)) {
		return self;
	} 
	
	return nil;
}
- (void) setTouchHandler:(FLTouchHandler*) touchHandler {
    if(_touchHandler) {
        _touchHandler.touchableObject = nil;
    }
    
    FLSetObjectWithRetain(_touchHandler, touchHandler);
    _touchHandler.touchableObject = self;
    
    __block id myself = self;
    _touchHandler.onSelected = ^(id widget) {
// TODO: should we just pass the widget instead of self? ARC conversion issue
        [self.view widgetWasTouched:myself];
    };
}

- (FLWidget*) topInteractiveWidget {
	for(FLWidget* widget in _subWidgets) {
		if(widget.canBeTouched) {
			return widget;
		}
	}
	for(FLWidget* widget in _subWidgets) {
		if(widget.canBeTouched) {
			FLWidget* outWidget = [widget topInteractiveWidget];
			if(outWidget) {
				return outWidget;
			}
		}
	}
	
	return nil;
}

- (BOOL) canBeTouched {
    return  self.touchHandler != nil && 
            !self.touchHandler.isDisabled && 
            !self.isDisabled && 
            !self.isHidden && 
            !_parentHidden;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    if(self.canBeTouched) {
        if(self.touchHandler) {
            [self.touchHandler touchesBegan:touches withEvent:event];
        }
    }    
    
    for(FLWidget* widget in _subWidgets) {
        [widget touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.canBeTouched) {
        if(self.touchHandler) {
            [self.touchHandler touchesMoved:touches withEvent:event];
        }
    }
    for(FLWidget* widget in _subWidgets) {
        [widget touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.canBeTouched) {
        if(self.touchHandler) {
            [self.touchHandler touchesEnded:touches withEvent:event];
        }
    }
    for(FLWidget* widget in _subWidgets) {
        [widget touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if(self.canBeTouched) {
        if(self.touchHandler) {
            [self.touchHandler touchesCancelled:touches withEvent:event];
        }
    }
    for(FLWidget* widget in _subWidgets) {
        [widget touchesCancelled:touches withEvent:event];
    }
}
#endif

#if GRID
- (void) didMoveToGridCell:(FLGridCell*) cell {
    _gridViewCell = cell;
    for(FLWidget* view in self.subWidgets) {
        [view didMoveToGridCell:cell];
    }
}

- (id) gridCell {
    return _gridViewCell;
}
#endif

@end
#if ARRANGEMENT 
@implementation FLWidget (FLArrangeable)

- (id) lastSubwidgetByWeight:(FLArrangeableWeight) weight {
    return [NSObject lastSubframeByWeight:weight subframes:self.subWidgets];
}

- (void) layoutSubwidgetsWithArrangement:(BOOL) adjustSize {
    FLArrangement* layout = self.subWidgetArrangement;
    if(layout) {
        CGRect bounds = [self frame];
        bounds.size = [layout performArrangement:[self subWidgets] inBounds:bounds];
        if(adjustSize) {
            [self setFrame:bounds];
        }
    }

    for(id subview in self.subWidgets) {
        [subview layoutSubwidgetsWithArrangement:YES];
    }
}

//-(void) visitSubviews:(void (^)(id view)) visitor {
//	[self visitWidgets:visitor];
//}


//- (void) autoPositionInRect:(CGRect) bounds;
- (void) autoPositionInRect:(CGRect) bounds {
    self.frameOptimizedForLocation = FLRectPositionRectInRectWithpositionInParent(bounds, self.frame, self.positionInParent);
}



@end
#endif

#if NOT_USED
void (^FLWidgetSunburstHighlighter)(FLWidget* viewwidget, CGRect rect) = ^(FLWidget* viewwidget, CGRect rect) {
	viewwidget.view.clipsToBounds = NO;
	viewwidget.view.superview.clipsToBounds = NO;
	CGContextRef context = CGGetCurrentContext();
	CGContextSaveGState(context);

//	  CGRect bigRect = FLRectScale(viewwidget.frame, 4.0);
//	  bigRect = FLRectCenterOnPoint(bigRect, FLRectGetCenter(viewwidget.frame));

	CGPoint startPoint = FLRectGetCenter(viewwidget.frame);
	CGPoint endPoint = startPoint;
   
	FLColorValues color = [SDKColor whiteColor].rgbColorValues;
	FLColorValues end = [SDKColor grayColor].rgbColorValues;
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[] = {
		color.red,	color.green, color.blue, 0.80,
		end.red,	end.green, end.blue, 0.0,
	};
	CGGradientRef	gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGColorSpaceRelease(rgb);	 

	CGContextSetShadowWithColor(context, 
					CGSizeZero, 
					20.0, 
					[SDKColor blackColor].CGColor);

	CGFloat sunburstSize = 26.0f;

	CGContextDrawRadialGradient(context, 
		gradient, 
		startPoint, 
		sunburstSize * 0.25, // 0.125, 
		endPoint, 
		sunburstSize * 1.25f, 
		kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);

	CGGradientRelease(gradient);
	CGContextRestoreGState(context);
	
};
#endif
