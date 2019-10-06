//
//  NSRect+FLAdditions.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/13/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//


//
//	CGRect.h
//	FishLamp
//
//	Created by Mike Fullerton on 5/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampCore.h"

#if __MAC_OS_X_VERSION_MIN_REQUIRED

#import "FLMath.h"
#import "FLRectLayout.h"
#import "NSPointGeometry+FLAdditions.h"
#import "CGRectGeometry+FLAdditions.h"

//#if DEBUG
//    #define CGRectInset             FLRectInset
//#else
//    #define FLRectInset             NSInsetRect
//#endif


#define NSRectEqualToRect           NSEqualRects
#define NSRectIsTaller(__lhs__, __rhs__) ((__lhs__).size.height > (__rhs___).size.height)
#define NSRectIsWider(__lhs__, __rhs__) ((__lhs__).size.width > (__rhs__).size.width)
#define NSRectGetLeft(__rect__) ((__rect__)).origin.x
#define NSRectGetTop(__rect__) ((__rect__)).origin.y
#define NSRectGetTopLeft(__rect__) (__rect__).origin

#define NSRectContainsPoint(rect, point) NSPointInRect(point, rect)

#define NSStringFromNSRect NSStringFromRect
#define NSRectMake NSMakeRect
//
//#if IOS
//    #define FLRectInsetWithEdgeInsets   UIEdgeInsetsInsetRect
//#endif    

// TODO (MWF): review these and make them call into NSGeometry if possible, etc..

#define NSRectIsIntegral(r) \
            CGRectIsIntegral(NSRectToCGRect(r))

// centering
#define NSRectCenterOnPoint(rect, point) \
            NSRectFromCGRect(CGRectCenterOnPoint(NSRectToCGRect(rect), NSPointToCGPoint(rect)))

#define NSRectCenterOnPointVertically(rect, point) \
            NSRectFromCGRect(CGRectCenterOnPointVertically(NSRectToCGRect(rect), NSPointToCGPoint(rect)))

#define NSRectCenterOnPointHorizontally(rect, point) \
            NSRectFromCGRect(CGRectCenterOnPointHorizontally(NSRectToCGRect(rect), NSPointToCGPoint(point)))


#define NSRectGetCenter(rect) \
            NSPointFromCGPoint(CGRectGetCenter(NSRectToCGRect(rect)))

#define NSRectCenterRectInRect(container, containee) \
            NSRectFromCGRect(CGRectCenterRectInRect(NSRectToCGRect(container), NSRectToCGRect(containee)))


#define NSRectCenterRectInRectVertically(container, containee) \
            NSRectFromCGRect(CGRectCenterRectInRectVertically(NSRectToCGRect(container), NSRectToCGRect(containee)))


#define NSRectCenterRectInRectHorizontally(container, containee) \
            NSRectFromCGRect(CGRectCenterRectInRectHorizontally(NSRectToCGRect(container), NSRectToCGRect(containee)))

// justification
#define NSRectJustifyRectInRectRight(container, containee) \
            NSRectFromCGRect(CGRectJustifyRectInRectRight(NSRectToCGRect(container), NSRectToCGRect(containee) ))


#define NSRectJustifyRectInRectLeft(container, containee) \
            NSRectFromCGRect(CGRectJustifyRectInRectLeft(NSRectToCGRect(container), NSRectToCGRect(containee) ))


#define NSRectJustifyRectInRectTop(container, containee) \
            NSRectFromCGRect(CGRectJustifyRectInRectTop(NSRectToCGRect(container), NSRectToCGRect(containee) ))


#define NSRectJustifyRectInRectBottom(container, containee) \
            NSRectFromCGRect(CGRectJustifyRectInRectBottom(NSRectToCGRect(container), NSRectToCGRect(containee) ))


#define NSRectJustifyRectInRectTopLeft(container, containee) \
            NSRectFromCGRect(CGRectJustifyRectInRectTopLeft(NSRectToCGRect(container), NSRectToCGRect(containee) ))


#define NSRectJustifyRectInRectTopRight(container, containee) \
            NSRectFromCGRect(CGRectJustifyRectInRectTopRight(NSRectToCGRect(container), NSRectToCGRect(containee) ))


#define NSRectJustifyRectInRectBottomRight(container, containee) \
            NSRectFromCGRect(CGRectJustifyRectInRectBottomRight(NSRectToCGRect(container), NSRectToCGRect(containee) ))


#define NSRectJustifyRectInRectBottomLeft(container, containee) \
            NSRectFromCGRect(CGRectJustifyRectInRectBottomLeft(NSRectToCGRect(container), NSRectToCGRect(containee) ))



//// inset
//// this is a debugging only function that asserts that you're insetting with a reasonable
//// value. Debug only. Ship calls NSRectInset/NSRectInset
//#define NSRectInset(rect, dx, dy) \
//            NSRectFromCGRect(CGRectInset(rect, dx, dy))


#define NSRectInsetTop(rect, delta) \
            NSRectFromCGRect(CGRectInsetTop(NSRectToCGRect(rect), delta))


#define NSRectInsetBottom(rect, delta) \
            NSRectFromCGRect(CGRectInsetBottom(NSRectToCGRect(rect), delta))


#define NSRectInsetLeft(rect, delta) \
            NSRectFromCGRect(CGRectInsetLeft(NSRectToCGRect(rect), delta))


#define NSRectInsetRight(rect, delta) \
            NSRectFromCGRect(CGRectInsetRight(NSRectToCGRect(rect), delta))


#if 0
extern NSRect NSRectInsetWithEdgeInsets(NSRect rect, NSEdgeInsets insets);
#endif

// layout
#define NSRectAlignRectsHorizonally(left, right) \
            NSRectFromCGRect(CGRectAlignRectsHorizonally(NSRectToCGRect(left), NSRectToCGRect(left)))


#define NSRectAlignRectVertically(top, bottom) \
            NSRectFromCGRect(CGRectAlignRectVertically(NSRectToCGRect(left), NSRectToCGRect(left)))


#define NSRectPositionRectInRectVerticallyBottomThird(container, containee) \
            NSRectFromCGRect(CGRectPositionRectInRectVerticallyBottomThird(NSRectToCGRect(container), NSRectToCGRect(containee)))


#define NSRectPositionRectInRectVerticallyTopThird(container, containee) \
            NSRectFromCGRect(CGRectPositionRectInRectVerticallyTopThird(NSRectToCGRect(container), NSRectToCGRect(containee)))


// size
#define NSRectSetHeight(rect, height) \
            NSRectFromCGRect(CGRectSetHeight(NSRectToCGRect(rect), height ))


#define NSRectAddHeight(rect, height) \
            NSRectFromCGRect(CGRectAddHeight(NSRectToCGRect(rect), height ))


#define NSRectSetWidth(rect, width) \
            NSRectFromCGRect(CGRectSetWidth(NSRectToCGRect(rect), width ))


#define NSRectAddWidth(rect, width) \
            NSRectFromCGRect(CGRectAddWidth(NSRectToCGRect(rect), width ))


#define NSRectSetSize(rect, width, height) \
            NSRectFromCGRect(CGRectSetSize(NSRectToCGRect(rect), width, height ))


#define NSRectAddSize(rect, width, height) \
            NSRectFromCGRect(CGRectAddSize(NSRectToCGRect(rect), width, height ))


#define NSRectAddSizeWithSize(rect, size) \
            NSRectFromCGRect(CGRectAddSizeWithSize(NSRectToCGRect(rect), NSSizeFromCGSize(size) ))

#define NSRectSetSizeWithSize(rect, size) \
            NSRectFromCGRect(CGRectSetSizeWithSize(NSRectToCGRect(rect), NSSizeFromCGSize(size) ))


#define NSRectScale(rect, scaleFactor) \
            NSRectFromCGRect(CGRectScale(NSRectToCGRect(rect), scaleFactor))

// location
#define NSRectSetTop(rect, top) \
            NSRectFromCGRect( CGRectSetTop(NSRectToCGRect(rect), top))

#define NSRectSetLeft(rect, left) \
            NSRectFromCGRect( CGRectSetLeft(NSRectToCGRect(rect), left))

// edges and corners
#define NSRectGetRight(rect) \
            NSMaxX(rect)

#define NSRectGetBottom(rect) \
            NSMaxY(rect)

#define NSRectGetTopRight(rect) \
            NSRectFromCGRect(CGRectGetTopRight(NSRectToCGRect(rect)))

#define NSRectGetBottomRight(rect) \
            NSRectFromCGRect(CGRectGetBottomRight(NSRectToCGRect(rect)))

#define NSRectGetBottomLeft(rect) \
            NSRectFromCGRect(CGRectGetBottomLeft(NSRectToCGRect(rect)))

// location
#define NSRectSetOrigin(rect, x, y) \
            NSRectFromCGRect(CGRectSetOrigin(NSRectToCGRect(rect), x, y))

#define NSRectSetOriginWithPoint(rect, origin) \
            NSRectFromCGRect(CGRectSetOriginWithPoint(NSRectToCGRect(rect), NSPointFromCGPoint(origin)))


#define NSRectMoveWithPoint(rect, delta) \
            NSRectFromCGRect(CGRectMoveWithPoint(NSRectToCGRect(rect), NSPointFromCGPoint(origin)))


#define NSRectMoveVertically(rect, delta) \
            NSRectFromCGRect(CGRectMoveVertically(NSRectToCGRect(rect), NSPointFromCGPoint(origin)))


#define NSRectMoveHorizontally(rect, delta) \
            NSRectFromCGRect(CGRectMoveHorizontally(NSRectToCGRect(rect), NSPointFromCGPoint(origin)))

#define NSRectMove(rect, xDelta, yDelta) \
            NSRectFromCGRect(CGRectMove(NSRectToCGRect(rect), xDelta, yDelta))

// construction
#define NSRectMakeWithSize(size) \
            NSRectFromCGRect(CGRectMakeWithSize(NSSizeToCGSize(size)))

#define NSRectMakeWithWidthAndHeight(width, height) \
            NSRectFromCGRect(NSRectMakeWithWidthAndHeight(width, height))

// misc
#define NSRectEnclosesRect(container, containee) \
            GGRectEnclosesRect(NSRectToCGRect(container), NSRectToCGRect(containee))

#define NSRectRotate90Degrees(rect) \
            NSRectFromCGRect(NSRectRotate90Degrees(NSRectToCGRect(rect)))

//	This scales the containee rect to completely fill the container.
//	The containee rect is scaled proportionally so if it has a different
//	aspect ratio than the container, it WILL be larger than the container rect.
#define NSRectFillRectInRectProportionally(container, containee) \
            NSRectFromCGRect(CGRectFillRectInRectProportionally(NSRectToCGRect(container), NSRectToCGRect(containee)))

#define NSRectFitInRectInRectProportionally(container, containee) \
            NSRectFromCGRect(CGRectFitInRectInRectProportionally(NSRectToCGRect(container), NSRectToCGRect(containee)))

#define NSRectEnsureRectInRect(container, containee) \
            NSRectFromCGRect(CGRectEnsureRectInRect(NSRectToCGRect(container), NSRectToCGRect(containee)))

/* 
	Regarding NSRectOptimize

	There are two issues here:
	1.	you don't want your origin on a subpixel boundary, e.g. frame.origin.x = 10.5. You want it
		on integral bounderies, e.g. 10.0. Images and Text will render "fuzzy" if you do.
	2.	you don't want the center point of the view to be on a subpixel, which means the width an 
		height need to be evenly divisible by 2. Note that I opted to grow the frame by 1 pixel
		so that finely sized views aren't clipped (like text with decenders).
*/ 

#define NSSizeOptimizeForView(aSize) \
            NSRectFromCGRect(CGSizeOptimizeForView(NSSizeToCGSize(aSize)))

// optimizing location and size for view frames
#define NSRectWidthIsOptimizedForView(r) \
            NSRectFromCGRect(CGRectWidthIsOptimizedForView(NSRectToCGRect(r)))

#define NSRectHeightIsOptimizedForView(r) \
            NSRectFromCGRect(CGRectWidthIsOptimizedForView(NSRectToCGRect(r)))

#define NSRectIsOptimizedForView(r) \
            NSRectFromCGRect(CGRectIsOptimizedForView(NSRectToCGRect(r)))

#define NSRectOptimizedForViewSize(r) \
            NSRectFromCGRect(CGRectOptimizedForViewSize(NSRectToCGRect(r)))

#define NSRectOptimizedForViewLocation(r) \
            NSRectFromCGRect(CGRectOptimizedForViewLocation(NSRectToCGRect(r)))

#define NSRectLayoutRectInRect(containerRect, containeeRect, rectLayout) \
            NSRectFromCGRect(CGRectLayoutRectInRect(NSRectFromCGRect(containerRect), NSRectToCGRect(containeeRect), rectLayout))

#define NSRectLayoutRectHorizonallyInRect(containerRect, containeeRect, rectLayout) \
            NSRectFromCGRect(CGRectLayoutRectHorizonallyInRect(NSRectFromCGRect(containerRect), NSRectToCGRect(containeeRect), rectLayout))

#define NSRectLayoutRectVerticallyInRect(containerRect,containeeRect,rectLayout) \
            NSRectFromCGRect(CGRectLayoutRectVerticallyInRect(NSRectFromCGRect(containerRect), NSRectToCGRect(containeeRect), rectLayout))

#define FLRectLayoutRectInRect(containerRect, containeeRect, rectLayout) \
            NSRectFromCGRect(CGRectLayoutRectInRect(NSRectFromCGRect(containerRect), NSRectToCGRect(containeeRect), rectLayout))

//#if DEBUG
//
//#define FLWarnIfRectIsNotOptimizedForView(r) if(!NSRectIsOptimizedForView(r)) FLDebugLog(@"%s is not optimized for view", #r)
//#define FLAssertRectOptimizedForView(r) FLAssert(NSRectIsOptimizedForView(r), @"%s is not optimized for view", #r) 
//
//#else
//
//#define FLWarnIfRectIsNotOptimizedForView(r)
//#define FLAssertRectOptimizedForView(r)
//
//#endif

#endif