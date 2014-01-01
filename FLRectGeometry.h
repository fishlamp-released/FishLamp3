//
//	CGRect.h
//	FishLamp
//
//	Created by Mike Fullerton on 5/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampCore.h"

//#import "CGRectGeometry+FLAdditions.h"
//#if OSX
//#import "NSRectGeometry+FLAdditions.h"
//#endif


//#import "FLMath.h"
//#import "FLPointGeometry.h"
//#import "FLCompatibility.h"
//
//#if DEBUG
//    #define CGRectInset             FLRectInset
//#else
//#if OSX
//    #define FLRectInset             NSInsetRect
//#else
//    #define FLRectInset             CGRectInset
//#endif
//#endif
//
//#define FLRectMake                  CGRectMake
//#define FLRectGetMidX               CGRectGetMidX
//#define FLRectGetMidY               CGRectGetMidY
//#define FLRectEqualToRect           CGRectEqualToRect
//#define FLRectIsTaller(__lhs__, __rhs__) ((__lhs__).size.height > (__rhs___).size.height)
//#define FLRectIsWider(__lhs__, __rhs__) ((__lhs__).size.width > (__rhs__).size.width)
//#define FLRectGetLeft(__rect__) ((__rect__)).origin.x
//#define FLRectGetTop(__rect__) ((__rect__)).origin.y
//#define FLRectGetTopLeft(__rect__) (__rect__).origin
//
//#if IOS
//    #define FLRectInsetWithEdgeInsets   UIEdgeInsetsInsetRect
//#endif    
//
//
//extern BOOL FLRectIsIntegral(SDKRect r);
//
//// centering
//extern SDKRect FLRectCenterOnPoint(SDKRect rect, SDKPoint point);
//extern SDKRect FLRectCenterOnPointVertically(SDKRect rect, SDKPoint point);
//extern SDKRect FLRectCenterOnPointHorizontally(SDKRect rect, SDKPoint point);
//
//extern SDKPoint FLRectGetCenter(SDKRect rect);
//extern SDKRect FLRectCenterRectInRect(SDKRect container, SDKRect containee);
//extern SDKRect FLRectCenterRectInRectVertically(SDKRect container, SDKRect containee);
//extern SDKRect FLRectCenterRectInRectHorizontally(SDKRect container, SDKRect containee);
//
//// justification
//extern SDKRect FLRectJustifyRectInRectRight(SDKRect container, SDKRect containee);
//extern SDKRect FLRectJustifyRectInRectLeft(SDKRect container, SDKRect containee);
//extern SDKRect FLRectJustifyRectInRectTop(SDKRect container, SDKRect containee);
//extern SDKRect FLRectJustifyRectInRectBottom(SDKRect container, SDKRect containee);
//extern SDKRect FLRectJustifyRectInRectTopLeft(SDKRect container, SDKRect containee);
//extern SDKRect FLRectJustifyRectInRectTopRight(SDKRect container, SDKRect containee);
//extern SDKRect FLRectJustifyRectInRectBottomRight(SDKRect container, SDKRect containee);
//extern SDKRect FLRectJustifyRectInRectBottomLeft(SDKRect container, SDKRect containee);
//
//// inset
//// this is a debugging only function that asserts that you're insetting with a reasonable
//// value. Debug only. Ship calls SDKRectInset/NSRectInset
//extern SDKRect FLRectInset(SDKRect rect, CGFloat dx, CGFloat dy);
//
//extern SDKRect FLRectInsetTop(SDKRect inRect, CGFloat delta);
//extern SDKRect FLRectInsetBottom(SDKRect inRect, CGFloat delta);
//extern SDKRect FLRectInsetLeft(SDKRect inRect, CGFloat delta);
//extern SDKRect FLRectInsetRight(SDKRect inRect, CGFloat delta);
//#if OSX
//extern SDKRect FLRectInsetWithEdgeInsets(SDKRect inRect, UIEdgeInsets insets);
//#endif
//
//// layout
//extern SDKRect FLRectAlignRectsHorizonally(SDKRect left, SDKRect right);
//extern SDKRect FLRectAlignRectVertically(SDKRect top, SDKRect bottom);
//extern SDKRect FLRectPositionRectInRectVerticallyBottomThird(SDKRect container, SDKRect containee);
//extern SDKRect FLRectPositionRectInRectVerticallyTopThird(SDKRect container, SDKRect containee);
////	This scales the containee rect to completely fill the container.
////	The containee rect is scaled proportionally so if it has a different
////	aspect ratio than the container, it WILL be larger than the container rect.
//extern SDKRect FLRectFillRectInRectProportionally(SDKRect container, SDKRect containee);
//extern SDKRect FLRectFitInRectInRectProportionally(SDKRect container, SDKRect containee);
//extern SDKRect FLRectEnsureRectInRect(SDKRect container, SDKRect containee);
//
//// size
//extern SDKRect FLRectSetHeight(SDKRect rect, CGFloat height);
//extern SDKRect FLRectAddHeight(SDKRect rect, CGFloat height);
//extern SDKRect FLRectSetWidth(SDKRect rect, CGFloat width);
//extern SDKRect FLRectAddWidth(SDKRect rect, CGFloat width);
//extern SDKRect FLRectSetSize(SDKRect rect, CGFloat width, CGFloat height);
//extern SDKRect FLRectAddSize(SDKRect rect, CGFloat width, CGFloat height);
//extern SDKRect FLRectAddSizeWithSize(SDKRect rect, CGSize size);
//extern SDKRect FLRectSetSizeWithSize(SDKRect rect, CGSize size);
//extern SDKRect FLRectScale(SDKRect rect, CGFloat scaleFactor);
//
//// location
//extern SDKRect FLRectSetTop(SDKRect rect, CGFloat top);
//extern SDKRect FLRectSetLeft(SDKRect rect, CGFloat left);
//
//// edges and corners
//extern CGFloat FLRectGetRight(SDKRect rect);
//extern CGFloat FLRectGetBottom(SDKRect rect);
//extern SDKPoint FLRectGetTopRight(SDKRect rect);
//extern SDKPoint FLRectGetBottomRight(SDKRect rect);
//extern SDKPoint FLRectGetBottomLeft(SDKRect rect);
//
//// location
//extern SDKRect FLRectSetOrigin(SDKRect rect, CGFloat x, CGFloat y);
//extern SDKRect FLRectSetOriginWithPoint(SDKRect rect, SDKPoint origin);
//extern SDKRect FLRectMoveWithPoint(SDKRect rect, SDKPoint delta);
//extern SDKRect FLRectMoveVertically(SDKRect rect, CGFloat delta);
//extern SDKRect FLRectMoveHorizontally(SDKRect rect, CGFloat delta);
//extern SDKRect FLRectMove(SDKRect rect, CGFloat xDelta, CGFloat yDelta);
//
//// construction
//extern SDKRect FLRectMakeWithSize(CGSize size);
//extern SDKRect FLRectMakeWithWidthAndHeight(CGFloat width, CGFloat height);
//
//// misc
//extern BOOL FLRectEnclosesRect(SDKRect container, SDKRect containee);
//extern SDKRect FLRectRotate90Degrees(SDKRect rect);
//
////	This scales the containee rect to completely fill the container.
////	The containee rect is scaled proportionally so if it has a different
////	aspect ratio than the container, it WILL be larger than the container rect.
//extern SDKRect FLRectFillRectInRectProportionally(SDKRect container, SDKRect containee);
//extern SDKRect FLRectFitInRectInRectProportionally(SDKRect container, SDKRect containee);
//extern SDKRect FLRectEnsureRectInRect(SDKRect container, SDKRect containee);
//
///* 
//	Regarding FLRectOptimize
//
//	There are two issues here:
//	1.	you don't want your origin on a subpixel boundary, e.g. frame.origin.x = 10.5. You want it
//		on integral bounderies, e.g. 10.0. Images and Text will render "fuzzy" if you do.
//	2.	you don't want the center point of the view to be on a subpixel, which means the width an 
//		height need to be evenly divisible by 2. Note that I opted to grow the frame by 1 pixel
//		so that finely sized views aren't clipped (like text with decenders).
//*/ 
//
//extern CGSize FLSizeOptimizeForView(CGSize aSize);
//
//// optimizing location and size for view frames
//extern BOOL FLRectWidthIsOptimizedForView(SDKRect r);
//extern BOOL FLRectHeightIsOptimizedForView(SDKRect r);
//extern BOOL FLRectIsOptimizedForView(SDKRect r);
//extern SDKRect FLRectOptimizedForViewSize(SDKRect r);
//extern SDKRect FLRectOptimizedForViewLocation(SDKRect r);
//
//#if DEBUG
//
//#define FLWarnIfRectIsNotOptimizedForView(r) if(!FLRectIsOptimizedForView(r)) FLLog(@"%s is not optimized for view", #r)
//#define FLAssertRectOptimizedForView(r) FLAssert(FLRectIsOptimizedForView(r), @"%s is not optimized for view", #r) 
//
//#else
//
//#define FLWarnIfRectIsNotOptimizedForView(r)
//#define FLAssertRectOptimizedForView(r)
//
//#endif
//
