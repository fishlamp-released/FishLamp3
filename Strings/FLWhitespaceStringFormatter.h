//
//  FLWhitespaceStringFormatter.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLStringFormatter.h"

@class FLWhitespace;

@interface FLWhitespaceStringFormatter : FLStringFormatter<FLStringFormatterDelegate> {
@private
    BOOL _editingLine;
    FLWhitespace* _whitespace;

    __unsafe_unretained id _whitespaceStringFormatterDelegate;
}
@property (readwrite, assign, nonatomic) id whitespaceStringFormatterDelegate;

@property (readonly, assign, nonatomic) BOOL lineIsOpen;
@property (readonly, strong, nonatomic) FLWhitespace* whitespace;

- (id) initWithWhitespace:(FLWhitespace*) whitespace;

// optional overrides
- (void) willOpenLine;
- (void) willCloseLine;

// utils 
- (void) appendEOL;

@end

@protocol FLWhitespaceStringFormatterDelegate <NSObject>

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
                      appendString:(NSString*) string;

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
            appendAttributedString:(NSAttributedString*) attributedString;

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
       appendContentsToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter;

- (NSUInteger) whitespaceStringFormatterGetLength:(FLWhitespaceStringFormatter*) stringFormatter;

- (NSString*) whitespaceStringFormatterExportString:(FLWhitespaceStringFormatter*) formatter;

- (NSAttributedString*) whitespaceStringFormatterExportAttributedString:(FLWhitespaceStringFormatter*) formatter;

@end