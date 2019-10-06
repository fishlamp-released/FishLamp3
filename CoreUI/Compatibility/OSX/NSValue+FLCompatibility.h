//
//  NSValue+CocoaCompatibility.h
//  Fishlamp-Cocoa-Lib
//
//  Created by Mike Fullerton on 3/11/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if OSX
#import "FishLampCore.h"
#import <Cocoa/Cocoa.h>

#import "FLCompatibleGeometry+OSX.h"

@interface NSValue (FLCompatibility)

+ (NSValue *)valueWithCGPoint:(CGPoint)point;
+ (NSValue *)valueWithCGSize:(CGSize)size;
+ (NSValue *)valueWithCGRect:(CGRect)rect;

//+ (NSValue *)valueWithUIEdgeInsets:(UIEdgeInsets)insets;

- (CGPoint) CGPointValue;
- (CGSize) CGSizeValue;
- (CGRect) CGRectValue;
//- (UIEdgeInsets) UIEdgeInsetsValue;

@end

#endif
