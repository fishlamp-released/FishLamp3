//
//  FLAssociatedProperty.m
//  FishLampCore
//
//  Created by Mike Fullerton on 3/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAssociatedProperty.h"

//@implementation NSObject (FLAssociatedProperty)
//
//- (id) associatedObjectForKey:(id) key createBlock:(dispatch_block_t) createBlock {
//
//    __TYPE__ obj = (__TYPE__) objc_getAssociatedObject(self, __KEYNAME__(__GETTER__)); \
//        if(!obj) { \
//            @synchronized(self) { \
//                obj = (__TYPE__) objc_getAssociatedObject(self, __KEYNAME__(__GETTER__)); \
//                if(!obj) { \
//                    obj = __CREATER__; \
//                    objc_setAssociatedObject(self, __KEYNAME__(__GETTER__), obj, __ASSOCIATION_POLICY__); \
//                } \
//            } \
//        } \
//        return obj; \
//    }
//    
//}
//
//@end
