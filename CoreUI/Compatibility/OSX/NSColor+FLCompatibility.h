//
//  SDKColor.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/13/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if OSX
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

#ifndef __MAC_10_9
@interface NSColor (FLCompatibility)
+ (NSColor*) colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
@end
#endif

#endif
