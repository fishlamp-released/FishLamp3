//
//  NSString+FishLamp.m
//  Fishlamp
//
//  Created by Mike Fullerton on 6/20/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSString+FishLamp.h"

#if DEBUG
#define __INLINES__
#import "FLStringUtils_Inlines.h"
#endif 


@implementation NSString (FLStringUtilities)

- (NSString*) stringWithDeletedSubstring_fl:(NSString*) substring {

    NSRange range = [self rangeOfString:substring];
    if(range.length > 0) {
        NSMutableString* newString = FLAutorelease([self mutableCopy]);
        [newString deleteCharactersInRange:range];
        return newString;
    }

    return self;
}



+ (NSString*) stringWithFormatOrNil_fl:(NSString*) format, ... {
    if(format) {
        va_list va_args;
        va_start(va_args, format);
        NSString* string = [[NSString alloc] initWithFormat:format arguments:va_args];
        va_end(va_args);
        return FLAutorelease(string);
    }
    
    return @"";
}


- (NSString*) trimmedStringWithNoLFCR_fl
{
	NSString* str = [self trimmedString_fl];
	str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	return [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}
// TODO: is there a better way to do this?
- (NSString*) trimmedString_fl {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*) stringWithPadding_fl:(NSUInteger) width {
    NSMutableString* str = [NSMutableString stringWithString:self];
    for(NSUInteger i = self.length; i < width; i++) {
        [str appendString:@" "];
    }
    return str;
}

+ (NSString*) stringWithTrailingPadding_fl:(NSString*) string
                                  minimumWidth:(NSUInteger) padding {

    if(string.length < padding) {
        NSMutableString* str = [NSMutableString stringWithString:string];
        for(NSUInteger i = 0; i < padding - string.length; i++) {
            [str appendString:@" "];
        }
        return str;
    }

    return string;
}

+ (NSString*) stringWithLeadingPadding_fl:(NSString*) string
                             minimumWidth:(NSUInteger) padding {

    if(string.length < padding) {
        NSMutableString* str = [NSMutableString string];
        for(NSUInteger i = 0; i < padding - string.length; i++) {
            [str appendString:@" "];
        }
        [str appendString:string];
        return str;
    }

    return string;
}


- (NSString*) stringWithUppercaseFirstLetter_fl
{
	return [NSString stringWithFormat:@"%c%@", 
					toupper([self characterAtIndex:0]),
					[self substringFromIndex:1]];
}

- (NSString*) stringWithLowercaseFirstLetter_fl
{
	return [NSString stringWithFormat:@"%c%@", 
			tolower([self characterAtIndex:0]),
			[self substringFromIndex:1]];
}


- (NSString*) camelCaseSpaceDelimitedString_fl
{
	NSArray* split = [self componentsSeparatedByString:@" "];
	
	NSMutableString* outString = [NSMutableString string];
	
	[outString appendString:[split objectAtIndex:0]];
	
	for(NSUInteger i = 1; i < split.count; i++)
	{
		[outString appendString:[[split objectAtIndex:i] stringWithUppercaseFirstLetter_fl]];
	}
	
	return outString;
}

- (NSString*) stringWithRemovingQuotes_fl {
    
    if(self.length >= 2) {
        NSRange range;
        range.length = self.length;
        range.location = 0;
        
        unichar first = [self characterAtIndex:0];
        unichar last = [self characterAtIndex:self.length - 1];
        if((first == '\"' && last == '\"') ||
           (first == '\'' && last == '\'') ) {
           range.length -= 2;
           ++range.location;
        }

        return [self substringWithRange:range];
    }
    
    return self;
}


- (BOOL) containsString_fl:(NSString*) string {
    return FLStringIsNotEmpty(string) && [self rangeOfString:string].length == string.length;
}

- (NSUInteger) subStringCount_fl:(NSString*) substring {
    NSUInteger count = 0;
    NSUInteger subLen = substring.length;
    NSUInteger len = self.length;
    
    for(int i = 0; i < len; i++) {
        for(int j = 0; (j < subLen && i < len); j++) {
            if([self characterAtIndex:i] != [substring characterAtIndex:j]) {
                goto skip;
                
                ++i;
            }
        }
        
        ++count;
        
        skip: ;
    }
    
    return count;
}

- (NSArray*) componentsSeparatedByCharactersInSet_fl:(NSCharacterSet*) charSet
                                allowEmptyStrings:(BOOL) allowEmptyStrings {

    NSArray* components = [self componentsSeparatedByCharactersInSet:charSet];
    if(!allowEmptyStrings) {
        NSMutableArray* mutableComponents = [NSMutableArray arrayWithCapacity:components.count];
        for(NSString* str in components) {
            if(FLStringIsNotEmpty(str)) {
                [mutableComponents addObject:str];
            }
        }
        components = mutableComponents;
    }

    return components;
}                                

- (NSString*) stringByDeletingPrefix_fl:(NSString*) prefix {

    if(FLStringIsNotEmpty(prefix)) {
        NSRange range = [self rangeOfString:prefix options:NSCaseInsensitiveSearch];
        if( range.length > 0 &&
            range.location == 0 && range.length) {
            return [self substringFromIndex:range.length];
        }
    }

    return self;
}


- (NSString*) stringByDeletingSuffix_fl:(NSString*) suffix {

    if(FLStringIsNotEmpty(suffix)) {
        NSRange range = [self rangeOfString:suffix
                                    options:NSCaseInsensitiveSearch | NSBackwardsSearch];

        if( range.length > 0 &&
            range.location == self.length - range.length) {
            return [self substringToIndex:range.location];
        }
    }

    return self;
}

- (NSString*) stringByPrependingPrefix_fl:(NSString*) prefix {
    if(FLStringIsNotEmpty(prefix)) {
        return [prefix stringByAppendingString:[self stringByDeletingPrefix_fl:prefix]];
    }
    return self;
}

- (NSString*) stringByAppendingSuffix_fl:(NSString*) suffix {
    if(FLStringIsNotEmpty(suffix)) {
        return [[self stringByDeletingSuffix_fl:suffix] stringByAppendingString:suffix];
    }
    return self;
}


@end

@implementation NSMutableString (FLStringUtilities)

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


