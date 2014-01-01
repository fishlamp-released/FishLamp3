//
//  FLAbstractStringFormatter.m
//  FishLampCore
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringFormatter.h"
#import "FishLampAssertions.h"
//#import "NSArray+FishLamp.h"
#import "FLStringPreprocessor.h"
#import "FLPrettyDescription.h"

@interface FLStringFormatter ()
- (void) closeLineWithString:(id) string;
- (void) closeLineWithFormat:(NSString*) format, ... NS_FORMAT_FUNCTION(1,2);
- (void) appendActualString:(id) string;

// need refactoring
- (void) appendLines:(NSString**) lines count:(NSInteger) count;
- (void) appendLines:(NSString**) lines;
- (void) appendLinesWithArray:(NSArray*) lines;

/// incoming string is chopped into lines and then fed through appendLines
- (void) appendStringContainingMultipleLines:(NSString*) inLines;
- (void) appendStringContainingMultipleLines:(NSString*) inLines trimWhitespace:(BOOL) trimWhitespace;

@end

@implementation NSString (FLStringFormatter)

- (NSString*) stringFormatter:(FLStringFormatter*) stringFormatter
           substringWithRange:(NSRange) range {

    return [self substringWithRange:range];
}

- (void) stringFormatter:(FLStringFormatter*) stringFormatter
        appendToDelegate:(id<FLStringFormatterDelegate>) delegate {

    [delegate stringFormatter:stringFormatter appendString:self];
}

- (void) stringFormatter:(FLStringFormatter*) stringFormatter
        appendToDelegate:(id<FLStringFormatterDelegate>) delegate
               withRange:(NSRange) range {

    [delegate stringFormatter:stringFormatter
                 appendString:[self substringWithRange:range]];
}

- (void) appendToStringFormatter:(FLStringFormatter*) stringFormatter {
    [stringFormatter appendActualString:self];
}

- (NSString*) stringFormatterString:(FLStringFormatter*) stringFormatter {
    return self;
}

@end

@implementation NSAttributedString (FLStringFormatter)

- (NSString*) stringFormatter:(FLStringFormatter*) stringFormatter
           substringWithRange:(NSRange) range {
    return [self.string substringWithRange:range];
}

- (void) stringFormatter:(FLStringFormatter*) stringFormatter
        appendToDelegate:(id<FLStringFormatterDelegate>) delegate {
    [delegate stringFormatter:stringFormatter appendAttributedString:self];
}

- (void) stringFormatter:(FLStringFormatter*) stringFormatter
        appendToDelegate:(id<FLStringFormatterDelegate>) delegate
               withRange:(NSRange) range {
    [delegate stringFormatter:stringFormatter
       appendAttributedString:[self attributedSubstringFromRange:range]];
}

- (void) appendToStringFormatter:(FLStringFormatter*) stringFormatter {
    [stringFormatter appendActualString:self];
}

- (NSString*) stringFormatterString:(FLStringFormatter*) stringFormatter {
    return self.string;
}


@end


@implementation FLStringFormatter

@synthesize stringFormatterDelegate = _stringFormatterDelegate;
@synthesize preprocessor = _preprocessor;
@synthesize indentLevel = _indentLevel;
@synthesize indentIntegrity = _indentIntegrity;

- (id) init {	
	self = [super init];
	if(self) {
		_stringFormatterDelegate = self;
        self.preprocessor = [FLStringFormatterLineProprocessor instance];
        _indentIntegrity = [[FLIndentIntegrity alloc] init];
    }
	return self;
}

#if FL_MRC
- (void)dealloc {
    [_indentIntegrity release];
	[_preprocessor release];
	[super dealloc];
}
#endif

- (NSString*) formattedString {
    return [_stringFormatterDelegate stringFormatterExportString:self];
}

- (NSAttributedString*) formattedAttributedString {
    return [_stringFormatterDelegate stringFormatterExportAttributedString:self];
}

- (void) appendToStringFormatter:(id<FLStringFormatter>) stringFormatter  {
    [_stringFormatterDelegate stringFormatter:self appendContentsToStringFormatter:stringFormatter];
}

- (void) prettyDescription:(id<FLStringFormatter>)stringFormatter {
    [self appendToStringFormatter:stringFormatter];
}

- (void) appendString:(id) string {
    [string appendToStringFormatter:self];
}

- (void) appendActualString:(id) string {
    FLAssertNotNil(string);
    if(_preprocessor) {

        FLStringPreprocessorResultBlock block = ^(NSRange range) {
            [self openLine];
            [string stringFormatter:self appendToDelegate:_stringFormatterDelegate withRange:range];
            [self closeLine];
        };

        NSRange range = [_preprocessor processString:[string stringFormatterString:self] foundLineRangeBlock:block];

        if(range.length) {
            [self openLine];
            if(range.location > 0) {
                [string stringFormatter:self appendToDelegate:_stringFormatterDelegate withRange:range];
            }
            else {
                [string stringFormatter:self appendToDelegate:_stringFormatterDelegate];
            }
        }
    }
    else {
        [self openLine];
        [string stringFormatter:self appendToDelegate:_stringFormatterDelegate];
    }
}

- (void) openLine {
    [_stringFormatterDelegate stringFormatterOpenLine:self];
}

- (void) closeLine {
    [_stringFormatterDelegate stringFormatterCloseLine:self];
}

- (void) indent:(FLIndentIntegrity*) integrity {
    [integrity push:++_indentLevel];
    [_stringFormatterDelegate stringFormatterIndent:self];
}

- (void) outdent:(FLIndentIntegrity*) integrity {
    [_stringFormatterDelegate stringFormatterOutdent:self];
    [integrity pop:_indentLevel--];
}

- (NSUInteger) length {
    return [_stringFormatterDelegate stringFormatterLength:self];
}

- (void) appendBlankLine {
    [_stringFormatterDelegate stringFormatterAppendBlankLine:self];
}

- (void) closeLineWithString:(id) string {

    if(string) {
        [self appendString:string];
    }

    [self closeLine];
}

- (void) openLineWithString:(id) string {
    FLAssertNotNil(string);

    [self closeLine];
    [self appendString:string];
}

- (void) appendLine:(id) string {
    FLAssertNotNil(string);

    [self appendString:string];
    [self closeLine];
}

- (void) indentLinesInBlock:(FLStringFormatterIndentedBlock) block {
    [self closeLine];
    [self indent:_indentIntegrity];
    // subsequent calls to us will open a line, etc..
    block();
    [self closeLine];
    [self outdent:_indentIntegrity];
}

- (BOOL) isEmpty {
    return self.length == 0;
}

- (void) appendInScope:(NSString*) openScope
            closeScope:(NSString*) closeScope
             withBlock:(FLStringFormatterIndentedBlock) block {
    [self appendLine:openScope];
    [self indentLinesInBlock:block];
    [self appendLine:closeScope];
}

- (void) appendLines:(NSString**) lines
               count:(NSInteger) count{

    FLAssertNotNil(lines);
    if(lines) {
        for(int i = 0; i < count; i++) {
            [self appendLine:lines[i]];
        }
    }
}

- (void) appendLines:(NSString**) lines {
    FLAssertNotNil(lines);
    [self appendLines:lines count:(sizeof(lines) / sizeof(NSString*))];
}

- (void) appendLinesWithArray:(NSArray*) lines {
    FLAssertNotNil(lines);
    for(NSString* line in lines) {
        [self appendLine:line];
    }
}

- (void) appendFormat:(NSString*) format, ... {
    FLAssertNotNil(format);
	va_list va;
	va_start(va, format);
	NSString *string = FLAutorelease([[NSString alloc] initWithFormat:format arguments:va]);
	va_end(va);
    [self appendString:string];
}

- (void) appendFormat:(NSString*) format 
            arguments:(va_list)argList {
	[self appendString:FLAutorelease([[NSString alloc] initWithFormat:format arguments:argList])];
}

- (void) appendLineWithFormat:(NSString*) format, ... {
    FLAssertNotNil(format);
	va_list va_args;
	va_start(va_args, format);
	NSString *string = FLAutorelease([[NSString alloc] initWithFormat:format arguments:va_args]);
	va_end(va_args);
	[self appendLine:string];
}

- (void) appendLineWithFormat:(NSString*) format arguments:(va_list)argList {
	[self appendLine:FLAutorelease([[NSString alloc] initWithFormat:format arguments:argList])];
}

- (void) openLineWithFormat:(NSString*) format, ... {
    FLAssertNotNil(format);
	va_list va_args;
	va_start(va_args, format);
	NSString *string = FLAutorelease([[NSString alloc] initWithFormat:format arguments:va_args]);
	va_end(va_args);
	[self openLineWithString:string];
}

- (void) closeLineWithFormat:(NSString*) format, ... {
    FLAssertNotNil(format);
	va_list va_args;
	va_start(va_args, format);
	NSString *string = FLAutorelease([[NSString alloc] initWithFormat:format arguments:va_args]);
	va_end(va_args);
	[self closeLineWithString:string];
}

- (NSString*) preprocessLines:(NSString*) lines {
	NSString* string = [lines stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
	string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return string;
}

- (void) appendStringContainingMultipleLines:(NSString*) inLines 
                              trimWhitespace:(BOOL) trimWhitespace {
    FLAssertNotNil(inLines);

	NSString* string = trimWhitespace ? [self preprocessLines:inLines] : inLines;
	if([string length] > 0) {
		NSArray* lines = [string componentsSeparatedByString:@"\n"];
		for(NSString* line in lines) {
			NSString* newline = trimWhitespace ? [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : line;
		
			if([newline length] > 0) {
				[self appendLine:newline];
            }
		}
	}
}

- (void) appendStringContainingMultipleLines:(NSString*) inLines {
    [self appendStringContainingMultipleLines:inLines trimWhitespace:YES];
}

- (NSString*) description {
    return [self prettyDescription];
}

- (void) appendPrettyDescriptionForObject:(id) object {
    [self appendLineWithFormat:@"%@ {", NSStringFromClass([self class])];
    [self indentLinesInBlock:^{
        [object prettyDescription:self];
    }];
    [self appendLine:@"}"];
}

@end

#import "FLStackTrace.h"
#import "FLLog.h"

@implementation FLIndentIntegrity
+ (id) indentIntegrity {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {	
	self = [super init];
	if(self) {
		_top = -1;
        _stackTraces = [[NSMutableArray alloc] init];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_stackTraces release];
	[super dealloc];
}
#endif

- (void) push:(NSUInteger) level {
    _stack[++_top] = level;
    [_stackTraces addObject:FLCreateStackTrace(YES)];
}

- (NSUInteger) top {
    return _top >= 0 ? _stack[_top] : NSNotFound;
}

- (void) pop:(NSUInteger) level {
    FLAssert(_top >= 0, @"outdenting too far");

    if(self.top != level) {
        FLLog(@"popping incorrect indent level %ld, should be %ld\ntraces: %@", (unsigned long) level, (unsigned long) self.top, nil /*[_stackTraces prettyDescription]*/);
    }
    if(_top >= 0) {
        --_top;
        [_stackTraces removeLastObject];
    }
}

@end

