//
//  FLPrettyString.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/30/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPrettyString.h"
#import "FishLampAssertions.h"
#import "FLWhitespace.h"
#import "FLSelectorPerforming.h"

@implementation FLPrettyString

- (id) initWithWhitespace:(FLWhitespace*) whitespace {
    self = [super initWithWhitespace:whitespace];
    if(self) {
        _string = [[NSMutableString alloc] init];
    }
    return self;
}

- (NSString*) string {
    return _string;
}

+ (id) prettyString:(FLWhitespace*) whitespace {
    return FLAutorelease([[[self class] alloc] initWithWhitespace:whitespace]);
}

+ (id) prettyString {
    return FLAutorelease([[[self class] alloc] init]);
}

+ (id) prettyStringWithString:(NSString*) string {
    FLPrettyString* prettyString = FLAutorelease([[[self class] alloc] init]);
    [prettyString appendString:string];
    return prettyString;
}

- (NSUInteger) whitespaceStringFormatterGetLength:(FLWhitespaceStringFormatter*) stringFormatter {
    return [_string length];
}

#if FL_MRC
- (void) dealloc {
    [_string release];
    [super dealloc];
}
#endif

- (void) deleteAllCharacters {
    [_string deleteCharactersInRange:NSMakeRange(0, [_string length])];
}

- (NSString*) description {
    return [self string];
}

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
       appendContentsToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter {

    [anotherStringFormatter appendString:[self formattedString]];
}

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
                      appendString:(NSString*) string {
    [_string appendString:string];
}

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
            appendAttributedString:(NSAttributedString*) attributedString {

    [self whitespaceStringFormatter:stringFormatter appendString:[attributedString string]];
}

- (NSString*) whitespaceStringFormatterExportString:(FLWhitespaceStringFormatter*) formatter {
    return self.string;
}

- (NSAttributedString*) whitespaceStringFormatterExportAttributedString:(FLWhitespaceStringFormatter*) formatter {
    return FLAutorelease([[NSAttributedString alloc] initWithString:[self formattedString]]);
}

@end


