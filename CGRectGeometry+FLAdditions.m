//
//  CGRectGeometry+FLAdditions.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/13/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "CGRectGeometry+FLAdditions.h"

#ifdef FL_SHIP_ONLY_INLINE
#undef FL_SHIP_ONLY_INLINE
#define FL_SHIP_ONLY_INLINE
#endif

CGRect CGRectFillRectInRectProportionally(CGRect container, CGRect containee) {
	CGFloat horizScale = container.size.width / containee.size.width;
	CGFloat vertScale = container.size.height / containee.size.height;
	
	CGFloat scale = MAX(horizScale, vertScale);
	
	containee.size.width *= scale;
	containee.size.height *= scale;
	
	return containee;
}

CGRect CGRectFitInRectInRectProportionally(CGRect container, CGRect containee) {
	CGFloat horizScale = container.size.width / containee.size.width;
	CGFloat vertScale = container.size.height / containee.size.height;
	
	CGFloat scale = MIN(vertScale, horizScale);
	
	containee.size.width *= scale;
	containee.size.height *= scale;
	
	return containee;
}

CGRect CGRectEnsureRectInRect(CGRect container, CGRect containee) {
	if(containee.origin.x < container.origin.x) {
		containee.origin.x = container.origin.x;
	}
	else if(CGRectGetRight(containee) > CGRectGetRight(container)) {
		containee.origin.x = CGRectGetRight(container) - containee.size.width;
	}
	
	if(containee.origin.y < container.origin.y) {
		containee.origin.y = container.origin.y;
	}
	else if(CGRectGetBottom(containee) > CGRectGetBottom(container)) {
		containee.origin.y = CGRectGetBottom(container) - containee.size.height;
	}
	
	return containee;
}

FL_SHIP_ONLY_INLINE
BOOL CGRectIsIntegral(CGRect r) {
        return        FLIsIntegralValue(r.origin.x) && 
                        FLIsIntegralValue(r.origin.y) && 
                        FLIsIntegralValue(r.size.width) &&
                        FLIsIntegralValue(r.size.height);
}


//#if DEBUG
//
//#if IOS
//    #undef CGRectInset
//#else
//    #undef CGRectInset
//#endif
// 
//CGRect CGRectInset(CGRect rect, CGFloat dx, CGFloat dy) {
//    FLAssert(rect.size.width >= (dx * 2), @"trying to inset too narrow of a rect");
//    FLAssert(rect.size.height >= (dy * 2), @"trying to inset too short of a rect");
//    
//#if IOS
//    return CGRectInset(rect, dx, dy);
//#else
//    return NSInsetRect(rect, dx, dy);
//#endif
//
//}
//#endif

FL_SHIP_ONLY_INLINE
CGRect CGRectMakeIntegral(CGRect r) {
    r.origin.x = floor(r.origin.x);
    r.origin.y = floor(r.origin.y);
    r.size.width = ceil(r.size.width);
    r.size.height = ceil(r.size.height);
    return r;
}

FL_SHIP_ONLY_INLINE
CGRect CGRectCenterOnPoint(CGRect rect, CGPoint point) {
    rect.origin.x = point.x - (rect.size.width * 0.5f);
    rect.origin.y = point.y - (rect.size.height * 0.5f);
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectCenterOnPointHorizontally(CGRect rect, CGPoint point) {
    rect.origin.x = point.x - (rect.size.width * 0.5f);
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectCenterOnPointVertically(CGRect rect, CGPoint point) {
    rect.origin.y = point.y - (rect.size.height * 0.5f);
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGPoint CGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectCenterRectInRect(CGRect container, CGRect containee) {
    containee.origin.x = CGRectGetMidX(container) - (containee.size.width * 0.5f);
    containee.origin.y = CGRectGetMidY(container) - (containee.size.height * 0.5f);
    return containee;
}

FL_SHIP_ONLY_INLINE
CGRect CGRectCenterRectInRectVertically(CGRect container, CGRect containee) {
    containee.origin.y = CGRectGetMidY(container) - (containee.size.height * 0.5f);
    return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectCenterRectInRectHorizontally(CGRect container, CGRect containee) {
    containee.origin.x = CGRectGetMidX(container) - (containee.size.width * 0.5f);
    return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectJustifyRectInRectRight(CGRect container, CGRect containee) {
    containee.origin.x = container.origin.x + container.size.width - containee.size.width;
    return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectJustifyRectInRectLeft(CGRect container, CGRect containee) {
    containee.origin.x = container.origin.x;
    return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectJustifyRectInRectTop(CGRect container, CGRect containee) {
    containee.origin.y = container.origin.y;
    return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectJustifyRectInRectBottom(CGRect container, CGRect containee) {
    containee.origin.y = (container.origin.y + container.size.height) - containee.size.height;
    return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectJustifyRectInRectTopLeft(CGRect container, CGRect containee) {
    containee.origin.y = container.origin.y;
    containee.origin.x = container.origin.x;
    return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectJustifyRectInRectTopRight(CGRect container, CGRect containee) {
    containee.origin.y = container.origin.y;
    containee.origin.x = container.origin.x + container.size.width - containee.size.width;
    return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectJustifyRectInRectBottomRight(CGRect container, CGRect containee) {
    containee.origin.y = container.origin.y + container.size.height - containee.size.height;
    containee.origin.x = container.origin.x + container.size.width - containee.size.width;
    return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectJustifyRectInRectBottomLeft(CGRect container, CGRect containee) {
    containee.origin.y = container.origin.y + container.size.height - containee.size.height;
    containee.origin.x = container.origin.x;
    return containee;
}

#if IOS
FL_SHIP_ONLY_INLINE 
CGRect CGRectInsetWithEdgeInsets(CGRect inRect, UIEdgeInsets insets) {
    inRect.size.height -= (insets.top + insets.bottom);
    inRect.size.width -= (insets.left + insets.right);
    inRect.origin.x += insets.left;
    inRect.origin.y += insets.top;
    return inRect;
}
#endif

FL_SHIP_ONLY_INLINE 
CGRect CGRectInsetTop(CGRect inRect, CGFloat delta) {
    inRect.size.height -= delta;
    inRect.origin.y += delta;
    return inRect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectInsetBottom(CGRect inRect, CGFloat delta) {
        inRect.size.height -= delta;
    return inRect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectInsetLeft(CGRect inRect, CGFloat delta) {
    inRect.size.width -= delta;
    inRect.origin.x += delta;
    return inRect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectInsetRight(CGRect inRect, CGFloat delta) {
    inRect.size.width -= delta;
    return inRect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectAlignRectsHorizonally(CGRect left, CGRect right) {
    right.origin.x = left.origin.x + left.size.width;
    return right;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectSetHeight(CGRect rect, CGFloat height) {
    rect.size.height = height;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectAddHeight(CGRect rect, CGFloat height) {
    rect.size.height += height;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectSetWidth(CGRect rect, CGFloat width) {
    rect.size.width = width;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectAddWidth(CGRect rect, CGFloat width) {
    rect.size.width += width;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectSetTop(CGRect rect, CGFloat top) {
    rect.origin.y = top;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectSetLeft(CGRect rect, CGFloat left) {
    rect.origin.x = left;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectAlignRectVertically(CGRect top, CGRect bottom) {
    bottom.origin.y = (top.origin.y + top.size.height);
    return bottom;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectRotate90Degrees(CGRect rect) {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.height, rect.size.width);
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectPositionRectInRectVerticallyBottomThird(CGRect container, CGRect containee) {
    containee.origin.y = ((container.size.height / 3)*2) - (containee.size.height/2);
    return containee;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectPositionRectInRectVerticallyTopThird(CGRect container, CGRect containee) {
    containee.origin.y = (container.size.height / 3) - (containee.size.height/2);
    return containee;
}

FL_SHIP_ONLY_INLINE 
BOOL CGRectEnclosesRect(CGRect container, CGRect containee)  {
    return	containee.origin.x >= container.origin.x &&
            containee.origin.y >= container.origin.y &&
            (containee.origin.x + containee.size.width) <= (container.origin.x + container.size.width) &&
            (containee.origin.y + containee.size.height) <= (container.origin.y + container.size.height);
}

FL_SHIP_ONLY_INLINE 
CGFloat CGRectGetRight(CGRect rect) {
    return rect.origin.x + rect.size.width;
}

FL_SHIP_ONLY_INLINE 
CGFloat CGRectGetBottom(CGRect rect) {
    return rect.origin.y + rect.size.height;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectMoveWithPoint(CGRect rect, CGPoint delta) {
    rect.origin.x += delta.x;
    rect.origin.y += delta.y;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectMoveVertically(CGRect rect, CGFloat delta) {
    rect.origin.y += delta;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectMoveHorizontally(CGRect rect, CGFloat delta) {
    rect.origin.x += delta;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectMove(CGRect rect, CGFloat xDelta, CGFloat yDelta) {
    rect.origin.x += xDelta;
    rect.origin.y += yDelta;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGPoint CGRectGetTopRight(CGRect rect) {
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
}

FL_SHIP_ONLY_INLINE 
CGPoint CGRectGetBottomRight(CGRect rect) {
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}

FL_SHIP_ONLY_INLINE 
CGPoint CGRectGetBottomLeft(CGRect rect) {
    return CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectSetOrigin(CGRect rect, CGFloat x, CGFloat y) {
    rect.origin.x = x;
    rect.origin.y = y;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectSetOriginWithPoint(CGRect rect, CGPoint origin) {
    rect.origin = origin;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectSetSize(CGRect rect, CGFloat width, CGFloat height) {
    rect.size.width = width;
    rect.size.height = height;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectAddSize(CGRect rect, CGFloat width, CGFloat height) {
    rect.size.width += width;
    rect.size.height += height;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectAddSizeWithSize(CGRect rect, CGSize size) {
    rect.size.width += size.width;
    rect.size.height += size.height;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectSetSizeWithSize(CGRect rect, CGSize size) {
    rect.size = size;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectScale(CGRect rect, CGFloat scaleFactor) {
    rect.size.width *= scaleFactor;
    rect.size.height *= scaleFactor;
    return rect;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectMakeWithSize(CGSize size) {	
    return CGRectMake(0,0,size.width, size.height);
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectMakeWithWidthAndHeight(CGFloat width, CGFloat height) {	
    return CGRectMake(0,0,width, height);
}

#define __FLRectCheckWidth(r) \
            (FLFloatMod(r.origin.x + r.size.width, 2.0f) == 0.0f)

#define __FLRectCheckHeight(r) \
            (FLFloatMod(r.origin.y + r.size.height, 2.0f) == 0.0f)

FL_SHIP_ONLY_INLINE
BOOL CGRectWidthIsOptimizedForView(CGRect r) {
    return r.size.width == 0.0f || (CGRectIsIntegral(r) && __FLRectCheckWidth(r));
}

FL_SHIP_ONLY_INLINE
BOOL CGRectHeightIsOptimizedForView(CGRect r) {
    return r.size.height == 0.0f || (CGRectIsIntegral(r) && __FLRectCheckHeight(r));
}

FL_SHIP_ONLY_INLINE 
BOOL CGRectIsOptimizedForView(CGRect r) {
	return	CGRectIsIntegral(r) && 
			CGRectWidthIsOptimizedForView(r) &&
			CGRectHeightIsOptimizedForView(r);
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectOptimizedForViewSize(CGRect r) {
	r = CGRectMakeIntegral(r);
	
	// make sure the midpoint is not fractional.
	if(r.size.width > 0.0f && !__FLRectCheckWidth(r)) {
        r.size.width += 1.0f; 
    }
	if(r.size.height > 0.0f && !__FLRectCheckHeight(r)) {
        r.size.height += 1.0f; 
	}
	return r;
}

FL_SHIP_ONLY_INLINE 
CGRect CGRectOptimizedForViewLocation(CGRect r) {
	r = CGRectMakeIntegral(r);
	
	// make sure the midpoint is not fractional.
	if(r.size.width > 0.0f && !__FLRectCheckWidth(r)) {
        r.origin.x -= 1.0f;
    }
	if(r.size.height > 0.0f && !__FLRectCheckHeight(r)) {
        r.origin.y -= 1.0f;
    }
	
	return r;
}

FL_SHIP_ONLY_INLINE 
CGSize FLSizeOptimizeForView(CGSize aSize) {
	CGSize size = CGSizeMake(round(aSize.width), round(aSize.height));
	if(FLFloatMod(size.width, 2.0f) != 0.0f) size.width += 1.0f;
	if(FLFloatMod(size.height, 2.0f) != 0.0f) size.height += 1.0f;
	return size;
}

CGRect CGRectLayoutRectVerticallyInRect(
        CGRect containerRect,
        CGRect containeeRect,
		FLRectLayout contentMode ) {
	
    switch(contentMode.vertical) {
		case FLRectLayoutVerticalTop:
			containeeRect = CGRectSetTop(containeeRect, contentMode.insets.top);
			break;
		
		case FLRectLayoutVerticalFill:
			containeeRect.origin.y = containerRect.origin.y;
			containeeRect.size.height = containerRect.size.height;

			containeeRect = CGRectInsetTop(containeeRect, contentMode.insets.top);
			containeeRect = CGRectInsetBottom(containeeRect, contentMode.insets.bottom);
		break;

		case FLRectLayoutVerticalCentered:
			containeeRect = CGRectCenterRectInRectVertically(containerRect, containeeRect);
			break;
		
		case FLRectLayoutVerticalTopThird:
			containeeRect.origin.y = (containerRect.size.height	 * 0.33) - (containeeRect.size.height * 0.5f);
			break;
   
		case FLRectLayoutVerticalBottomThird:
			containeeRect.origin.y = ((containerRect.size.height * 0.33) * 2.0f) - (containeeRect.size.height * 0.5f);
			break;
				 
		case FLRectLayoutVerticalBottom:
			containeeRect.origin.y = containerRect.size.height - containeeRect.size.height - contentMode.insets.top;
			break;
			
		case FLRectLayoutVerticalNone:
			break;
            
        case FLRectLayoutVerticalFit:
            break;
	
	}	
	
    return containeeRect;
}


CGRect CGRectLayoutRectHorizonallyInRect(
	CGRect containerRect,
	CGRect containeeRect,
	FLRectLayout contentMode)
{
	switch(contentMode.horizontal) {
		case FLRectLayoutHorizontalLeftThird:
			containeeRect.origin.x = containerRect.origin.x + ((containerRect.size.width * 0.33f) - (containeeRect.size.width * 0.5f));
			break;

		case FLRectLayoutHorizontalLeftQuarter:
			containeeRect.origin.x = containerRect.origin.x + ((containerRect.size.width * 0.25f) - (containeeRect.size.width * 0.5f));
			break;
		
		case FLRectLayoutHorizontalLeft:
			containeeRect.origin.x = containerRect.origin.x + contentMode.insets.left;
			break;

		case FLRectLayoutHorizontalRightThird:
			containeeRect.origin.x = containerRect.origin.x + ((containerRect.size.width * 0.66f) - (containeeRect.size.width * 0.5f));
			break;

		case FLRectLayoutHorizontalRightQuarter:
			containeeRect.origin.x = containerRect.origin.x + ((containerRect.size.width * 0.75f) - (containeeRect.size.width * 0.5f));
			break;

		case FLRectLayoutHorizontalRight:
			containeeRect.origin.x = CGRectGetRight(containerRect) - containeeRect.size.width - contentMode.insets.right;
			break;

		case FLRectLayoutHorizontalCentered:
			containeeRect = CGRectCenterRectInRectHorizontally(containerRect, containeeRect);
			break;

		case FLRectLayoutHorizontalNone:
			break;
			
		case FLRectLayoutHorizontalFill:
			containeeRect.size.width = (containerRect.size.width - contentMode.insets.left - contentMode.insets.right);
			containeeRect = CGRectCenterRectInRectHorizontally(containerRect, containeeRect);
			break;
            
        case FLRectLayoutHorizontalFit:
        break;
		
	}

    return containeeRect;
}

FL_SHIP_ONLY_INLINE
CGRect FLRectLayoutRectInRect(
	CGRect containerRect,
	CGRect containeeRect,
    FLRectLayout rectLayout)
{
	return CGRectLayoutRectHorizonallyInRect(
		containerRect,
		CGRectLayoutRectVerticallyInRect(containerRect, containeeRect, rectLayout),
		rectLayout);
}

