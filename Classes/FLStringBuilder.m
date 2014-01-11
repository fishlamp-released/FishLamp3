//
//  FLScopeStringBuilder.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 2/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringBuilder.h"
#import "FLPrettyString.h"
#import "FLPrettyAttributedString.h"
#import "NSArray+FishLampCore.h"

@interface FLStringBuilder ()
@property (readonly, strong, nonatomic) id<FLStringFormatter> rootStringBuilder;
@property (readonly, strong, nonatomic) NSArray* stack;
@end

@interface FLStringBuilderSection (Internal)
@property (readwrite, assign, nonatomic) id parent;
@property (readwrite, assign, nonatomic) id stringDocument;
@end

@implementation FLStringBuilder 

@synthesize stack = _stack;

- (void) addRootSection {
    FLStringBuilderSection* section = [FLStringBuilderSection stringBuilderSection];
    section.stringDocument = self;
    [_stack addObject:section];
}

- (id) init {
    self = [super init];
    if(self) {
        _stack = [[NSMutableArray alloc] init];
        [self addRootSection];
    }
    return self;
}

+ (id) stringBuilder {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_stack release];
    [super dealloc];
}
#endif

- (void) deleteAllStringBuilders {
    [_stack removeAllObjects];
    [self addRootSection];
}

- (id<FLStringFormatter>) rootStringBuilder {
    FLAssertNotNil([_stack objectAtIndex:0]);
    return [_stack objectAtIndex:0];
}

- (FLStringBuilderSection*) openedSection {
    FLAssertNotNil([_stack lastObject]);
    return [_stack lastObject];
}

//- (void) appendStringFormatter:(id<FLStringFormatter>) formatter {
//    FLAssert(_stack.count > 0);
//    
//    [self.openedSection appendStringFormatter:formatter
//                             withPreprocessor:[FLStringFormatterLineProprocessor instance]];
//}


- (void) appendSection:(FLStringBuilderSection*) section {
    FLAssert(_stack.count > 0);
    [[self openedSection] appendSection:section];
}

- (void) openSection:(FLStringBuilderSection*) section {
    [self appendSection:section];
    [_stack addObject:section];
}

- (void) closeSection {
    FLAssert(_stack.count > 0);
    __unused id section = FLRetainWithAutorelease(self.openedSection);
    [_stack removeLastObject_fl];
}

- (void) closeAllSections {
    while(_stack.count > 1) {
        [self closeSection];
    }
}

- (void) stringFormatter:(FLStringFormatter*) formatter
            appendString:(NSString*) string {
    [[self openedSection] appendString:string];
}

- (void) stringFormatter:(FLStringFormatter*) formatter
  appendAttributedString:(NSAttributedString*) attributedString {
    [[self openedSection] appendString:attributedString];
}

- (NSString*) stringFormatterExportString:(FLStringFormatter*) formatter {
    return [self buildString];
}

- (NSAttributedString*) stringFormatterExportAttributedString:(FLStringFormatter*) formatter {
    FLPrettyAttributedString* prettyString = [FLPrettyAttributedString prettyAttributedString];
    [prettyString appendString:self];
    return [prettyString formattedAttributedString];
}

- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) formatter{
    [[self openedSection] appendBlankLine];
}

- (void) stringFormatterOpenLine:(FLStringFormatter*) formatter {
    [[self openedSection] openLine];
}

- (void) stringFormatterCloseLine:(FLStringFormatter*) formatter {
    [[self openedSection] closeLine];
}

- (NSInteger) stringFormatterIndentLevel:(FLStringFormatter*) formatter{
    return [[self openedSection] indentLevel];
}

- (void) stringFormatterIndent:(FLStringFormatter*) formatter {
    [[self openedSection] indent:self.indentIntegrity];
}

- (void) stringFormatterOutdent:(FLStringFormatter*) formatter {
    [[self openedSection] outdent:self.indentIntegrity];
}

- (NSUInteger) stringFormatterLength:(FLStringFormatter*) formatter {

    NSUInteger length = 0;
    for(id<FLStringFormatter> aFormatter in _stack) {
        length += aFormatter.length;
    }

    return length;
}

- (NSString*) buildString {
    return [self buildStringWithWhitespace:[FLWhitespace defaultWhitespace]];
}

- (NSAttributedString*) buildAttributedString {
    return nil;
}

- (NSString*) buildStringWithWhitespace:(FLWhitespace*) whitespace {
    FLPrettyString* prettyString = [FLPrettyString prettyString:whitespace];
    [prettyString appendString:self];
    return prettyString.string;
}

- (NSString*) buildStringWithNoWhitespace {
    return [self buildStringWithWhitespace:nil];
}

- (void)stringFormatter:(FLStringFormatter*) formatter
appendContentsToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter  {

    [anotherStringFormatter appendString:self.rootStringBuilder];
}

- (void) appendSection:(FLStringBuilderSection*) section
   withSubsectionBlock:(fl_block_t) block {
    @try {
        [self openSection:section];
        if(block) {
            block();
        }
    }
    @finally {
        [self closeSection];
    }
}

@end
