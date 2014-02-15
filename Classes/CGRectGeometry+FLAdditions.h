//
//  CGRectGeometry+FLAdditions.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/13/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FLMath.h"
#import "FLRectLayout.h"
#import "CGPointGeometry+FLAdditions.h"

//#if DEBUG
//    #define CGRectInset             FLRectInset
//#else
//    #define FLRectInset             NSInsetRect
//#endif

//#define FLRectMake                  CGRectMake
//#define FLRectGetMidX               CGRectGetMidX
//#define FLRectGetMidY               CGRectGetMidY
//#define FLRectEqualToRect           CGRectEqualToRect
//#define FLRectIsTaller(__lhs__, __rhs__) ((__lhs__).size.height > (__rhs___).size.height)
//#define FLRectIsWider(__lhs__, __rhs__) ((__lhs__).size.width > (__rhs__).size.width)
//
//#if IOS
//    #define FLRectInsetWithEdgeInsets   UIEdgeInsetsInsetRect
//#endif    

#if OSX
#define NSStringFromCGRect(r) NSStringFromRect(NSRectFromCGRect(r))
#endif

extern BOOL CGRectIsIntegral(CGRect r);

// centering
extern CGRect CGRectCenterOnPoint(CGRect rect, CGPoint point);
extern CGRect CGRectCenterOnPointVertically(CGRect rect, CGPoint point);
extern CGRect CGRectCenterOnPointHorizontally(CGRect rect, CGPoint point);

extern CGPoint CGRectGetCenter(CGRect rect);
extern CGRect CGRectCenterRectInRect(CGRect container, CGRect containee);
extern CGRect CGRectCenterRectInRectVertically(CGRect container, CGRect containee);
extern CGRect CGRectCenterRectInRectHorizontally(CGRect container, CGRect containee);

// justification
extern CGRect CGRectJustifyRectInRectRight(CGRect container, CGRect containee);
extern CGRect CGRectJustifyRectInRectLeft(CGRect container, CGRect containee);
extern CGRect CGRectJustifyRectInRectTop(CGRect container, CGRect containee);
extern CGRect CGRectJustifyRectInRectBottom(CGRect container, CGRect containee);
extern CGRect CGRectJustifyRectInRectTopLeft(CGRect container, CGRect containee);
extern CGRect CGRectJustifyRectInRectTopRight(CGRect container, CGRect containee);
extern CGRect CGRectJustifyRectInRectBottomRight(CGRect container, CGRect containee);
extern CGRect CGRectJustifyRectInRectBottomLeft(CGRect container, CGRect containee);

//// inset
//// this is a debugging only function that asserts that you're insetting with a reasonable
//// value. Debug only. Ship calls CGRectInset/CGRectInset
//extern CGRect CGRectInset(CGRect rect, CGFloat dx, CGFloat dy);

extern CGRect CGRectInsetTop(CGRect inRect, CGFloat delta);
extern CGRect CGRectInsetBottom(CGRect inRect, CGFloat delta);
extern CGRect CGRectInsetLeft(CGRect inRect, CGFloat delta);
extern CGRect CGRectInsetRight(CGRect inRect, CGFloat delta);

#if IOS
extern CGRect CGRectInsetWithEdgeInsets(CGRect inRect, UIEdgeInsets insets);
#endif

// layout
extern CGRect CGRectAlignRectsHorizonally(CGRect left, CGRect right);
extern CGRect CGRectAlignRectVertically(CGRect top, CGRect bottom);
extern CGRect CGRectPositionRectInRectVerticallyBottomThird(CGRect container, CGRect containee);
extern CGRect CGRectPositionRectInRectVerticallyTopThird(CGRect container, CGRect containee);
//	This scales the containee rect to completely fill the container.
//	The containee rect is scaled proportionally so if it has a different
//	aspect ratio than the container, it WILL be larger than the container rect.
extern CGRect CGRectFillRectInRectProportionally(CGRect container, CGRect containee);
extern CGRect CGRectFitInRectInRectProportionally(CGRect container, CGRect containee);
extern CGRect CGRectEnsureRectInRect(CGRect container, CGRect containee);

// size
extern CGRect CGRectSetHeight(CGRect rect, CGFloat height);
extern CGRect CGRectAddHeight(CGRect rect, CGFloat height);
extern CGRect CGRectSetWidth(CGRect rect, CGFloat width);
extern CGRect CGRectAddWidth(CGRect rect, CGFloat width);
extern CGRect CGRectSetSize(CGRect rect, CGFloat width, CGFloat height);
extern CGRect CGRectAddSize(CGRect rect, CGFloat width, CGFloat height);
extern CGRect CGRectAddSizeWithSize(CGRect rect, CGSize size);
extern CGRect CGRectSetSizeWithSize(CGRect rect, CGSize size);
extern CGRect CGRectScale(CGRect rect, CGFloat scaleFactor);

// location
extern CGRect CGRectSetTop(CGRect rect, CGFloat top);
extern CGRect CGRectSetLeft(CGRect rect, CGFloat left);

// edges and corners
extern CGFloat CGRectGetRight(CGRect rect);
extern CGFloat CGRectGetBottom(CGRect rect);
extern CGPoint CGRectGetTopRight(CGRect rect);
extern CGPoint CGRectGetBottomRight(CGRect rect);
extern CGPoint CGRectGetBottomLeft(CGRect rect);
#define CGRectGetLeft(__rect__) ((__rect__)).origin.x
#define CGRectGetTop(__rect__) ((__rect__)).origin.y
#define CGRectGetTopLeft(__rect__) (__rect__).origin

// location
extern CGRect CGRectSetOrigin(CGRect rect, CGFloat x, CGFloat y);
extern CGRect CGRectSetOriginWithPoint(CGRect rect, CGPoint origin);
extern CGRect CGRectMoveWithPoint(CGRect rect, CGPoint delta);
extern CGRect CGRectMoveVertically(CGRect rect, CGFloat delta);
extern CGRect CGRectMoveHorizontally(CGRect rect, CGFloat delta);
extern CGRect CGRectMove(CGRect rect, CGFloat xDelta, CGFloat yDelta);

// construction
extern CGRect CGRectMakeWithSize(CGSize size);
extern CGRect CGRectMakeWithWidthAndHeight(CGFloat width, CGFloat height);
extern CGRect CGRectMakeIntegral(CGRect r);

// misc
extern BOOL CGRectEnclosesRect(CGRect container, CGRect containee);
extern CGRect CGRectRotate90Degrees(CGRect rect);

//	This scales the containee rect to completely fill the container.
//	The containee rect is scaled proportionally so if it has a different
//	aspect ratio than the container, it WILL be larger than the container rect.
extern CGRect CGRectFillRectInRectProportionally(CGRect container, CGRect containee);
extern CGRect CGRectFitInRectInRectProportionally(CGRect container, CGRect containee);
extern CGRect CGRectEnsureRectInRect(CGRect container, CGRect containee);

/* 
	Regarding CGRectOptimize

	There are two issues here:
	1.	you don't want your origin on a subpixel boundary, e.g. frame.origin.x = 10.5. You want it
		on integral bounderies, e.g. 10.0. Images and Text will render "fuzzy" if you do.
	2.	you don't want the center point of the view to be on a subpixel, which means the width an 
		height need to be evenly divisible by 2. Note that I opted to grow the frame by 1 pixel
		so that finely sized views aren't clipped (like text with decenders).
*/ 

extern CGSize FLSizeOptimizeForView(CGSize aSize);

// optimizing location and size for view frames
extern BOOL CGRectWidthIsOptimizedForView(CGRect r);
extern BOOL CGRectHeightIsOptimizedForView(CGRect r);
extern BOOL CGRectIsOptimizedForView(CGRect r);
extern CGRect CGRectOptimizedForViewSize(CGRect r);
extern CGRect CGRectOptimizedForViewLocation(CGRect r);

// see FLRectLayout.h

extern CGRect CGRectLayoutRectInRect(
	CGRect containerRect,
	CGRect containeeRect,
    FLRectLayout rectLayout);

extern CGRect CGRectLayoutRectHorizonallyInRect(
	CGRect containerRect,
	CGRect containeeRect,
    FLRectLayout rectLayout);
	
extern CGRect CGRectLayoutRectVerticallyInRect(
	CGRect containerRect,
	CGRect containeeRect,
    FLRectLayout rectLayout);

extern CGRect FLRectLayoutRectInRect(
	CGRect containerRect,
	CGRect containeeRect,
    FLRectLayout rectLayout);


#if DEBUG

#define FLWarnIfRectIsNotOptimizedForView(r) if(!CGRectIsOptimizedForView(r)) FLLog(@"%s is not optimized for view", #r)
#define FLAssertRectOptimizedForView(r) FLAssert(CGRectIsOptimizedForView(r), @"%s is not optimized for view", #r) 

#else

#define FLWarnIfRectIsNotOptimizedForView(r)
#define FLAssertRectOptimizedForView(r)

#endif

