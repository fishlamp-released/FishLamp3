//
//	FLLogger.h
//	FishLamp
//
//	Created by Mike Fullerton on 9/15/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampRequired.h"
#import "FishLampPropertyDeclaring.h"
#import "FLLogger.h"

@interface FLLogLogger : FLLogger
FLSingletonProperty(FLLogLogger);
@end

#define FLLogTypeTrace      @"com.fishlamp.trace"
#define FLLogTypeDebug      @"com.fishlamp.debug"


#define FLLogIndent(__BLOCK__) [[FLLogLogger instance] indentLinesInBlock:__BLOCK__]

#define FLLogFileLocation() \
			FLLog(@"%s, file: %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__)

#if DEBUG

    #define FLLog(FORMAT...)   \
            [[FLLogLogger instance] logString:[NSString stringWithFormat:FORMAT] \
                                      logType:FLLogTypeLog \
                                   stackTrace:FLCreateStackTrace(NO)];


    #define FLDebugLog(FORMAT...)   \
            [[FLLogLogger instance] logString:[NSString stringWithFormat:FORMAT] \
                                      logType:FLLogTypeDebug \
                                   stackTrace:FLCreateStackTrace(NO)];

#else

    #define FLLog(FORMAT...)   \
            [[FLLogLogger instance] logString:[NSString stringWithFormat:FORMAT] \
                                      logType:FLLogTypeLog \
                                   stackTrace:nil];

    #define FLDebugLog(...)

#endif

#define FLLogError(FORMAT...) \
            [[FLLogLogger instance] logString:[NSString stringWithFormat:FORMAT] \
                                      logType:FLLogTypeLog \
                                   stackTrace:FLCreateStackTrace(YES)];


#define FLLogIf(CONDITION, FORMAT...) \
            do { \
                if(CONDITION) { \
                    FLLog(FORMAT); \
                } \
            } \
            while(0)


#ifdef FLTrace
    #undef FLTrace
#endif

#define FLTrace(FORMAT...)
#define FLTraceIf(CONDITION, FORMAT...)

#ifndef FL_DIVERT_NSLOG
    #define FL_DIVERT_NSLOG 0
#endif

#if FL_DIVERT_NSLOG
    #define NSLog FLLog
#endif



