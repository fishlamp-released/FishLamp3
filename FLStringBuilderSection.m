//
//  FLStringBuilderSection.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringBuilderSection.h"
#import "FLWhitespace.h"
#import "FLPrettyDescription.h"

#import "FLPrettyAttributedString.h"
#import "FLPrettyString.h"

@interface FLStringBuilderSection ()
@property (readwrite, assign, nonatomic) id parentSection;
@property (readwrite, assign, nonatomic) id stringDocument;

- (void) appendSection:(FLStringBuilderSection*) section;
@end

@interface FLDocumentSectionIndent : NSObject<FLStringFormatting>
+ (id) documentSectionIndent;
@end

@interface FLDocumentSectionOutdent : NSObject<FLStringFormatting>
+ (id) documentSectionOutdent;
@end

@interface FLDocumentSectionEOL : NSObject<FLStringFormatting>
+ (id) documentSectionEOL;
@end

@interface FLDocumentSectionBlankLine : NSObject<FLStringFormatting>
+ (id) documentSectionBlankLine;
@end


@implementation FLDocumentSectionIndent
+ (id) documentSectionIndent {
    FLReturnStaticObject(FLAutorelease([[[self class] alloc] init]));
}
- (void) appendToStringFormatter:(id<FLStringFormatter>) stringFormatter  {
    [stringFormatter indent:nil];
}
- (NSString*) description {
    return @"-->";
}
@end

@implementation FLDocumentSectionOutdent
+ (id) documentSectionOutdent {
    FLReturnStaticObject(FLAutorelease([[[self class] alloc] init]));
}
- (void) appendToStringFormatter:(id<FLStringFormatter>) stringFormatter  {
    [stringFormatter outdent:nil];
}
- (NSString*) description {
    return @"<--";
}

@end

@implementation FLDocumentSectionEOL
+ (id) documentSectionEOL {
    FLReturnStaticObject(FLAutorelease([[[self class] alloc] init]));
}
- (void) appendToStringFormatter:(id<FLStringFormatter>) stringFormatter  {
    [stringFormatter closeLine];
}
- (NSString*) description {
    return @"EOL";
}

@end


@implementation FLDocumentSectionBlankLine
+ (id) documentSectionBlankLine {
    FLReturnStaticObject(FLAutorelease([[[self class] alloc] init]));
}
- (void) appendToStringFormatter:(id<FLStringFormatter>) stringFormatter  {
    [stringFormatter appendBlankLine];
}
- (NSString*) description {
    return @"LINE";
}

@end

@implementation FLStringBuilderSection 

@synthesize lines = _lines;
@synthesize parentSection = _parentSection;
@synthesize stringDocument = _stringDocument;

- (id) init {
    self = [super init];
    if(self) {
        _lines = [[NSMutableArray alloc] init];
    }    
    return self;
}

+ (id) stringBuilderSection {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_lines release];
    [super dealloc];
}
#endif

- (id) lastLine {
    FLAssertNotNil(_lines);
    FLAssertNotNil([_lines lastObject]);
    return [_lines lastObject];
}

- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) stringFormatter {
    FLAssertNotNil(_lines);
    FLAssertNotNil(stringFormatter);

    [_lines addObject:[FLDocumentSectionBlankLine documentSectionBlankLine]];
    _needsLine = YES;
    _lineOpen = NO;
}

- (void) stringFormatterOpenLine:(FLStringFormatter*) stringFormatter {
    FLAssertNotNil(_lines);
    FLAssertNotNil(stringFormatter);
    _needsLine = YES;
    _lineOpen = YES;
}

- (void) stringFormatterCloseLine:(FLStringFormatter*) stringFormatter {
    FLAssertNotNil(_lines);
    FLAssertNotNil(stringFormatter);

    [_lines addObject:[FLDocumentSectionEOL documentSectionEOL]];

    _needsLine = YES;
    _lineOpen = NO;
}

- (void) stringFormatter:(FLStringFormatter*) formatter
            appendString:(NSString*) string {

    FLAssertNotNil(_lines);
    FLAssertNotNil(string);

    if(_needsLine) {
        [_lines addObject:FLAutorelease([string mutableCopy])];
        _needsLine = NO;
    }
    else {
        FLAssert([self.lastLine isKindOfClass:[NSMutableString class]]);
        [self.lastLine appendString:string];
    }
}

- (void) stringFormatter:(FLStringFormatter*) formatter
  appendAttributedString:(NSAttributedString*) attributedString {
      [self stringFormatter:formatter appendString:attributedString.string];
}

- (void) stringFormatterIndent:(FLStringFormatter*) formatter {
    FLAssertNotNil(_lines);
    [_lines addObject:[FLDocumentSectionIndent documentSectionIndent]];
}

- (void) stringFormatterOutdent:(FLStringFormatter*) formatter {
    FLAssertNotNil(_lines);
    [_lines addObject:[FLDocumentSectionOutdent documentSectionOutdent]];
}

- (void) willBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter {
}

- (void) didBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter {
}

- (void) didMoveToParent:(FLStringBuilderSection*) parentSection {
}

- (void)stringFormatter:(FLStringFormatter*) formatter
appendContentsToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter  {

    FLAssertNotNil(_lines);
    FLAssertNotNil(anotherStringFormatter);

    [self willBuildWithStringFormatter:anotherStringFormatter];

    for(id<FLStringFormatter> line in _lines) {
        [anotherStringFormatter appendString:line];
    }

    [self didBuildWithStringFormatter:anotherStringFormatter];
}

- (void) setStringDocument:(FLStringBuilder*) document {
    _stringDocument = document;
    for(id line in _lines) {
        if([line respondsToSelector:@selector(setStringDocument:)]) {
            [line setStringDocument:document];
        }
    }
}

- (void) setParentSection:(FLStringBuilderSection*) parentSection {
    if(_parentSection) {
        [self didMoveToParent:nil];
    }

    _parentSection = parentSection;
    [self didMoveToParent:_parentSection];
}

- (void) appendSection:(FLStringBuilderSection*) section {

    FLAssertNotNil(_lines);
    FLAssertNotNil(section);

    [_lines addObject:section];
    _needsLine = YES;
    [section setStringDocument:self.stringDocument];
    [section setParentSection:self];
}

//- (void) stringFormatterDeleteAllCharacters:(FLStringFormatter*) stringFormatter {
//    FLAssertNotNil(_lines);
//    FLAssertNotNil(stringFormatter);
//
//    [_lines removeAllObjects];
//}

- (NSUInteger) stringFormatterLength:(FLStringFormatter*) formatter {
    FLAssertNotNil(_lines);

    NSUInteger length = 0;
    for(id<FLStringFormatter> line in _lines) {
        length += line.length;
    }
    return length;
}

- (void) stringFormatter:(FLStringFormatter*) formatter
         didMoveToParent:(id) parentSection {
}

- (NSString*) stringFormatterExportString:(FLStringFormatter*) formatter {
    FLPrettyString* str = [FLPrettyString prettyString];
    [str appendString:self];
    return str.string;
}

- (NSAttributedString*) stringFormatterExportAttributedString:(FLStringFormatter*) formatter {
    FLPrettyAttributedString* string = [FLPrettyAttributedString prettyAttributedString];
    [string appendString:self];
    return [string formattedAttributedString];
}



@end

