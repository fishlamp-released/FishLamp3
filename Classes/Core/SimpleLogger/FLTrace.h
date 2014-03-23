//
//  FLTrace.h
//  FishLampCore
//
//  Created by Mike Fullerton on 4/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"

#import "FLLog.h"

#undef TRACE
#undef FLTrace
#undef FLTraceIf

#if DEBUG

#define FLTrace(FORMAT...) \
            [[FLLogLogger instance] logString:[NSString stringWithFormat:FORMAT] \
                                      logType:FLLogTypeTrace \
                                   stackTrace:FLCreateStackTrace(NO)];

#define FLTraceIf(CONDITION, FORMAT...) \
            if(CONDITION) FLTrace(FORMAT)

#define TRACE 1

#else

#define FLTrace(...)

#define FLTraceIf(...)

#endif
