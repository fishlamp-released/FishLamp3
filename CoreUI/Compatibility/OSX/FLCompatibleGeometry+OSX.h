//
//  UIGeometry.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/13/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if OSX
#import <Cocoa/Cocoa.h>
#if __MAC_10_8
#import <CoreGraphics/CoreGraphics.h>
#endif
//
//#ifndef __MAC_10_8
//typedef struct {
//    float left;
//    float top;
//    float bottom;
//    float right;
//} NSEdgeInsets;
//#endif
//
//
//#define UIEdgeInsets                        NSEdgeInsets
//#define UIEdgeInsetsMake                    NSEdgeInsetsMake
//#define UIEdgeInsetsEqualToEdgeInsets       NSEdgeInsetsEqualToEdgeInsets
//#define UIEdgeInsetsInsetRect               NSEdgeInsetsInsetRect
//extern  const NSEdgeInsets                  UIEdgeInsetsZero;
//// these don't exist in AppKit ?? 
//
//
//
//NS_INLINE
//BOOL UIEdgeInsetsEqualToEdgeInsets(NSEdgeInsets lhs, NSEdgeInsets rhs) {
//    return  FLFloatEqualToFloat(lhs.top, rhs.top) &&
//            FLFloatEqualToFloat(lhs.bottom, rhs.bottom) &&
//            FLFloatEqualToFloat(lhs.left, rhs.left) &&
//            FLFloatEqualToFloat(lhs.right, rhs.right);
//}
//
//NS_INLINE
//NSRect  UIEdgeInsetsInsetRect(NSRect rect, NSEdgeInsets insets) {
//    rect.origin.x    += insets.left;
//    rect.origin.y    += insets.top;
//    rect.size.width  -= (insets.left + insets.right);
//    rect.size.height -= (insets.top  + insets.bottom);
//    return rect;
//}
//
//#define CGSizeFromString            NSSizeFromString
//#define NSStringFromCGSize          NSStringFromSize
//
//#define CGRectFromString            NSRectFromString
//#define NSStringFromCGRect          NSStringFromRect
//
//#define CGPointFromString           NSPointFromString
//#define NSStringFromCGPoint         NSStringFromPoint

#endif

