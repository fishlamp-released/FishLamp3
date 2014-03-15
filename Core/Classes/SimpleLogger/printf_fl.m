//
//  printf_fl.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "printf_fl.h"
#import "FLWhitespace.h"
#import "FishLampRequired.h"

@implementation FLPrintfStringFormatter

FLSynthesizeSingleton(FLPrintfStringFormatter);

@synthesize rememberHistory = _rememberHistory;

- (id) init {	
	self = [super init];
	if(self) {
#if DEBUG
        _rememberHistory = YES;
#endif
	}
	return self;
}

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
                      appendString:(NSString*) string {


//    if(string) {
//        CFShow(FLBridge(CFStringRef,string));
//        [_history appendString:string];
//        _length += string.length;
//    }
//
//    const char* c_str = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    if(c_str) {
//        fprintf(stderr, "stderr: %s", c_str);
//    }
//
//    CFShow(@"WTF");


//        fprintf(stderr, "(%s) (%s:%d) %s",
//            functionName, [fileName UTF8String],
//            lineNumber, [body UTF8String]);
//
//

    if(string.length) {

        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if(string.length) {
            NSLog(@"%@", string);
        }
    }
}

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
            appendAttributedString:(NSAttributedString*) attributedString {

    [self whitespaceStringFormatter:stringFormatter appendString:attributedString.string];
}

- (void) whitespaceStringFormatter:(FLWhitespaceStringFormatter*) stringFormatter
   appendContentsToStringFormatter:(id<FLStringFormatter>) anotherStringFormatter {

    if(_history) {
        [anotherStringFormatter appendString:_history];
    }
}

- (NSUInteger) whitespaceStringFormatterGetLength:(FLWhitespaceStringFormatter*) stringFormatter {
    return _length;
}

- (NSString*) whitespaceStringFormatterExportString:(FLWhitespaceStringFormatter*) formatter {
    return _history;
}

- (NSAttributedString*) whitespaceStringFormatterExportAttributedString:(FLWhitespaceStringFormatter*) formatter {
    return FLAutorelease([[NSAttributedString alloc] initWithString:_history]);
}


@end
