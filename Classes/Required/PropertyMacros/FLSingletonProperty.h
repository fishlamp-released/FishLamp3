//
//  FLSingleton.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 9/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"

/// FLSingletonProperty is a macro for defining a singleton object.
/// @param __class The type of the class (for example MyClass). 
#define FLSingletonProperty(__class) + (__class*)instance; \
                                     + (void) createInstance; \
                                     + (void) releaseInstance; \
                                     + (BOOL) hasInstance

/// Synthesizes all the boilerplate for declaring a thread safe fast singleton
#define FLSynthesizeSingleton(__class) \
    static dispatch_once_t s_pred1##__class = 0; \
    static dispatch_once_t s_pred2##__class = 0; \
    static __class* s_instance##__class = nil; \
    + (__class*) instance { \
        dispatch_once(&s_pred1##__class, ^{ s_instance##__class = [[[self class] alloc] init]; s_pred2##__class = 0; }); \
        return s_instance##__class; \
        } \
	+ (void) createInstance { \
        [self instance]; \
    }   \
    + (void) releaseInstance { \
        dispatch_once(&s_pred2##__class, ^{ FLReleaseWithNil(s_instance##__class); s_pred1##__class = 0; }); \
        } \
    + (BOOL) hasInstance { \
        return s_instance##__class != nil; \
    }

