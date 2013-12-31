//
//  FLAbstractStringFormatter.h
//  FishLampCore
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"
#import "FLStringFormatterDelegate.h"

typedef void (^FLStringFormatterIndentedBlock)();

@class FLIndentIntegrity;

@protocol FLStringFormatter;
@protocol FLStringPreprocessor;

@protocol FLStringFormatting <NSObject>
- (void) appendToStringFormatter:(id<FLStringFormatter>) stringFormatter;
@end

@protocol FLStringFormatter <FLStringFormatting>

@property (readonly, assign, nonatomic) NSUInteger length;

@property (readonly, assign, nonatomic) BOOL isEmpty;

/// ends currently open line, opens a new one.
- (void) openLine;

- (void) openLineWithString:(id) anyStringOrStringFormatter;

- (void) openLineWithFormat:(NSString*) format, ... NS_FORMAT_FUNCTION(1,2);

/**
 *  Append a string
 *  
 *  @param string either a NSString or a NSAttributedString
 */
- (void) appendString:(id) anyStringOrStringFormatter;

- (void) appendFormat:(NSString*) format, ... NS_FORMAT_FUNCTION(1,2);

- (void) appendFormat:(NSString*) format arguments:(va_list)argList;

// end current line with EOF (only if it hasn't already been ended)
- (void) closeLine;

/// Ends currently open line, then adds a blank line. Leaves no open line.
- (void) appendBlankLine;

/**
 *  Append a string with a LF appended
 *  
 *  @param line either a NSString or a NSAttributedString
 */
- (void) appendLine:(id) anyStringOrStringFormatter;

- (void) appendLineWithFormat:(NSString*) format, ... NS_FORMAT_FUNCTION(1,2);

- (void) appendLineWithFormat:(NSString*) format arguments:(va_list)argList;

/// indent the string (optionally implemented by delegate)
@property (readonly, nonatomic, assign) NSInteger indentLevel;

/**
 *  Indent in a block. All calls inside the block are indented once.
 *  Note: if delegate doesn't implement indentLevel, then the block is executed anyway and resulting text will not be indented.
 *
 *  @param block the block in which to append content to this formatter
 */
- (void) indentLinesInBlock:(FLStringFormatterIndentedBlock) block;

- (void) indent:(FLIndentIntegrity*) integrity;

- (void) outdent:(FLIndentIntegrity*) integrity;

/**
 *  Export a NSString version of the string
 *  
 *  @return NSString
 */
- (NSString*) formattedString;

/**
 *  Export a NSAttributedString version of the string
 *  
 *  @return NSAttributedString
 */
- (NSAttributedString*) formattedAttributedString;

- (void) appendPrettyDescriptionForObject:(id) object;

@end

/**
 *  Concrete base class for a string formatter.
 */
@interface FLStringFormatter : NSObject<FLStringFormatter> {
@private
    __unsafe_unretained id _stringFormatterDelegate;
    id<FLStringPreprocessor> _preprocessor;
    NSInteger _indentLevel;
    FLIndentIntegrity* _indentIntegrity;
}

/**
 *  The delegate implements the guts of the string formatter. By default the delegate is set to self because most of the time we will be subclass FLStringFormatter.
 *  @interface MyStringFormatter : FLStringFormatter<FLStringFormatterDelegate>
 */
@property (readwrite, assign, nonatomic) id stringFormatterDelegate;

@property (readwrite, strong, nonatomic) id<FLStringPreprocessor> preprocessor;

@property (readonly, strong, nonatomic) FLIndentIntegrity* indentIntegrity;

@end


@interface NSString (FLStringFormatter)
- (void) appendToStringFormatter:(id<FLStringFormatter>) stringFormatter;
@end

@interface NSAttributedString (FLStringFormatter)
- (void) appendToStringFormatter:(id<FLStringFormatter>) stringFormatter;
@end

@interface FLIndentIntegrity : NSObject {
@private
    NSInteger _top;
    NSUInteger _stack[64];

    NSMutableArray* _stackTraces;
}
+ (id) indentIntegrity;

@property (readonly, assign, nonatomic) NSUInteger top;
- (void) push:(NSUInteger) level;
- (void) pop:(NSUInteger) level;
@end

