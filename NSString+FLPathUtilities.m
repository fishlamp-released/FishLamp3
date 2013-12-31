//
//  NSString+FLPathUtilities.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/10/13.
//
//

#import "NSString+FLPathUtilities.h"

@implementation NSString (FLPathUtilities)

+ (NSString* )pathWithComponents:(NSArray *)components withDelimiter:(unichar) delimiter {

    if(components.count == 0) {
        return @"";
    }

    NSMutableString* string = [NSMutableString stringWithString:[components objectAtIndex:0]];
    for(NSInteger i = 1; i < components.count; i++) {
        [string appendFormat:@"%c%@", delimiter, [components objectAtIndex:i]];
    }

    return string;
}

- (NSArray *)pathComponentsWithDelimiter:(unichar) delimiter {
    return [self componentsSeparatedByString:[NSString stringWithCharacters:&delimiter length:1]];
}

- (NSUInteger) indexOflastPathComponentDelimiter:(unichar) delimiter {
    for(NSInteger i = self.length - 1; i >= 0; i--) {
        if([self characterAtIndex:i] == delimiter) {
            return i;
        }
    }

    return NSNotFound;
}

- (NSString *)lastPathComponentWithDelimiter:(unichar) delim {

    for(NSInteger i = self.length - 1; i >= 0; i--) {
        if([self characterAtIndex:i] == delim) {
            return [self substringFromIndex:i+1];
        }
    }

    return nil;
}

- (NSString *)stringByDeletingLastPathComponentWithDelimiter:(unichar) delimiter {

    NSUInteger lastIndex = [self indexOflastPathComponentDelimiter:delimiter];
    if(lastIndex != NSNotFound) {
        return [self substringToIndex:lastIndex];
    }

    return self;
}

- (NSString *)stringByAppendingPathComponent:(NSString *)str withDelimiter:(unichar) delimiter {
    return [self stringByAppendingFormat:@"%c%@", delimiter, str];
}

- (NSArray *)stringsByAppendingPaths:(NSArray *)paths withDelimiter:(unichar) delimiter {
    NSMutableArray* outPaths = FLMutableCopyWithAutorelease([self pathComponentsWithDelimiter:delimiter]);
    [outPaths addObjectsFromArray:paths];
    return outPaths;
}

- (void) visitComponentsWithDelimiter:(unichar) delimiter
                    withForwardSearch:(FLPathUtilitiesVisitor) visitor {

    BOOL stop = NO;
    NSRange range = NSMakeRange(0, 0);
    for(NSInteger i = 0; i < self.length; i++) {
        if([self characterAtIndex:i] == delimiter) {

            if(range.length > 0) {
                visitor(range, &stop);
            }

            if(stop) {
                break;
            }

            range.length = 0;
            range.location = i + 1;
        }
        else {
            range.length++;
        }
    }
}

- (void) visitComponentsWithDelimiter:(unichar) delimiter
                   withBackwardSearch:(FLPathUtilitiesVisitor) visitor {

    BOOL stop = NO;
    NSRange range = NSMakeRange(self.length - 1, 0);
    for(NSInteger i = range.location; i >= 0; i--) {

        if([self characterAtIndex:i] == delimiter) {

            if(range.length > 0) {
                visitor(range, &stop);
            }

            if(stop) {
                break;
            }

            range.length = 0;
            range.location = i - 1;
        }
        else {
            range.length++;
        }
    }
}

- (BOOL) basePathEqualsPath:(NSString*) path withDelimiter:(unichar) delimiter {

    if(self.length < path.length) {
        return NO;
    }

    return  [self hasPrefix:path] &&
            [self indexOflastPathComponentDelimiter:delimiter] == path.length;
}


@end
