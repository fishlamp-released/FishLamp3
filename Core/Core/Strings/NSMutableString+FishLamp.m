//
//  NSMutableString+FishLamp.m
//  Pods
//
//  Created by Mike Fullerton on 2/18/14.
//
//

#import "NSMutableString+FishLamp.h"


@implementation NSMutableString (FishLamp)

- (BOOL) insertString_fl:(NSString*) substring beforeString:(NSString*) beforeString withBackwardsSearch:(BOOL) searchBackwards {

    NSStringCompareOptions options = searchBackwards ? NSBackwardsSearch: 0;
    
    NSRange range = [self rangeOfString:beforeString options:options];

    if(range.length) {
        [self insertString:substring atIndex:range.location];
        return YES;
    }
    
    return NO;
}

- (BOOL) insertString_fl:(NSString*) substring afterString:(NSString*) afterString withBackwardsSearch:(BOOL) searchBackwards {

    NSStringCompareOptions options = searchBackwards ? NSBackwardsSearch: 0;
    
    NSRange range = [self rangeOfString:afterString options:options];

    if(range.length) {
        [self insertString:substring atIndex:range.location + range.length];
        return YES;
    }

    return NO;
}



@end
