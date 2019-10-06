//
//  FLLogEntry.h
//  FLCore
//
//  Created by Mike Fullerton on 11/1/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"

@class FLStackTrace;

@interface FLLogEntry : NSObject<NSCopying> {
@private
    NSString* _logString;
    NSString* _logType;
    NSString* _logName;
    uint32_t _logCount;
    NSTimeInterval _timestamp;
    FLStackTrace* _stackTrace;
    id _object;
} 

+ (id) logEntry;

@property (readwrite, strong, nonatomic) id object;
@property (readwrite, strong, nonatomic) NSString* logString;
@property (readwrite, strong, nonatomic) NSString* logType;
@property (readonly, strong, nonatomic) NSString* logName;
@property (readwrite, strong, nonatomic) FLStackTrace* stackTrace;
@property (readonly, assign, nonatomic) uint32_t logCount;
@property (readonly, assign, nonatomic) NSTimeInterval timestamp;

- (void) releaseToCache;

@end

@interface NSObject (FLLogging)
- (NSString*) moreDescriptionForLogging;
- (FLLogEntry*) logEntryForSelf;
@end

@interface NSError (FLLogging)
@end

@interface NSException (FLLogging)
@end
