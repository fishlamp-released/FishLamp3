//
//  FLCStringFragment.m
//  FishLampCore
//
//  Created by Mike Fullerton on 3/18/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCStringFragment.h"

@implementation NSString (FLCStringFragment)

- (id) initWithCStringFragment:(FLCStringFragment) charString {
    if(charString.length == 0) {
        return nil;
    }

    return [self initWithBytes:charString.string length:charString.length encoding:NSASCIIStringEncoding];
}

+ (NSString*) stringWithCStringFragment:(FLCStringFragment) charString {
    return FLAutorelease([[[self class] alloc] initWithCStringFragment:charString]);

}
@end

FLCStringFragment FLParseFragmentFromCString(const char* string, char stopChar) {
    FLCStringFragment charString = { string, 0 };
    while(*string && *string++ != stopChar) {
        charString.length++;
    }
    return charString;
}
