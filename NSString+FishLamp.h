//
//  _NSString+FishLamp.h
//  Fishlamp
//
//  Created by Mike Fullerton on 6/20/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"

// NOTE: see NSScanner.h

@interface NSString (FLStringUtilities)

- (BOOL)isEqualToString_fl:(NSString *)aString caseSensitive:(BOOL) caseSensitive;

// FL version isn't to happy with nil.
// this returns @"" if formatOrNil is nil.
+ (NSString*) stringWithFormatOrNil_fl:(NSString*) formatOrNil, ... NS_FORMAT_FUNCTION(1,2);

- (NSString*) trimmedStringWithNoLFCR_fl;

- (NSString*) trimmedString_fl;

+ (NSString*) stringWithTrailingPadding_fl:(NSString*) string
                              minimumWidth:(NSUInteger) minimumWidth;

+ (NSString*) stringWithLeadingPadding_fl:(NSString*) string
                             minimumWidth:(NSUInteger) minimumWidth;

- (NSString*) stringWithDeletedSubstring_fl:(NSString*) substring;

- (NSString*) stringWithUppercaseFirstLetter_fl;

- (NSString*) stringWithLowercaseFirstLetter_fl;

- (NSString*) camelCaseSpaceDelimitedString_fl;

- (NSString*) stringWithRemovingQuotes_fl; // if the string is "..." or '...' it will remove the leading and trailing quotes quotes.

- (BOOL) containsString_fl:(NSString*) string;

- (NSUInteger) subStringCount_fl:(NSString*) substring;

- (NSArray*) componentsSeparatedByCharactersInSet_fl:(NSCharacterSet*) set
                                allowEmptyStrings:(BOOL) allowEmptyStrings;


// these are case insensitve
- (NSString*) stringByDeletingPrefix_fl:(NSString*) prefix;
- (NSString*) stringByPrependingPrefix_fl:(NSString*) prefix;

- (NSString*) stringByDeletingSuffix_fl:(NSString*) suffix;
- (NSString*) stringByAppendingSuffix_fl:(NSString*) suffix;
@end

@interface NSMutableString (FLStringUtilities)
- (BOOL) insertString_fl:(NSString*) substring
            beforeString:(NSString*) beforeString
     withBackwardsSearch:(BOOL) searchBackwards;

- (BOOL) insertString_fl:(NSString*) substring
             afterString:(NSString*) afterString
     withBackwardsSearch:(BOOL) searchBackwards;
@end

// this also accepts a nil formatString (which is why it exists)
extern NSString* FLStringWithFormatOrNil(NSString* formatOrNil, ...) NS_FORMAT_FUNCTION(1,2);


//#if DEBUG
//#else
//#define __INLINES__
//#import "NSString+FishLamp_Inlines.h"
//#undef __INLINES__
//#endif



NS_INLINE
void FLAppendString(NSMutableString* string, NSString* aString) {
    if(FLStringIsNotEmpty(aString)) {
        [string appendString:aString];
    }
}
