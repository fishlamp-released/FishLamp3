//
//  FLAssociatedProperty.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 9/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"

#import <objc/runtime.h>

// easier to deal with these than the OBC_ versions
typedef enum {
    FLAssociationPolicyAssignNonatomic    = OBJC_ASSOCIATION_ASSIGN,
    FLAssociationPolicyRetainNonatomic    = OBJC_ASSOCIATION_RETAIN_NONATOMIC,
    FLAssociationPolicyRetainAtomic       = OBJC_ASSOCIATION_RETAIN,
    FLAssociationPolicyCopyNonatomic      = OBJC_ASSOCIATION_COPY_NONATOMIC,
    FLAssociationPolicyCopyAtomic         = OBJC_ASSOCIATION_COPY
} FLAssociationPolicy;

#define FLSynthesizeAssociatedObjectKey(__NAME__) \
            static void * const __NAME__ = (void*)&__NAME__ 

#define __KEYNAME__(__NAME__) s_##__NAME__##Key

#define FLSynthesizeAssociatedProperty(FLAssociationPolicy, __GETTER__, __SETTER__, __TYPE__) \
    FLSynthesizeAssociatedObjectKey(__KEYNAME__(__GETTER__)); \
    \
    - (void) __SETTER__:(__TYPE__) obj { \
        objc_setAssociatedObject(self, __KEYNAME__(__GETTER__), obj, FLAssociationPolicy); \
    } \
    - (__TYPE__) __GETTER__ { \
        return (__TYPE__) objc_getAssociatedObject(self, __KEYNAME__(__GETTER__)); \
    }

#define FLSynthesizeAssociatedPropertyWithLazyGetter_(FLAssociationPolicy, __GETTER__, __SETTER__, __TYPE__, __CREATER__) \
    FLSynthesizeAssociatedObjectKey(__KEYNAME__(__GETTER__)); \
    - (void) __SETTER__:(__TYPE__) obj { \
        objc_setAssociatedObject(self, __KEYNAME__(__GETTER__), obj, FLAssociationPolicy); \
    } \
    - (__TYPE__) __GETTER__ { \
        __TYPE__ obj = (__TYPE__) objc_getAssociatedObject(self, __KEYNAME__(__GETTER__)); \
        if(!obj) { \
            @synchronized(self) { \
                obj = (__TYPE__) objc_getAssociatedObject(self, __KEYNAME__(__GETTER__)); \
                if(!obj) { \
                    obj = __CREATER__; \
                    objc_setAssociatedObject(self, __KEYNAME__(__GETTER__), obj, FLAssociationPolicy); \
                } \
            } \
        } \
        return obj; \
    }


#define FLSynthesizeAssociatedNumberProperty(FLAssociationPolicy, __GETTER__, __SETTER__, __TYPE__, __INIT__, __VALUE__) \
    FLSynthesizeAssociatedObjectKey(__KEYNAME__(__GETTER__)); \
    \
    - (void) __SETTER__:(__TYPE__) number { \
        objc_setAssociatedObject(self, __KEYNAME__(__GETTER__), [NSNumber __INIT__:number], FLAssociationPolicy); \
    } \
    - (__TYPE__) __GETTER__ { \
        NSNumber* number = (NSNumber*) objc_getAssociatedObject(self, __KEYNAME__(__GETTER__)); \
        return [number __VALUE__]; \
    }
      
#define FLSynthesizeAssociatedBOOLProperty(__GETTER__, __SETTER__) \
            FLSynthesizeAssociatedNumberProperty(OBJC_ASSOCIATION_RETAIN, __GETTER__, __SETTER__, BOOL, numberWithBool, boolValue)
            
            
#define FLSynthesizeAssociatedSelectorProperty(__GETTER__, __SETTER__) \
    FLSynthesizeAssociatedObjectKey(__KEYNAME__(__GETTER__)); \
    - (void) __SETTER__:(SEL) selector { \
        objc_setAssociatedObject(self, __KEYNAME__(__GETTER__), [NSValue valueWithPointer:(const void*) selector], FLAssociationPolicyRetainNonatomic); \
    } \
    - (SEL) __GETTER__ { \
        return (SEL) [objc_getAssociatedObject(self, __KEYNAME__(__GETTER__)) pointerValue]; \
    }      