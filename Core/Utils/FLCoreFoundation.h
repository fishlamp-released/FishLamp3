//
//  FLCoreFoundationUtils.h
//  FLCore
//
//  Created by Mike Fullerton on 10/30/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <CoreFoundation/CoreFoundation.h>

NS_INLINE 
void _FLReleaseCFRef(CFTypeRef* ref) {
    if(ref && *ref) {
        CFRelease(*ref);
        *ref = nil;
    }
}

#define FLReleaseCRef_(__REF__) _FLReleaseCFRef((CFTypeRef*) &(__REF__))

//#define FLBridgeTransferToCFString( __OBJ__) \
//            FLBridgeTransfer(CFStringRef, __OBJ__)
//
//#define FLBridgeToCFString(__OBJ__) \
//            FLBridge(CFStringRef, __OBJ__)
//
//#define FLBridgeRetainToCFString(__OBJ__) \
//            bridge_retain_(CFStringRef, __OBJ__)
            
            