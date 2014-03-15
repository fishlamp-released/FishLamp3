//
//  FLWhitespaceStringFormatter.m
//  FishLampCore
//
//  Created by Mike Fullerton on 8/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWhitespaceStringFormatter.h"
#import "FishLampAssertions.h"
#import "FLWhitespace.h"
#import "FLStringPreprocessor.h"

@implementation FLWhitespaceStringFormatter

@synthesize whitespace = _whitespace;
@synthesize lineIsOpen = _editingLine;
@synthesize whitespaceStringFormatterDelegate = _whitespaceStringFormatterDelegate;

- (id) initWithWhitespace:(FLWhitespace*) whitespace {
    self = [super init];
    if(self) {
        _whitespace = FLRetain(whitespace);
        _whitespaceStringFormatterDelegate = self;
    }
    return self;
}

- (id) init {
    return [self initWithWhitespace:[FLWhitespace defaultWhitespace]];
}

#if FL_MRC
- (void) dealloc {
    [_whitespace release];
    [super dealloc];
}
#endif

- (void) stringFormatterCloseLine:(FLStringFormatter*) formatter {
    if(_editingLine) {
        [self willCloseLine];
        _editingLine = NO;
    }
}

- (void) stringFormatterOpenLine:(FLStringFormatter*) formatter {
    if(!_editingLine) {
        _editingLine = YES;
        if(self.whitespace) {
            [self.stringFormatterDelegate stringFormatter:self
                                             appendString:[self.whitespace tabStringForScope:self.indentLevel]];
        }
        [self willOpenLine];
    }
}
- (void) willCloseLine {
    [self appendEOL];
}

- (void) willOpenLine {
}

- (void) stringFormatterIndent:(FLStringFormatter*) formatter {
}

- (void) stringFormatterOutdent:(FLStringFormatter*) formatter {
}

- (void) appendEOL {
    if(self.whitespace) {
        [self.stringFormatterDelegate stringFormatter:self appendString:self.whitespace.eolString];
    } 
}

- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) formatter {
    [self closeLine];

    // intentionally not opening line
    [self appendEOL];

    _editingLine = NO;
}

- (void) stringFormatter:(FLStringFormatter*) formatter appendString:(NSString*) string {
    [_whitespaceStringFormatterDelegate whitespaceStringFormatter:self appendString:string];
}

- (void) stringFormatter:(FLStringFormatter*) formatter appendAttributedString:(NSAttributedString*) string {
    [_whitespaceStringFormatterDelegate whitespaceStringFormatter:self appendAttributedString:string];
}

- (NSUInteger) stringFormatterLength:(FLStringFormatter*) formatter {
    return [_whitespaceStringFormatterDelegate whitespaceStringFormatterGetLength:self];
}

- (void) stringFormatter:(FLStringFormatter*) formatter
        appendContentsToStringFormatter:(id<FLStringFormatter>) stringFormatter {

    [_whitespaceStringFormatterDelegate whitespaceStringFormatter:self
                                  appendContentsToStringFormatter:stringFormatter];
}

- (NSString*) stringFormatterExportString:(FLStringFormatter*) formatter {
    return [_whitespaceStringFormatterDelegate whitespaceStringFormatterExportString:self];
}

- (NSAttributedString*) stringFormatterExportAttributedString:(FLStringFormatter*) formatter {
    return [_whitespaceStringFormatterDelegate whitespaceStringFormatterExportAttributedString:self];
}


@end
