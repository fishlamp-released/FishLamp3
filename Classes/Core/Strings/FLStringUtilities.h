//
//  FLStringUtilities.h
//  Pods
//
//  Created by Mike Fullerton on 2/18/14.
//
//

#import "NSString+FishLamp.h"

// this also accepts a nil formatString (which is why it exists)
extern NSString* FLStringWithFormatOrNil(NSString* formatOrNil, ...) NS_FORMAT_FUNCTION(1,2);

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

NS_INLINE
void FLAppendString(NSMutableString* string, NSString* aString) {
    if(FLStringIsNotEmpty(aString)) {
        [string appendString:aString];
    }
}
