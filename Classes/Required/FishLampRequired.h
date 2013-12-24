//
//  FishLampRequired.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/10/13.
//
//

#import <Foundation/Foundation.h>
#import <Availability.h>
#import <CoreGraphics/CoreGraphics.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#endif

#if DEBUG
    #define FL_SHIP_ONLY_INLINE 
#else
    #define FL_SHIP_ONLY_INLINE NS_INLINE
#endif

// flags, etc.
#import "FishLampObjc.h"

// properites
#import "FishLampProperyMacros.h"

// utils
#import "FLAtomic.h"
#import "FLBitFlags.h"
#import "FLMath.h"
#import "FLOSVersion.h"
#import "FLSelectorPerforming.h"
#import "FLVersion.h"

// sdk categories
#import "NSArray+FishLamp.h"
#import "NSDictionary+FishLamp.h"
#import "NSObject+FLBlocks.h"
#import "NSObject+FLPerformSelector.h"

