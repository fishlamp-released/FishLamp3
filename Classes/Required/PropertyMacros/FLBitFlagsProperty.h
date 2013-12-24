//
//  FLBitFlagsProperty.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 9/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"
#import "FLBitFlags.h"

#define FLBitFlagProperty(__PROPERTY_NAME__) \
    @property (readwrite, assign, nonatomic) FLBitFlags_t __PROPERTY_NAME__; \
    - (void) __PROPERTY_NAME__##Clear:(FLBitMask_t) mask; \
    - (void) __PROPERTY_NAME__##Set:(FLBitMask_t) mask; \
    - (BOOL) __PROPERTY_NAME__##Test:(FLBitMask_t) mask; \
    - (BOOL) __PROPERTY_NAME__##TestAny:(FLBitMask_t) mask
    
#define FLSynthesizeBitFlagProperty(__PROPERTY_NAME__) \
    - (void) __PROPERTY_NAME__##Clear:(FLBitMask_t) mask { FLClearBits(_##__PROPERTY_NAME__, mask); } \
    - (void) __PROPERTY_NAME__##Set:(FLBitMask_t) mask { FLSetBits(_##__PROPERTY_NAME__, mask); } \
    - (BOOL) __PROPERTY_NAME__##Test:(FLBitMask_t) mask { return FLTestBits(_##__PROPERTY_NAME__, mask); } \
    - (BOOL) __PROPERTY_NAME__##TestAny:(FLBitMask_t) mask { return FLTestBits(_##__PROPERTY_NAME__, mask); } \
    @synthesize __PROPERTY_NAME__ = _##__PROPERTY_NAME__