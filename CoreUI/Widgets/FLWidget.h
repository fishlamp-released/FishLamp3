//
//	FLTableViewCellContentBehavior.h
//	FishLamp
//
//	Created by Mike Fullerton on 3/5/11.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLDrawable.h"

#if LAYOUT
#import "FLRectLayout.h"
#endif

#if INTERACTIVE
#import "FLTouchHandler.h"
#endif

#if ARRANGEMENT 
#import "FLArrangement.h"
#endif

#if GRID
#import "FLGridCellAware.h"
#endif

///FLGridCellAware
@interface FLWidget : NSObject  {
@private
    __weak id _parent;
    NSMutableArray* _subWidgets;

// visible properties
    SDKColor* _backgroundColor;
    CGFloat _alpha;
    CGRect _frame;
    
// state    
    BOOL _parentHidden;
    BOOL _hidden;
    
// drawable
    id<FLDrawable> _drawable;
    
// layout
#if LAYOUT
    FLRectLayout _positionInParent;
#endif
    
#if ARRANGEMENT    
    FLArrangement* _subWidgetArrangement;
#endif    

#if GRID
    id _gridViewCell;
#endif    

#if INTERACTIVE
    BOOL _userInteractionEnabled;
    FLTouchHandler* _touchHandler;
#endif
} 

- (id) init;
- (id) initWithWidgetFrame:(CGRect) frame;
+ (id) widgetWithFrame:(CGRect) frame;
+ (id) widget;

@property (readwrite, assign, nonatomic) CGRect frame;
@property (readonly, assign, nonatomic) CGRect bounds; // bounds is the same as frame since we're drawing in view coordinates.

//
// subWidgets
//
// a parent can be another widget or a view.
@property (readonly, strong, nonatomic) NSArray* subWidgets;
#if ARRANGEMENT 
@property (readwrite, strong, nonatomic) FLArrangement* subWidgetArrangement;
#endif

@property (readonly, assign, nonatomic) SDKView* view;
- (void) addToView:(SDKView*) view;

@property (readonly, weak, nonatomic) id parent;

- (void) addWidget:(FLWidget*) widget;
- (void) insertWidget:(FLWidget*) widget atIndex:(NSUInteger) index;
- (void) removeAllSubWidgets;
- (void) removeFromParent; // calls [superwidget removeWidget]

- (void) willRemoveSubWidget:(FLWidget*) widget;
- (void) didRemoveSubWidget:(FLWidget*) widget;
- (void) didMoveToParent:(id) parent;

- (FLWidget*) widgetAtIndex:(NSUInteger) widgetIndex;
- (void) visitWidgets:(void (^)(id widget, BOOL* stop)) visitor; // recursive

//
// layout
//
- (void) setNeedsLayout;
- (void) layoutIfNeeded;
- (void) layoutSubWidgets;

#if LAYOUT
@property (readwrite, assign, nonatomic) FLRectLayout positionInParent;
#endif

//
// display
//
@property (readwrite, assign, nonatomic, getter=isHidden) BOOL hidden; 
@property (readwrite, assign, nonatomic) CGFloat alpha; // this overrides alpha in colors
@property (readwrite, strong, nonatomic) SDKColor* backgroundColor; // default is nil (clear).

- (void) didChangeHidden;
- (void) didChangeFrame;

- (void) setNeedsDisplay;

// 
// drawing
//
@property (readwrite, strong, nonatomic) id<FLDrawable> drawable;

- (void) drawWidget:(CGRect) drawRect; // call from view, or superwidget, etc..

// override either one of these
- (void) drawRect:(CGRect) rect;
- (void) drawRect:(CGRect) rect 
   drawSubWidgets:(dispatch_block_t) drawSubWidgets;

// hit test utils
- (BOOL) pointIsInside:(CGPoint)point;
- (FLWidget *)hitTest:(CGPoint)point;

// touches
#if INTERACTIVE
- (FLWidget *)hitTest:(CGPoint)point interactiveCellsOnly:(BOOL) interactiveCellsOnly;
@property (readwrite, assign, nonatomic) BOOL userInteractionEnabled;
@property (readonly, assign, nonatomic) BOOL canBeTouched;
@property (readwrite, strong, nonatomic) FLTouchHandler* touchHandler;

// these call into the touch handler, or call be overridden.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
// debugging
#endif

@end

#if ARRANGEMENT 
@interface FLWidget (FLArrangeable)

- (id) lastSubwidgetByWeight:(FLArrangeableWeight) weight;

- (void) layoutSubwidgetsWithArrangement:(BOOL) adjustSize;

//- (void) visitSubviews:(void (^)(id view)) visitor;
@end
#endif


// this is a c function that can customize how a widget is drawn when highlighted.
//@property (readwrite, assign, nonatomic) FLCustomHighlighter highlighter;

#if NOT_USED
extern void (^FLWidgetSunburstHighlighter)(FLWidget* widget, CGRect rect);
#endif

