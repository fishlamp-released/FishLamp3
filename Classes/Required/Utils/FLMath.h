//
//  FLMath.h
//  Fluffy
//
//  Created by Mike Fullerton on 11/24/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampObjc.h"

NS_INLINE
BOOL FLIsIntegralValue(CGFloat coord) {
    return round(coord) == coord;
}

#define FLRadiansToDegrees(__radians__) ((__radians__) * (180.0f / M_PI))

#define FLDegreesToRadians(__degrees__) ((__degrees__) * (M_PI / 180.0f))

#define FLFloatEqualToFloat(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define FLFloatEqualToZero(a) (fabs(a) < FLT_EPSILON)

#if CGFLOAT_IS_DOUBLE
#define FLFloatFloor(__CGFLOAT__) ((CGFloat) floor(__CGFLOAT__))
#define FLFloatRound(__CGFLOAT__) ((CGFloat) round(__CGFLOAT__))
#define FLFloatMod(__LHS__, __RHS__) ((CGFloat) fmod(__LHS__, __RHS__))
#define FLFloatAbs(__CGFLOAT__) ((CGFloat) fabs(__CGFLOAT__))
#else
#define FLFloatFloor(__CGFLOAT__) ((CGFloat) floorf(__CGFLOAT__))
#define FLFloatRound(__CGFLOAT__) ((CGFloat) roundf(__CGFLOAT__))
#define FLFloatMod(__LHS__, __RHS__) ((CGFloat) fmodf(__LHS__, __RHS__))
#define FLFloatAbs(__CGFLOAT__) ((CGFloat) fabsf(__CGFLOAT__))
#endif

#define FLCoordinateIntegral(__coordinate__) (CGFloat) round(__coordinate__)
