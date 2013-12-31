//
//  FLLogEntry.m
//  FLCore
//
//  Created by Mike Fullerton on 11/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLLogEntry.h"
#import "FishLampCore.h"

@interface FLLogEntry () 
@property (readwrite, strong, nonatomic) NSString* logName;
@property (readwrite, assign, nonatomic) uint32_t logCount;
@property (readwrite, assign, nonatomic) NSTimeInterval timestamp;
- (void) updateTimestamp;
@end

@implementation FLLogEntry

@synthesize logString = _logString;
@synthesize logType = _logType;
@synthesize logName = _logName;
@synthesize stackTrace = _stackTrace;
@synthesize logCount = _logCount;
@synthesize timestamp = _timestamp;
@synthesize object = _object;

static NSMutableArray* s_cache = nil;

+ (void) initialize {
    if(!s_cache) {
        s_cache = [[NSMutableArray alloc] init];
    }
}

#if FL_MRC
- (void) dealloc {
    [_logString release];
    [_logType release];
    [_logName release];
    [_stackTrace release];
    [_object release];
    [super dealloc];
}
#endif

- (id) init {
    self = [super init];
    if(self) {
        [self updateTimestamp];
    }
    return self;
}

+ (id) logEntry {

    id entry = nil;
    @synchronized(self) {
        if(s_cache.count) {
            entry = FLRetainWithAutorelease([s_cache lastObject]);
            [s_cache removeLastObject];
        }
    }

    if(entry) {
        [entry updateTimestamp];
        return entry;
    }

    return FLAutorelease([[[self class] alloc] init]);
}

- (void) updateTimestamp {
    static uint32_t s_counter = 0;
    _logCount = ++s_counter;
    _timestamp = [NSDate timeIntervalSinceReferenceDate];
}

- (void) releaseToCache {
    self.logString = nil;
    self.logType = nil;
    self.logName = nil;
    self.stackTrace = nil;
    self.object = nil;
    _timestamp = 0;

    @synchronized(self) {
        [s_cache addObject:self];
    }
}

- (id)copyWithZone:(NSZone *)zone {
    FLLogEntry* entry = [[FLLogEntry alloc] init];
    entry.logString = FLCopyWithAutorelease(self.logString);
    entry.logType = FLCopyWithAutorelease(self.logType);
    entry.logName = FLCopyWithAutorelease(self.logName);
    entry.stackTrace = self.stackTrace;
    entry.logCount = self.logCount;
    entry.timestamp = self.timestamp;
    entry.object = FLCopyOrRetainObject(self.object);
    return entry;
}

- (NSString*) logString {
    return _logString ? _logString : @"";
}

- (NSString*) moreDescriptionForLogging {
    return nil;
}

@end

@implementation NSObject (FLLogging)
- (NSString*) moreDescriptionForLogging {
    return nil;
}
- (FLLogEntry*) logEntryForSelf {
    return nil;
}
@end

@implementation NSError (FLLogging)
- (FLLogEntry*) logEntryForSelf {
    FLLogEntry* entry = [FLLogEntry logEntry];
    entry.logType = FLLogTypeError;
    entry.logString = [self localizedDescription];
    entry.object = self;
    entry.stackTrace = self.stackTrace;
    return entry;
}
@end

@implementation NSException (FLLogging)
- (FLLogEntry*) logEntryForSelf {
    FLLogEntry* entry = [FLLogEntry logEntry];
    entry.logString = self.reason;
    entry.logType = FLLogTypeException;
    entry.object = self;
    entry.stackTrace = self.error.stackTrace;
    return entry;
}

- (NSString*) moreDescriptionForLogging {
    return self.name;
}

@end
