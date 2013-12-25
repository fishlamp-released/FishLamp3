//
//  FishLampRequired.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/10/13.
//
//

#import <Foundation/Foundation.h>
#import <Availability.h>

//#import <CoreGraphics/CoreGraphics.h>
//
//#if __IPHONE_OS_VERSION_MIN_REQUIRED
//// TODO: move this o
//#import <UIKit/UIKit.h>
//#endif

#if DEBUG
    #define FL_SHIP_ONLY_INLINE 
#else
    #define FL_SHIP_ONLY_INLINE NS_INLINE
#endif

// flags, etc.
#import "FLObjcCompiling.h"
#import "FLPropertyDeclaring.h"

