//
//  SDKColor.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/13/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if OSX

#import "NSColor+FLCompatibility.h"
#ifndef __MAC_10_9
@implementation NSColor (FLCompatibility)
+ (NSColor*) colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [NSColor colorWithDeviceRed:red green:green blue:blue alpha:alpha];
}
@end
#endif

#endif