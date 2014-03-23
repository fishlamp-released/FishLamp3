//
//  FLStringUtilities.m
//  Pods
//
//  Created by Mike Fullerton on 2/18/14.
//
//

#import "FLStringUtilities.h"

NSString* FLStringWithFormatOrNil(NSString* format, ...) {
    if(format) {
        va_list va_args;
        va_start(va_args, format);
        
        NSString* string = FLAutorelease([[NSString alloc] initWithFormat:[format description] arguments:va_args]);
        va_end(va_args);
        return string;
    }
    
    return @"";
}


//NS_INLINE
BOOL FLStringIsEmpty(NSString* string) {
	return string == nil || [string length] == 0;
}

//NS_INLINE
BOOL FLStringIsNotEmpty(NSString* string) {
	return string != nil && [string length] > 0;
}

//NS_INLINE
BOOL FLStringsAreEqual(NSString* lhs, NSString* rhs) {
	return [(lhs == nil ? @"" : lhs) isEqualToString:(rhs == nil ) ? @"" :rhs];
}

//NS_INLINE
BOOL FLStringsAreEqualCaseInsensitive(NSString* lhs, NSString* rhs) {
	return [(lhs == nil ? @"" : lhs) isEqualToString_fl:(rhs == nil ) ? @"" :rhs caseSensitive:NO];
}

