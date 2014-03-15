//
//	FLRectLayout.m
//	FishLamp
//
//	Created by Mike Fullerton on 2/13/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLRectLayout.h"
#import "FLRectGeometry.h"

#ifdef FL_SHIP_ONLY_INLINE
#undef FL_SHIP_ONLY_INLINE
#define FL_SHIP_ONLY_INLINE
#endif

const struct FLRectLayout FLRectLayoutNone = {	FLRectLayoutHorizontalNone,	 FLRectLayoutVerticalNone, {0,0,0,0} };
const struct FLRectLayout FLRectLayoutFill = {	FLRectLayoutHorizontalFill, FLRectLayoutVerticalFill, {0,0,0,0}};
const struct FLRectLayout FLRectLayoutCentered = { FLRectLayoutHorizontalCentered, FLRectLayoutVerticalCentered, {0,0,0,0}};
const struct FLRectLayout FLRectLayoutAspectFit = {	FLRectLayoutHorizontalFit, FLRectLayoutVerticalFit, {0,0,0,0} };
const struct FLRectLayout FLRectLayoutCenteredTop = {	FLRectLayoutHorizontalCentered, FLRectLayoutVerticalTop, {0,0,0,0} };
const struct FLRectLayout FLRectLayoutCenteredBottom = {	FLRectLayoutHorizontalCentered, FLRectLayoutVerticalBottom, {0,0,0,0} };

																				
FL_SHIP_ONLY_INLINE
BOOL FLRectLayoutsAreEqual(FLRectLayout lhs, FLRectLayout rhs) {
	return  lhs.horizontal == rhs.horizontal && 
            lhs.vertical == rhs.vertical &&
            FLEdgeInsetsEqualToEdgeInsets(lhs.insets, rhs.insets);

}

FL_SHIP_ONLY_INLINE
FLRectLayout FLRectLayoutMake(	FLRectLayoutHorizontal horizontalLayout, 
									FLRectLayoutVertical verticalLayout) {
	FLRectLayout loc;
	loc.horizontal = horizontalLayout;
	loc.vertical = verticalLayout;
	loc.insets = FLEdgeInsetsZero;
	return loc;
}

FL_SHIP_ONLY_INLINE
FLRectLayout FLRectLayoutMakeWithInsets(	FLRectLayoutHorizontal horizontalLayout,
                                            FLRectLayoutVertical verticalLayout,
                                            FLEdgeInsets insets) {
	FLRectLayout loc;
	loc.horizontal = horizontalLayout;
	loc.vertical = verticalLayout;
	loc.insets = insets;
	return loc;
}

FL_SHIP_ONLY_INLINE
FLRectLayout FLRectLayoutSetVertical(FLRectLayout rectLayout, FLRectLayoutVertical vertical) {
	rectLayout.vertical = vertical;
	return rectLayout;
}

FL_SHIP_ONLY_INLINE
FLRectLayout FLRectLayoutSetHorizontal(FLRectLayout loc, FLRectLayoutHorizontal horizontal) {
	loc.horizontal = horizontal;
	return loc;
}

FL_SHIP_ONLY_INLINE
BOOL FLRectLayoutIsValid(FLRectLayout loc) {
	return	loc.horizontal >= FLRectLayoutHorizontalNone && loc.vertical >= FLRectLayoutVerticalNone;
}

FL_SHIP_ONLY_INLINE
BOOL FLRectLayoutNotNone(FLRectLayout loc) {
	return	loc.horizontal > FLRectLayoutHorizontalNone || loc.vertical > FLRectLayoutVerticalNone;
}

