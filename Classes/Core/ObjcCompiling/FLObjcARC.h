//
//  FLARCMacros.h
//  FLCore
//
//  Created by Mike Fullerton on 10/30/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if FL_ARC

#define FLRetain(__OBJ__) __OBJ__

#define FLRetainObject(__OBJ__) 

#define FLRelease(__OBJ__) 

#define FLAutorelease(__OBJ__) __OBJ__

#define FLAutoreleaseObject(__OBJ__)    

#define FLSuperDealloc()

#define FLBridge(__TO__, __FROM__) \
            ((__bridge __TO__) __FROM__)
            
#define FLBridgeTransfer(__TO__, __FROM__) \
            ((__bridge_transfer __TO__) __FROM__)

#define FLBridgeRetain(__TO__, __FROM__) \
            ((__bridge_retained __TO__) __FROM__)


#define FLReleaseBlockWithNil(__BLOCK__) __BLOCK__ = nil

NS_INLINE
void FLManuallyRelease(id* obj) {
    if(obj && *obj) {
        CFRelease((__bridge_retained CFTypeRef) (*obj));
        *obj = nil;
    }
}

#define FLAutoreleasePoolOpen(__NAME__) 

#define FLAutoreleasePoolClose(__NAME__) 

#define FLPrepareBlockForFutureUse(__BLOCK__)

#define FLRetainWithAutorelease(__OBJECT__) \
            __OBJECT__

#define FLCopyWithAutorelease(__OBJECT__) \
            [((id)__OBJECT__) copy]

#define FLMutableCopyWithAutorelease(__OBJECT__) \
            [((id)__OBJECT__) mutableCopy]

#endif


