//
//  FLPrettyAttributedString.m
//  FishLampCore
//
//  Created by Mike Fullerton on 8/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLPrettyAttributedString.h"
#import "FLSelectorPerforming.h"

@implementation FLPrettyAttributedString

- (id) initWithWhitespace:(FLWhitespace*) whitespace {
    self = [super initWithWhitespace:whitespace];
    if(self) {
        _attributedString = [[NSMutableAttributedString alloc] init];
    }
    return self;
}

+ (id) prettyAttributedString:(FLWhitespace*) whitespace {
    return FLAutorelease([[[self class] alloc] initWithWhitespace:whitespace]);
}

+ (id) prettyAttributedString {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) prettyAttributedStringWithString:(NSString*) string {
    FLPrettyAttributedString* prettyString = FLAutorelease([[[self class] alloc] init]);
    [prettyString appendString:string];
    return prettyString;
}

- (NSUInteger) whitespaceStringFormatterGetLength:(FLWhitespaceStringFormatter*) stringFormatter {
    return [_attributedString length];
}

#if FL_MRC
- (void) dealloc {
    [_attributedString release];
    [super dealloc];
}
#endif

- (void) deleteAllCharacters {
    [_attributedString deleteCharactersInRange:NSMakeRange(0, [_attributedString length])];
}

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
   appendContentsToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter  {

    [anotherStringFormatter appendString:[self formattedString]];
}

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
                      appendString:(NSString*) string {

    [self whitespaceStringFormatter:self
             appendAttributedString:FLAutorelease([[NSAttributedString alloc] initWithString:string])];
}

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
            appendAttributedString:(NSAttributedString*) attributedString {
    [_attributedString appendAttributedString:attributedString];
}

- (NSString*) whitespaceStringFormatterExportString:(FLWhitespaceStringFormatter*) formatter {
    return [_attributedString string];
}

- (NSAttributedString*) whitespaceStringFormatterExportAttributedString:(FLWhitespaceStringFormatter*) formatter {
    return FLCopyWithAutorelease(_attributedString);
}

@end
