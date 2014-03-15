//
//  NSString+FishLampCore.m
//  FishLampTestLibraries
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import "NSString+FishLampCore.h"

//@implementation NSString (FishLampCore)
//
//@end

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
BOOL FLStringIsEmpty(id string) {
	return string == nil || [string length] == 0;
}

//NS_INLINE
BOOL FLStringIsNotEmpty(id string) {
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

@implementation NSString (FishLampCore)

- (BOOL)isEqualToString_fl:(NSString *)aString caseSensitive:(BOOL) caseSensitive {
	return caseSensitive ?	[self isEqualToString:aString] :		
							[self caseInsensitiveCompare:aString] == NSOrderedSame; 
}

@end
