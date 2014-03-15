//
//	FLLogger.h
//	FishLamp
//
//	Created by Mike Fullerton on 9/15/10.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampCore.h"
#import "FLLogger.h"
// WARNING: don't import anything here. This file is imported by FishLamp.  This is imported by everything.

#define FLLogTypeTrace      @"com.fishlamp.trace"
#define FLLogTypeDebug      @"com.fishlamp.debug"

#define FLLogRelease(__FORMAT__, ...)   \
            FLLogToLogger([FLLogLogger instance], FLLogTypeLog, __FORMAT__, ##__VA_ARGS__)

#define FLLogError(__FORMAT__, ...) \
            FLLogToLogger([FLLogLogger instance], FLLogTypeError, __FORMAT__, ##__VA_ARGS__)

#define FLLog(__FORMAT__, ...)   \
			FLLogToLogger([FLLogLogger instance], FLLogTypeLog, __FORMAT__, ##__VA_ARGS__)

#define FLLogIf(__CONDITION__, __FORMAT__, ...) \
			if(__CONDITION__) FLLogDebug(__FORMAT__, ##__VA_ARGS__)

#define FLLogIndent(__BLOCK__) [[FLLogLogger instance] indentLinesInBlock:__BLOCK__]

#define FLLogFileLocation() \
			FLLog(@"%s, file: %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__)

#if DEBUG

#define FLDebugLog(__FORMAT__, ...)   \
			FLLogToLogger([FLLogLogger instance], FLLogTypeDebug, __FORMAT__, ##__VA_ARGS__)

#else
#define FLDebugLog(...)
#endif

#ifdef FLTrace
#undef FLTrace
#endif

#define FLTrace(__FORMAT__, ...)
#define FLTraceIf(__CONDITION__, __FORMAT__, ...)

#ifndef FL_DIVERT_NSLOG
#define FL_DIVERT_NSLOG 0
#endif

#if FL_DIVERT_NSLOG
#define NSLog FLLog
#endif

@interface FLLogLogger : FLLogger
FLSingletonProperty(FLLogLogger);
@end


