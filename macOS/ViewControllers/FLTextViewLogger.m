//
//  FLTextViewLogger.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 6/17/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTextViewLogger.h"
#import "FLWhitespace.h"

@interface FLTextViewLogger()
@property (readwrite, nonatomic, strong) NSMutableAttributedString* buffer;
@end

@implementation FLTextViewLogger

@synthesize buffer = _buffer;
@synthesize textView = _textView;

- (id) initWithTextView:(NSTextView*) textView {
	self = [super init];
	if(self) {
		self.textView = textView;
    }
	return self;
}

+ (id) textViewLogger:(NSTextView*) textView {
    return FLAutorelease([[[self class] alloc] initWithTextView:textView]);
}

+ (id) textViewLogger {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void)dealloc {
    [_textView release];
    [_buffer release];
	[super dealloc];
}
#endif

#define kDelay 0.5

- (void) queueBlock:(dispatch_block_t) block {

    if(block) block();
    return;

    double delayInSeconds = kDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

- (void) appendBufferToTextStorage {
    if(!_buffer) {
        return;
    }

//    if([NSDate timeIntervalSinceReferenceDate] - _lastUpdate > kDelay) {
        NSTextStorage* textStorage = [_textView textStorage];
        NSRange range = NSMakeRange(textStorage.length, 0);
        
        float scrollBottom = NSMaxY(_textView.visibleRect);
        float contentHeight = NSMaxY(_textView.bounds);
        
        BOOL scroll = (contentHeight == scrollBottom);
        [textStorage beginEditing];
        [textStorage replaceCharactersInRange:range withAttributedString:_buffer];
        [textStorage endEditing];
        
        self.buffer = nil;
        _lastUpdate = [NSDate timeIntervalSinceReferenceDate];
    
        if(scroll && contentHeight > scrollBottom) {
//            [_textView scrollRangeToVisible:NSMakeRange(textStorage.length, 0)];
        }
//    }
//    else {
//        [self addBlock:^{
//            [self appendBufferToTextStorage];
//        }];
//    }
}

- (void) appendAttributedStringToStorage:(NSAttributedString*) string {

    if(_buffer) {
        [_buffer appendAttributedString:string];
    }
    else {
        _buffer = [string mutableCopy];
    }

    [self appendBufferToTextStorage];
}

- (void) appendStringToStorage:(NSString*) string {
    NSAttributedString* attrstring = FLAutorelease([[NSAttributedString alloc] initWithString:string]);
    [self appendAttributedStringToStorage:attrstring];
}

- (FLWhitespace*) whitespace {
    return [FLWhitespace tabbedWithSpacesWhitespace];
}

//- (void) appendEOL {
//    [self appendStringToStorage:self.whitespace.eolString];
//}

- (void) clearContents {
    FLAssertNotNil(_textView);

    [[_textView textStorage] deleteCharactersInRange:NSMakeRange(0, [_textView textStorage].length) ];
    self.buffer = nil;
}

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
                      appendString:(NSString*) string {
    [self appendStringToStorage:string];
}

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
            appendAttributedString:(NSAttributedString*) attributedString {
    [self appendAttributedStringToStorage:attributedString];
}

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
       appendContentsToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter {
}

- (NSUInteger) whitespaceStringFormatterGetLength:(FLWhitespaceStringFormatter*) stringFormatter {
    return [_textView textStorage].length + _buffer.length;
}

- (NSString*) whitespaceStringFormatterExportString:(FLWhitespaceStringFormatter*) formatter {
    return nil;
}

- (NSAttributedString*) whitespaceStringFormatterExportAttributedString:(FLWhitespaceStringFormatter*) formatter {
    return nil;
}






//- (void) stringFormatterOpenLine:(FLStringFormatter*) stringFormatter {
//    [self appendStringToStorage:[self.whitespace tabStringForScope:self.indentLevel]];
//}
//
//- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) stringFormatter {
//    [self appendEOL];
//}
//
//- (void) stringFormatterCloseLine:(FLStringFormatter*) stringFormatter {
//    [self appendEOL];
//}





//- (void) stringFormatter:(FLStringFormatter*) stringFormatter
//appendSelfToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter {
//
//}

@end

