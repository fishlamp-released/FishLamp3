//
//  FLActivityLog.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/2/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLActivityLog.h"
#import "FLAttributedString.h"
#import "FLColorModule.h"

NSString* const FLActivityLogUpdated = @"FLActivityLogUpdated";
NSString* const FLActivityLogStringKey = @"FLActivityLogStringKey";

@implementation FLActivityLog

@synthesize activityLogTextFont = _textFont;
@synthesize activityLogTextColor = _textColor;

#if FL_MRC
- (void) dealloc {
    [_textFont release];
    [_textColor release];
    [super dealloc];
}
#endif

+ (id) activityLog {
    return FLAutorelease([[[self class] alloc] init]);
}

//- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) stringFormatter {
//    [_log stringFormatterAppendBlankLine:stringFormatter];
//}

- (void) willOpenLine {

    if(self.indentLevel == 0) {

        NSString* timeStamp = [NSString stringWithFormat:@"[%@]: ", 
            [NSDateFormatter localizedStringFromDate:[NSDate date] 
                                           dateStyle:NSDateFormatterShortStyle 
                                           timeStyle:kCFDateFormatterLongStyle]];


        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSColor gray15Color], NSForegroundColorAttributeName, 
            self.activityLogTextFont, NSFontAttributeName, nil];

        NSMutableAttributedString* string = 
            FLAutorelease([[NSMutableAttributedString alloc] initWithString:timeStamp attributes:attributes]);

        [self appendString:string];
    }
}

//- (void) stringFormatterCloseLine:(FLStringFormatter*) stringFormatter {
//    [_log stringFormatterCloseLine:stringFormatter];
//}
//
//- (void) stringFormatter:(FLStringFormatter*) stringFormatter appendString:(NSString*) string {
//    [_log stringFormatter:stringFormatter appendString:string];
//}
//
//- (void) stringFormatter:(FLStringFormatter*) stringFormatter appendAttributedString:(NSAttributedString*) attributedString {
//    [_log stringFormatter:stringFormatter appendAttributedString:attributedString];
//}
//
//- (void) stringFormatterIndent:(FLStringFormatter*) stringFormatter {
//    [_log stringFormatterIndent:stringFormatter];
//}
//
//- (void) stringFormatterOutdent:(FLStringFormatter*) stringFormatter {
//    [_log stringFormatterOutdent:stringFormatter];
//}
//
//- (NSUInteger) stringFormatterGetLength:(FLStringFormatter*) stringFormatter {
//    return [_log length];
//}
//
//- (void) stringFormatter:(FLStringFormatter*) myFormatter
//appendContentsToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter {
//    [_log stringFormatter:myFormatter appendContentsToStringFormatter:anotherStringFormatter];
//}
//
//- (NSString*) string {
//    return [_log string];
//}
//
//- (NSAttributedString*) attributedString {
//    return [_log attributedString];
//}
//
//- (NSString*) description {
//    return [_log description];
//}

- (NSError*) exportToPath:(NSURL*) url {
    NSString* log = [self formattedString];
    NSError* err = nil;
    [log writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:&err];
    return FLAutorelease(err);
}

#define kActivityLog @"ActivityLog"

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
            appendAttributedString:(NSAttributedString*) string {

#if TRACE
    FLLog(@"ActivityLog: %@", string.string);
#endif

    NSAttributedString* theString = string;
    if(_textFont || _textColor) {
    
        NSRange range = string.entireRange;
        NSDictionary* attributes = [string attributesAtIndex:0 effectiveRange:&range];

        NSMutableDictionary* attr = FLMutableCopyWithAutorelease(attributes);
        if(_textFont && [attr objectForKey:NSFontAttributeName] == nil) {
            [attr setObject:self.activityLogTextFont forKey:NSFontAttributeName];
        }
        if(_textColor && [attr objectForKey:NSForegroundColorAttributeName] == nil) {
            [attr setObject:[NSColor gray15Color] forKey:NSForegroundColorAttributeName];
        }

        theString = FLAutorelease([[NSAttributedString alloc] initWithString:string.string attributes:attr]);
    }
    
    [super whitespaceStringFormatter:stringFormatter appendAttributedString:theString];

    [[NSNotificationCenter defaultCenter] postNotificationName:FLActivityLogUpdated
                                                        object:self
                                                        userInfo:[NSDictionary dictionaryWithObject:string forKey:FLActivityLogStringKey]];
}

- (void) appendURL:(NSURL*) url string:(NSString*) string {
    NSMutableDictionary* attr = [NSMutableDictionary dictionary];
    [attr setObject:url forKey:NSLinkAttributeName];
//    [attr setObject:[NSFont boldSystemFontOfSize:[NSFont smallSystemFontSize]] forKey:NSFontAttributeName];
//    [attr setObject:[NSNumber numberWithBool:NO] forKey:NSUnderlineStyleAttributeName];
//    [attr setAttributedStringColor:[NSColor gray20Color]];
    [self appendString:FLAutorelease([[NSAttributedString alloc] initWithString:string attributes:attr])];
}

- (void) appendLineWithURL:(NSURL*) url string:(NSString*) string {
    [self appendURL:url string:string];
    [self closeLine];
}

- (void) clear {
    [self deleteAllCharacters];
}

- (void) appendErrorLine:(NSString*) errorLine {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSColor redColor], NSForegroundColorAttributeName, 
        self.activityLogTextFont, NSFontAttributeName, nil];

    NSMutableAttributedString* string = 
        FLAutorelease([[NSMutableAttributedString alloc] initWithString:errorLine attributes:attributes]);

    [self appendLine:string];

}

- (void) appendBoldTitle:(NSString*) title {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSColor gray15Color], NSForegroundColorAttributeName, 
        self.activityLogTextFont, NSFontAttributeName, nil];

    NSMutableAttributedString* string = 
        FLAutorelease([[NSMutableAttributedString alloc] initWithString:title attributes:attributes]);

    [self appendString:string];
}

- (void) appendBoldTitleLine:(NSString*) title {
    [self appendBoldTitle:title];
    [self closeLine];
}

@end
