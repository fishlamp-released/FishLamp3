//
//  FLEdgeInsets.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/13/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"
#import "FLMath.h"

typedef struct FLEdgeInsets {
    CGFloat top;
    CGFloat left;
    CGFloat bottom;
    CGFloat right;
} FLEdgeInsets;

NS_INLINE
BOOL FLEdgeInsetsEqualToEdgeInsets(FLEdgeInsets lhs, FLEdgeInsets rhs) {
    return  FLFloatEqualToFloat(lhs.top, rhs.top) &&
            FLFloatEqualToFloat(lhs.bottom, rhs.bottom) &&
            FLFloatEqualToFloat(lhs.left, rhs.left) &&
            FLFloatEqualToFloat(lhs.right, rhs.right);
}

extern const FLEdgeInsets FLEdgeInsetsZero;
