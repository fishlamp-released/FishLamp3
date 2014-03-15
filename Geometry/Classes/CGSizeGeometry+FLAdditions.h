//
//  CGSize.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/12/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampCore.h"
#import <CoreGraphics/CoreGraphics.h>

//#if OSX
//    #define CGSizeMake               NSMakeSize
//    #define FLSizeFromString         NSSizeFromString     
//    #define CGSizeZero               NSZeroSize
//    #define FLSizeEqualToSize        NSEqualSizes
//    #define FLEqualSizes             NSEqualSizes
//    #define FLStringFromSize         NSStringFromSize
//#endif

extern const CGSize FLSizeMax;

NS_INLINE
CGSize FLSizeScale(CGSize size, CGFloat scaleFactor) {
	size.width *= scaleFactor;
	size.height *= scaleFactor;
	return size;
}

NS_INLINE
CGSize FLSizeSwapValues(CGSize size) {
	return CGSizeMake(size.height, size.width);
}

NS_INLINE
CGSize FLSizeAddSizeToSize(CGSize addTo, CGSize delta) {
	addTo.height += delta.height;
	addTo.width += delta.width;
	return addTo;
}

NS_INLINE
CGSize FLPointSubtractSizeFromSize(CGSize subtractFrom, CGSize delta) {
	subtractFrom.width -= delta.width;
	subtractFrom.height -= delta.height;
	return subtractFrom;
}

NS_INLINE
BOOL FLSizeIsEmpty(CGSize size) {
	return FLFloatEqualToZero(size.width) && FLFloatEqualToZero(size.height);
}
