//
//  NSString+FishLampCore.h
//  FishLampTestLibraries
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import <Foundation/Foundation.h>
#import "FishLampRequired.h"

extern NSString* FLStringWithFormatOrNil(NSString* format, ...);

// these work with nil strings, which is why they're not
// category additions.
extern BOOL FLStringIsEmpty(NSString* string);
extern BOOL FLStringIsNotEmpty(NSString* string);
extern BOOL FLStringsAreEqual(NSString* lhs, NSString* rhs);
extern BOOL FLStringsAreEqualCaseInsensitive(NSString* lhs, NSString* rhs);

#define FLStringsAreNotEqual(lhs, rhs) (!FLStringsAreEqual(lhs, rhs))

NS_INLINE
NSString* FLEmptyStringOrString(NSString* string) {
    return FLStringIsEmpty(string) ? @"" : string;
}

@interface NSString (FishLampCore)

- (BOOL)isEqualToString_fl:(NSString *)aString caseSensitive:(BOOL) caseSensitive;

@end

