//
//  FLTestLoggingManager.m
//  FishLampCore
//
//  Created by Mike Fullerton on 8/28/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestLoggingManager.h"
#import "FLAssertions.h"
#import "FLTestCase.h"
#import "FLTestResult.h"
#import "FLTestResultLogEntry.h"

@implementation FLTestLoggingManager

dispatch_once_t s_predicate = 0;

FLSynthesizeSingleton(FLTestLoggingManager)

- (NSArray*) array {
    return _loggers;
}

- (id) init {	
	self = [super init];
	if(self) {
        _loggers = [[NSMutableArray alloc] init];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_loggers release];
	[super dealloc];
}
#endif

- (void) addLogger:(id<FLStringFormatter>) formatter {
    FLCriticalSection(&s_predicate, ^{
        FLAssertNotNil(formatter);
        [_loggers addObject:formatter];
    });
}

- (void) pushLogger:(id<FLStringFormatter>) formatter {
    FLCriticalSection(&s_predicate, ^{
        FLAssertNotNil(formatter);
        [_loggers insertObject:formatter atIndex:0];
    });
}

- (void) popLogger {
    FLCriticalSection(&s_predicate, ^{
        [_loggers removeObjectAtIndex:0];
    });
}

- (id<FLStringFormatter>) logger {
    return [_loggers objectAtIndex:0];
}

- (void) visitLoggers:(void (^)(id<FLStringFormatter> logger)) visitor {
    FLCriticalSection(&s_predicate, ^{
        for(id<FLStringFormatter> logger in _loggers) {
            visitor(logger);
        }
    });
}

- (void) visitLoggersForOutput:(void (^)(id<FLStringFormatter> logger)) visitor {
    FLCriticalSection(&s_predicate, ^{
        for(id<FLStringFormatter> logger in _loggers) {
            visitor(logger);
        }
    });
}

- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) formatter {
    [self visitLoggersForOutput:^(id<FLStringFormatter> logger) {
        [logger appendBlankLine];
    }];
}

- (void) stringFormatterOpenLine:(FLStringFormatter*) formatter {
    [self visitLoggersForOutput:^(id<FLStringFormatter> logger) {
        [[self logger] openLine];
    }];
}

- (void) stringFormatterCloseLine:(FLStringFormatter*) formatter {
    [self visitLoggersForOutput:^(id<FLStringFormatter> logger) {
        [[self logger] closeLine];
    }];
}

- (void) stringFormatterIndent:(FLStringFormatter*) formatter {
    [self visitLoggersForOutput:^(id<FLStringFormatter> logger) {
        [[self logger] indent:self.indentIntegrity];
    }];
}

- (void) stringFormatterOutdent:(FLStringFormatter*) formatter {
    [self visitLoggersForOutput:^(id<FLStringFormatter> logger) {
        [[self logger] outdent:self.indentIntegrity];
    }];
}

- (NSInteger) stringFormatterIndentLevel:(FLStringFormatter*) formatter {
    return [[self logger] indentLevel];
}

- (NSUInteger) stringFormatterLength:(FLStringFormatter*) formatter {
    return [[self logger] length];
}

- (void)stringFormatter:(FLStringFormatter*) formatter
appendContentsToStringFormatter:(id<FLStringFormatter>) stringFormatter {

    [self visitLoggersForOutput:^(id<FLStringFormatter> logger) {
        [stringFormatter appendString:[self logger]];
    }];
}

- (void) stringFormatter:(FLStringFormatter*) formatter
            appendString:(NSString*) string {

    [self visitLoggersForOutput:^(id<FLStringFormatter> logger) {
        [[self logger] appendString:string];
    }];

//    for(id logger in _loggers) {
//        [logger appendString:string];
//    }

}

- (void) stringFormatter:(FLStringFormatter*) formatter
  appendAttributedString:(NSAttributedString*) attributedString {
    [self visitLoggersForOutput:^(id<FLStringFormatter> logger) {
        [[self logger] appendString:attributedString];
    }];

}

- (NSString*) stringFormatterExportString:(FLStringFormatter*) formatter {
    return [[self logger] formattedString];
}

- (NSAttributedString*) stringFormatterExportAttributedString:(FLStringFormatter*) formatter {
    return [[self logger] formattedAttributedString];
}

- (void) logger:(id<FLStringFormatter>) logger logInBlock:(dispatch_block_t) block {
    @try {
        [[FLTestLoggingManager instance] pushLogger:logger];
        block();
    }
    @finally {
        [[FLTestLoggingManager instance] popLogger];
    }
}

- (void) appendTestCaseOutput:(FLTestCase*) testCase {
    if(!testCase.result.passed) {
        [self appendLine:@"Log Entries:"];
        [self indentLinesInBlock:^{
            NSArray* logEntries = testCase.result.logEntries;
            for(FLTestResultLogEntry* entry in logEntries) {
                [self appendLine:entry.line];
                if(entry.stackTrace) {
                    [self indentLinesInBlock:^{
                        [entry.stackTrace appendToStringFormatter:self];
                    }];
                }
            }
        }];
    }
}


@end
