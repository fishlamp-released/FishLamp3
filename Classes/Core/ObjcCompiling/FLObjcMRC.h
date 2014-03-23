//
//  FLARCMacros.m
//  FLCore
//
//  Created by Mike Fullerton on 10/30/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if FL_MRC

#ifdef  __MRC_INCLUDE__
#error already included
#endif

#define __MRC_INCLUDE__ 1


#import <objc/runtime.h>

// object memory management
#define FLRetain(__OBJ__)   \
            [__OBJ__ retain]

#define FLRelease(__OBJ__) \
            [__OBJ__ release]

#define FLAutorelease(__OBJ__) \
            [__OBJ__ autorelease] 

#define FLAutoreleaseObject(__OBJ__) \
            [__OBJ__ autorelease];

NS_INLINE
void FLRetainObject(id object) {
    [object retain];
}


#define FLSuperDealloc() \
            [super dealloc]
            
#define FLBridge(__TO__, __FROM__) \
            ((__TO__) __FROM__)

#define FLBridgeTransfer(__TO__, __FROM__) \
            ((__TO__) __FROM__)

#define bridge_retain_(__TO__, __FROM__) \
            ((__TO__) [__FROM__ retain])

#define FLBridge(__TO__, __FROM__) \
            ((__TO__) __FROM__)

#define FLBridgeTransfer(__TO__, __FROM__) \
            ((__TO__) __FROM__)

#define FLBridgeRetain(__TO__, __FROM__) \
            ((__TO__) [__FROM__ retain])


// mrc utils

NS_INLINE
void FLManuallyRelease(id* obj) {
    if(obj && *obj) {
        [*obj release];
        *obj = nil;
    }
}

NS_INLINE
void _FLReleaseBlockWithNil(dispatch_block_t* block) {
    if(block && *block) {
        FLRelease(*block);
        *block = nil;
    }
}

#define FLReleaseBlockWithNil(b) \
            _FLReleaseBlockWithNil((dispatch_block_t*) &(b))

#define FLAutoreleasePoolOpen(__NAME__) \
    { \
        NSAutoreleasePool* __NAME__ = [[NSAutoreleasePool alloc] init]; \
        @try {

#define FLAutoreleasePoolClose(__NAME__) \
            [__NAME__ drain]; \
        } \
        @catch(id exception) { \
            [exception retain]; \
            [__NAME__ drain]; \
            [exception autorelease]; \
            @throw; \
        } \
    }

NS_INLINE
void FLSaveBlockForLater(dispatch_block_t* block) {
    if(block && *block) {
        *block = [[*block copy] autorelease];
    }
}

#define FLPrepareBlockForFutureUse(__BLOCK__) \
    FLSaveBlockForLater((dispatch_block_t*) &__BLOCK__)

#define FLRetainWithAutorelease(__OBJECT__) \
            FLAutorelease(FLRetain(__OBJECT__))

#define FLCopyWithAutorelease(__OBJECT__) \
            FLAutorelease([((id)__OBJECT__) copy])

#define FLMutableCopyWithAutorelease(__OBJECT__) \
            FLAutorelease([((id)__OBJECT__) mutableCopy])

#endif