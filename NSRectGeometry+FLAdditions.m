//
//  NSRect+FLAdditions.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/13/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//


#import "NSRectGeometry+FLAdditions.h"
#if __MAC_OS_X_VERSION_MIN_REQUIRED

#ifdef FL_SHIP_ONLY_INLINE
#undef FL_SHIP_ONLY_INLINE
#define FL_SHIP_ONLY_INLINE
#endif


#if 0
FL_SHIP_ONLY_INLINE
NSRect NSRectInsetWithEdgeInsets(NSRect inRect, NSEdgeInsets insets) {
    inRect.size.height -= (insets.top + insets.bottom);
    inRect.size.width -= (insets.left + insets.right);
    inRect.origin.x += insets.left;
    inRect.origin.y += insets.top;
    return inRect;
}
#endif

#endif
