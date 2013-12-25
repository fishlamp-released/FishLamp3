//
//	FLProperties.h
//	FishLamp
//
//	Created by Mike Fullerton on 5/28/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FLCoreFlags.h"
#import "FLCompilerWarnings.h"
#import "FLObjc.h"

#import "FLSingletonProperty.h"
#import "FLAssociatedProperty.h"
#import "FLAtomicProperties.h"
#import "FLStructFlagsProperty.h"
#import "FLStaticMemberProperty.h"
#import "FLDefaultProperty.h"
#import "FLBitFlagsProperty.h"

#define FLSynthesizeDictionaryGetterProperty(__GETTER__, __TYPE__, __KEY__, __DICTIONARY__) \
    - (__TYPE__) __GETTER__ { \
        return [__DICTIONARY__ objectForKey:__KEY__]; \
    } 

#define FLSynthesizeDictionaryProperty(__GETTER__, __SETTER__, __TYPE__, __KEY__, __DICTIONARY__) \
    - (__TYPE__) __GETTER__ { \
        return [__DICTIONARY__ objectForKey:__KEY__]; \
    } \
    - (void) __SETTER__:(__TYPE__) object { \
        if(object) [__DICTIONARY__ setObject:object forKey:__KEY__]; \
        else [__DICTIONARY__ removeObjectForKey:__KEY__]; \
    }




