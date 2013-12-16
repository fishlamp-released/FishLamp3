//
//  FLStaticMemberProperties.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 9/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"

#define FLReturnStaticObject(...) \
        static dispatch_once_t pred = 0; \
        static id s_static_object = nil; \
        dispatch_once(&pred, ^{ \
            s_static_object = __VA_ARGS__;  \
            FLRetainObject(s_static_object);  \
            }); \
        return s_static_object        