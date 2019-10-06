//
//  FLCompatibility.m
//  FishLamp
//
//  Created by Mike Fullerton on 12/15/13.
//
//

#import "FLCompatibility.h"

#if IOS

@implementation NSValue (Compatibility)

+ (NSValue *)valueWithPoint:(CGPoint)point {
    return [NSValue valueWithCGPoint:point];
}
+ (NSValue *)valueWithSize:(CGSize)size {
    return [NSValue valueWithCGSize:size];
}

+ (NSValue *)valueWithRect:(CGRect)rect {
    return [NSValue valueWithRect:rect];
}

- (CGPoint)pointValue {
    return [self CGPointValue];
}

- (CGSize)sizeValue {
    return [self CGSizeValue];
}

- (CGRect)rectValue {
    return [self CGRectValue];
}

@end

#endif