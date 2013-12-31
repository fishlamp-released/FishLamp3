//
//  FLLogger.h
//  FLCore
//
//  Created by Mike Fullerton on 11/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"
#import "FLStringFormatter.h"

#define FLLogTypeNone       nil
#define FLLogTypeLog        @"com.fishlamp.log"
#define FLLogTypeError      @"com.fishlamp.error"
#define FLLogTypeException  @"com.fishlamp.exception"

@protocol FLLogSink;
@class FLLogger;
@class FLLogEntry;
@class FLStackTrace;

@interface FLLogger : FLStringFormatter<FLStringFormatterDelegate> {
@private
    NSMutableArray* _sinks;
    dispatch_queue_t _fifoQueue;
    NSMutableString* _line;
}

+ (id) logger;

- (void) pushLoggerSink:(id<FLLogSink>) sink;
- (void) addLoggerSink:(id<FLLogSink>) sink;
- (void) removeLoggerSink:(id<FLLogSink>) sink;

- (void) logEntry:(FLLogEntry*) entry;
- (void) logObject:(id) object;
- (void) logArrayOfLogEntries:(NSArray*) entryArray;

@end

@interface FLLogger (UglyImplementationMethods)
// for subclasses.
//- (void) dispatchBlock:(dispatch_block_t) block;

- (void) logString:(NSString*) string
           logType:(NSString*) logType
        stackTrace:(FLStackTrace*) stackTrace;

@end

#define FLLogToLogger(__LOGGER_, __TYPE__, __FORMAT__, ...) \
            [__LOGGER_ logString:FLStringWithFormatOrNil(__FORMAT__, ##__VA_ARGS__) logType:__TYPE__ stackTrace:FLCreateStackTrace(NO)];

