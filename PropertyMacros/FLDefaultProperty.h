//
//  FLDefaultProperty.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 9/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"

/// Synthesizes all the boilerplate for declaring a thread safe fast singleton
#define FLSynthesizeDefaultProperty(__TYPE__, __NAME__) \
    + (__TYPE__) __NAME__ { \
        static __TYPE__ s_default = nil; \
        static dispatch_once_t s_predicate = 0; \
        dispatch_once(&s_predicate, ^{ s_default = [[[self class] alloc] init]; }); \
        return s_default; \
        }

