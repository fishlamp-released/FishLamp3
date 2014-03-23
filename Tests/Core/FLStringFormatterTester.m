//
//  FLStringFormatterTester.m
//  FishLampCore
//
//  Created by Mike Fullerton on 10/19/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLStringFormatterTester.h"
#import "FishLampTesting.h"

@implementation FLTestWhitespace

- (id) initWithEOL:(NSString*) eol {
    return [super initWithEOL:eol tabChar:@">" tabCharRepeatCount:1];
}

+ (id) testWhitespace {
    return FLAutorelease([[[self class] alloc] initWithEOL:FLWhitespaceDefaultEOL]);
}

@end

@implementation FLStringFormatterTester

- (id<FLStringFormatter>) createStringFormatter {
    return nil;
}

- (id<FLStringFormatter>) createStringFormatter:(FLWhitespace*) whiteSpace {
    return nil;
}

- (NSString*) formattedString:(id) formatter
                   whitespace:(FLWhitespace*) whitespace {
    return [formatter formattedString];
}

- (NSAttributedString*) formattedAttributedString:(id) formatter
                   whitespace:(FLWhitespace*) whitespace {
    return [formatter formattedAttributedString];
}

- (void) testPrettyString1 {
    id<FLStringFormatter> stringFormatter = [self createStringFormatter];
    [stringFormatter appendString:@"hello world"];

    NSString* string = [[self formattedAttributedString:stringFormatter whitespace:[FLTestWhitespace testWhitespace]] string];
    NSString* string2 = [self formattedString:stringFormatter whitespace:[FLTestWhitespace testWhitespace]];

    FLConfirmNotNil(string);
    FLConfirmNotNil(string2);
    FLConfirmStringsAreEqual(string, string2);
    FLConfirmStringsAreEqual(string, @"hello world");

}

- (void) testPrettyStringLines {

    id<FLStringFormatter> string = [self createStringFormatter];
    [string appendLine:@"this"];
    [string appendLine:@"is"];
    [string appendLine:@"a"];
    [string appendLine:@"test"];

    NSString* result = @"this\nis\na\ntest\n";

    NSString* exportedString = [self formattedString:string whitespace:[FLTestWhitespace testWhitespace]];
    FLConfirmNotNil(exportedString);
    FLConfirmStringsAreEqual(result, exportedString);
}

- (void) testPrettyStringNoWhitespace {
    id<FLStringFormatter> string = [self createStringFormatter:[FLWhitespace compressedWhitespace]];

    [string appendLine:@"this"];
    [string appendLine:@"is"];
    [string appendLine:@"a"];
    [string appendLine:@"test"];

    NSString* result = @"thisisatest";

    NSString* exportedString = [self formattedString:string whitespace:[FLWhitespace compressedWhitespace]];
    FLConfirmNotNil(exportedString);
    FLConfirmStringsAreEqual(result, exportedString);
}

- (void) testDefaultWhitespace {
    FLConfirm(   [FLWhitespace defaultWhitespace] ==
                [FLWhitespace tabbedWithSpacesWhitespace]);
}

- (void) testWhitespaceTabs {
    for(int i = 0; i < 5;i++) {
        NSString* tab = [[FLWhitespace defaultWhitespace] tabStringForScope:i];

        FLConfirm(tab.length == i * 4);
        for(int j = 0; j < tab.length; j++) {
            FLConfirm([tab characterAtIndex:j] == ' ');
        }
    }
}

- (NSString*) spaces:(int) count {
    NSMutableString* string = [NSMutableString string];
    for(int i = 0; i < count; i++) {
        [string appendString:@" "];
    }
    return string;
}

static NSString* indent_result = @"foo\n>hello\n>>world\n>bar\nfoobar\n";

- (void) testPrettyStringIndent1 {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    FLConfirmStringsAreEqual(@"", [self formattedString:string whitespace:[FLTestWhitespace testWhitespace]]);
    FLConfirm(string.indentLevel == 0);

    FLIndentIntegrity* integrity = [FLIndentIntegrity indentIntegrity];

    [string appendLine:@"foo"];
    [string indent:integrity];
        FLConfirm(string.indentLevel == 1);
        [string appendLine:@"hello"];
        [string indent:integrity];
            FLConfirm(string.indentLevel == 2);
            [string appendLine:@"world"];
            [string outdent:integrity];
        FLConfirm(string.indentLevel == 1);
        [string appendLine:@"bar"];
        [string outdent:integrity];
    FLConfirm(string.indentLevel == 0);
    [string appendLine:@"foobar"];

    FLConfirmStringsAreEqual(indent_result, [self formattedString:string whitespace:[FLTestWhitespace testWhitespace]]);
}

- (void) testPrettyStringIndent2 {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    FLConfirmStringsAreEqual(@"", [self formattedString:string whitespace:[FLTestWhitespace testWhitespace]]);
    [string appendLine:@"foo"];
    FLConfirm(string.indentLevel == 0);

    [string indentLinesInBlock:^{
        FLConfirm(string.indentLevel == 1);
        [string appendLine:@"hello"];

        [string indentLinesInBlock:^{
            FLConfirm(string.indentLevel == 2);
            [string appendLine:@"world"];
        }];
        FLConfirm(string.indentLevel == 1);

        [string appendLine:@"bar"];
    }];

    [string appendLine:@"foobar"];
     FLConfirm(string.indentLevel == 0);

    FLConfirmStringsAreEqual(indent_result, [self formattedString:string whitespace:[FLTestWhitespace testWhitespace]]);
}

- (void) testAppendString {
    id<FLStringFormatter> string = [self createStringFormatter];
    [string appendString:@"Hello"];
    [string appendString:@" "];
    [string appendString:@"World"];
    FLConfirmStringsAreEqual([self formattedString:string whitespace:[FLTestWhitespace testWhitespace]], @"Hello World");

    [string closeLine];
    FLConfirmStringsAreEqual([self formattedString:string whitespace:[FLTestWhitespace testWhitespace]], @"Hello World\n");
}

- (void) testPrettyStringAppendBlankLine {
    id<FLStringFormatter> string = [self createStringFormatter];
    [string appendBlankLine];
    [string appendBlankLine];
    [string appendBlankLine];

    FLConfirmStringsAreEqual(@"\n\n\n", [self formattedString:string whitespace:[FLTestWhitespace testWhitespace]]);
}

- (void) testSimpleStringFormatterAppend {
    id<FLStringFormatter> string1 = [self createStringFormatter];
    [string1 appendLine:@"hello"];

    id<FLStringFormatter> string2 = [self createStringFormatter];
    [string2 appendLine:@"world"];

    [string1 appendString:string2];

    FLConfirmStringsAreEqual([self formattedString:string1 whitespace:[FLTestWhitespace testWhitespace]], @"hello\nworld\n");
}

- (void) testIndentedStringFormatterAppend {
    id<FLStringFormatter> string1 = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string1 appendLine:@"a"];
    [string1 indentLinesInBlock:^{
        [string1 appendLine:@"b"];

        id<FLStringFormatter> string2 = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
        [string2 appendLine:@"c"];
        [string2 indentLinesInBlock:^{
            [string2 appendLine:@"d"];
        }];

        [string1 appendString:string2];
    }];

    FLConfirmStringsAreEqual([self formattedString:string1 whitespace:[FLTestWhitespace testWhitespace]], @"a\n>b\n>c\n>>d\n");
}

- (void) testAppendLine {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string appendLine:@"hello"];
    FLConfirmStringsAreEqual([self formattedString:string whitespace:[FLTestWhitespace testWhitespace]], @"hello\n");
}

- (void) testAppendFormat {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string appendFormat:@"hello %@", @"world"];
    FLConfirmStringsAreEqual([self formattedString:string whitespace:[FLTestWhitespace testWhitespace]], @"hello world");
}

- (void) testAppendLineWithFormat {
    id<FLStringFormatter> string = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string appendLineWithFormat:@"hello %@", @"world"];
    FLConfirmStringsAreEqual([self formattedString:string whitespace:[FLTestWhitespace testWhitespace]], @"hello world\n");
}


- (void) testLineWithLineFeedInIt {
    id<FLStringFormatter> string1 = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string1 appendLine:@"hello\nworld"];

    FLConfirmStringsAreEqual([self formattedString:string1 whitespace:[FLTestWhitespace testWhitespace]], @"hello\nworld\n");
}

- (void) testLineWithLineFeedInIt1 {
    id<FLStringFormatter> string1 = [self createStringFormatter:[FLTestWhitespace testWhitespace]];
    [string1 appendString:@"hello\nworld"];

    FLConfirmStringsAreEqual([self formattedString:string1 whitespace:[FLTestWhitespace testWhitespace]], @"hello\nworld");
}



@end
