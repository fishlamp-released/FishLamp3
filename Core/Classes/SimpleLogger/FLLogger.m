//
//  FLLogger.m
//  FLCore
//
//  Created by Mike Fullerton on 11/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLLogger.h"
#import "FishLampRequired.h"
#import <objc/runtime.h>

#import "FLLogSink.h"
#import "FLLogEntry.h"

@interface FLLogger()
@property (readwrite, strong, nonatomic) NSMutableString* line;
@end

@implementation FLLogger

@synthesize line = _line;

- (id) init {
    self = [super init];
    if(self) {
        static int count = 0;
        char buffer[128];
        snprintf(buffer, 128, "com.fishlamp.logger%d", count++);
#if __MAC_10_8
        _fifoQueue = dispatch_queue_create(buffer, DISPATCH_QUEUE_SERIAL);
#else 
        _fifoQueue = dispatch_queue_create(buffer, nil);

#endif        
        _sinks = [[NSMutableArray alloc] init];

        _spinLock = OS_SPINLOCK_INIT;
    }
    
    return self;
}


+ (id) logger {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) dealloc {
    FLDispatchRelease(_fifoQueue);
#if FL_MRC
    [_line release];
    [_sinks release];
    [super dealloc];
#endif
}

- (void) dispatchBlock:(dispatch_block_t) block {
//    dispatch_sync(_fifoQueue, block);

//    @synchronized(self) {
//        block();
//    }

    @try {
        OSSpinLockLock(&_spinLock);
        block();
    }
    @finally {
        OSSpinLockUnlock(&_spinLock);
    }

}

- (void) pushLoggerSink:(id<FLLogSink>) sink {
    [self dispatchBlock: ^{
        [_sinks insertObject:sink atIndex:0];
    }];
}

- (void) addLoggerSink:(id<FLLogSink>) sink {
    [self dispatchBlock: ^{
        [_sinks addObject:sink];
    }];
}

- (void) removeLoggerSink:(id<FLLogSink>) sink {
    [self dispatchBlock: ^{
        [_sinks removeObject:sink];
    }];
}

- (void) sendEntryToSinks:(FLLogEntry*) entry {
    BOOL stop = NO;
    for(id<FLLogSink> sink in _sinks) {
        [sink logEntry:entry stopPropagating:&stop];
        if(stop) {
            break;
        }
    } 
    [entry releaseToCache];
}

- (void) updateLogSinkBehavior:(id<FLLogSinkBehavior>) behavior {
    [self dispatchBlock: ^{
        for(id<FLLogSink> sink in _sinks) {
            [sink updateLogSinkBehavior:behavior];
        }
    }];
}

- (void) logEntry:(FLLogEntry*) entry {
    [self dispatchBlock: ^{
        [self sendEntryToSinks:entry];
    }];
}

- (void) logArrayOfLogEntries:(NSArray*) entryArray {
    [self dispatchBlock: ^{
        for(FLLogEntry* entry in entryArray) {
            [self sendEntryToSinks:entry];
        }
    }];
}

- (void) closeCurrentLine {
    if(self.line) {
        FLLogEntry* entry = [FLLogEntry logEntry];
        entry.logString = self.line;
        entry.logType = FLLogTypeLog;
        [self sendEntryToSinks:entry];
        self.line = nil;
    }
}

- (void) logString:(NSString*) string
           logType:(NSString*) logType
        stackTrace:(FLStackTrace*) stackTrace {

    if(FLStringIsEmpty(string)) {
        return;
    }

#if DEBUG
    NSCAssert(![string isEqualToString:@"(null)"], @"got null string in logger");
    NSCAssert(string != nil, @"logger line is nil");
#endif

    [self dispatchBlock: ^{
    
        [self closeCurrentLine];
    
        FLLogEntry* entry = [FLLogEntry logEntry];
        entry.logString = string;
        entry.logType = logType;
        entry.stackTrace = stackTrace;
        [self sendEntryToSinks:entry];
    }];
}

- (void) stringFormatterAppendBlankLine:(FLStringFormatter*) formatter {
    [self dispatchBlock: ^{
        FLLogEntry* entry = [FLLogEntry logEntry];
        entry.logString = @"";
        entry.logType = FLLogTypeLog;
        [self sendEntryToSinks:entry];
    }];
}

- (void) stringFormatterOpenLine:(FLStringFormatter*) formatter {
    [self closeLine];
}

- (void) stringFormatterCloseLine:(FLStringFormatter*) formatter {
    if(self.line) {
        [self dispatchBlock: ^{
            [self closeCurrentLine];
        }];
    }
}

- (void) stringFormatter:(FLStringFormatter*) formatter
            appendString:(NSString*) string {
    [self dispatchBlock: ^{
        if(self.line) {
            [self.line appendString:string];
        }
        else {
            self.line = FLMutableCopyWithAutorelease(string);
        }
    }];
}

- (void) stringFormatter:(FLStringFormatter*) formatter
  appendAttributedString:(NSAttributedString*) attributedString {
    [self appendString:attributedString.string];
}

- (void) stringFormatterIndent:(FLStringFormatter*) formatter {
    [self dispatchBlock: ^{
        for(id<FLLogSink> sink in _sinks) {
            [sink indent:self.indentIntegrity];
        }
    }];
}

- (void) stringFormatterOutdent:(FLStringFormatter*) formatter {
    [self dispatchBlock: ^{
        for(id<FLLogSink> sink in _sinks) {
            [sink outdent:self.indentIntegrity];
        }
    }];
}

- (void) logObject:(id) object {
    [self dispatchBlock: ^{
        FLLogEntry* entry = [object logEntryForSelf];
        if(entry) {
            [self sendEntryToSinks:entry];
        }
    }];
}

- (NSUInteger) stringFormatterLength:(FLStringFormatter*) formatter {
    return 0;
}

- (void) didMoveToParent:(id) parent {
}

- (NSString*) stringFormatterExportString:(FLStringFormatter*) formatter {
    return nil;
}

- (NSAttributedString*) stringFormatterExportAttributedString:(FLStringFormatter*) formatter {
    return nil;
}

- (void)stringFormatter:(FLStringFormatter*) formatter
appendContentsToStringFormatter:(id<FLStringFormatter>) stringFormatter  {

}



//- (void) logException:(NSException*) exception :(NSString*) comment {
//
//    [self dispatchBlock: ^{
//        for(id<FLLogSink> sink in _sinks) {
//            [sink logger:self openEntryWithLogType:FLLogTypeException];
//            [sink stringFormatterOpenLine:self];
//            [sink logger:self appendException:exception];
//            if(FLStringIsNotEmpty(comment)) {
//                [sink stringFormatter:self appendString:comment];
//            }
//            [sink loggerCloseEntry:self];
//        }
//    }];
//
////    FLLogEntry* entry = [FLLogEntry logEntry];
////    entry.exception = exception;
////    
////    NSString* info = [NSString stringWithFormat:@"name: %@, reason: %@", exception.name, exception.reason];
////    
////    if(comment) {
////        comment = [NSString stringWithFormat:@"%@ (%@)", comment, info];
////    }
////    else {
////        comment = info;
////    }
////    
////    entry.logString = comment;
////    entry.stackTrace = [FLStackTrace stackTraceWithException:exception];
////
////    [self sendEntryToSinks:entry];
//}

//- (void) logException:(NSException*) exception {
//    [self logException:exception :nil];
//}

@end

//@implementation NSException (FLLogger)
//- (void) logExceptionToLogger:(FLLogger*) logger {
//    [logger logException:self];
//}
//@end
//
//
//@implementation FLErrorException (FLLogger)
//
//- (void) logExceptionToLogger:(FLLogger*) logger {
//    
//    NSError* error = self.error;
//    if(error) {
//        [logger logError:error];
//    }
//    else {
//        [super logExceptionToLogger:logger]; // really [super raiseAndLog]
//    }
//}
//
//@end
