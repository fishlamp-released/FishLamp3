//
//	SDKPoint.h
//	FishLamp
//
//	Created by Mike Fullerton on 5/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampCore.h"
#import "FLCompatibility.h"
#import "CGPointGeometry+FLAdditions.h"
#if OSX
#import "NSPointGeometry+FLAdditions.h"
#endif


//#define FLCoordinateIntegral(__coordinate__) (CGFloat) round(__coordinate__)
//
//#if OSX
//#define CGPointMake             NSMakePoint
//#define FLPointEqualToPoint     NSEqualPoints
//#define FLPointsAreEqual        NSEqualPoints
//#else
//#define CGPointMake             CGPointMake
//#define FLPointEqualToPoint     CGPointEqualToPoint
//#define FLPointsAreEqual        CGPointEqualToPoint
//
//#endif
//
////#if IOS
////
////#else
////    #define FLPointFromString       NSPointFromString
////    #define FLStringFromPoint       NSStringFromPoint
////    #define CGPointMake             CGPointMake
////#endif
//
//
//NS_INLINE
//BOOL FLPointIsIntegral(SDKPoint p) {
//	return FLIsIntegralValue(p.x) && FLIsIntegralValue(p.y); 
//}
//
//NS_INLINE
//SDKPoint FLPointIntegral(SDKPoint pt) {
//	pt.x = FLCoordinateIntegral(pt.x);
//	pt.y = FLCoordinateIntegral(pt.y);
//	return pt;
//}
//
//NS_INLINE
//SDKPoint FLPointInvert(SDKPoint pt) {
//	pt.x *= (CGFloat)-1.0;
//	pt.y *= (CGFloat)-1.0;
//	return pt;
//}
//
//#define FLPointMakeIntegral(__x__, __y__) \
//	CGPointMake(FLCoordinateIntegral(__x__), FLCoordinateIntegral(__y__))
//
//
//NS_INLINE 
//CGFloat FLDistanceBetweenTwoPoints(SDKPoint point1, SDKPoint point2) {
//	CGFloat dx = point2.x - point1.x;
//	CGFloat dy = point2.y - point1.y;
//	return (CGFloat) sqrt(dx*dx + dy*dy );
//}
//
//NS_INLINE
//BOOL FLPointIsEmpty(SDKPoint pt) {
//	return FLFloatEqualToZero(pt.x) && FLFloatEqualToZero(pt.y);
//}
//
//NS_INLINE
//SDKPoint FLPointAddPointToPoint(SDKPoint pt, SDKPoint addToPoint) {
//	pt.x += addToPoint.x;
//	pt.y += addToPoint.y;
//	return pt;
//}
//
//NS_INLINE
//SDKPoint FLPointSubtractPointFromPoint(SDKPoint point, SDKPoint subtractFromPoint) {
//	point.x -= subtractFromPoint.x;
//	point.y -= subtractFromPoint.y;
//	return point;
//}
//
//
//NS_INLINE
//SDKPoint FLPointSwapCoordinates(SDKPoint pt) {
//	return CGPointMake(pt.y, pt.x);
//}
//
//NS_INLINE
//SDKPoint FLPointScale(SDKPoint pt, CGFloat scale) {
//	pt.x *= scale;
//	pt.y *= scale;
//	
//	return pt;
//}
//
//NS_INLINE
//SDKPoint FLPointMove(SDKPoint pt, CGFloat xDelta, CGFloat yDelta) {
//	pt.x += xDelta;
//	pt.y += yDelta;
//	return pt;
//}

