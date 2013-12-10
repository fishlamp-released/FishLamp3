//
//  NSError+FLStreamController.m
//  FLCore
//
//  Created by Mike Fullerton on 11/10/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSError+FLNetworkStream.h"

@implementation NSError (FLStreamController)

// TODO: make this better
// I snagged this from some sample apple code..
+ (NSError*) errorFromStreamError:(CFStreamError) streamError {
    // Convert a CFStreamError to a NSError.  This is less than ideal.  I only handle a 
    // limited number of error constant, and I can't use a switch statement because 
    // some of the kCFStreamErrorDomainXxx values are not a constant.  Wouldn't it be 
    // nice if there was a public API to do this mapping <rdar://problem/5845848> 
    // or a CFHost API that used CFError <rdar://problem/6016542>.

    NSString *      domainStr = nil;
    NSDictionary *  userInfo = nil;
    NSInteger       code = streamError.error;
    
    if (streamError.domain == kCFStreamErrorDomainPOSIX) {
        domainStr = NSPOSIXErrorDomain;
    }
    else if (streamError.domain == kCFStreamErrorDomainMacOSStatus) {
        domainStr = NSOSStatusErrorDomain;
    }
    else if (streamError.domain == kCFStreamErrorDomainNetServices) {
        domainStr = FLBridge(NSString*, kCFErrorDomainCFNetwork);
    }
    else if (streamError.domain == kCFStreamErrorDomainNetDB) {
        domainStr = FLBridge(NSString*, kCFErrorDomainCFNetwork);
        code = kCFHostErrorUnknown;
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:streamError.error], kCFGetAddrInfoFailureKey, nil];
    }
    else {
        // If it's something we don't understand, we just assume it comes from 
        // CFNetwork.
        domainStr = FLBridge(NSString*, kCFErrorDomainCFNetwork);
    }

    NSError* error = [NSError errorWithDomain:domainStr code:code userInfo:userInfo];
    FLAssertIsNotNilWithComment(error, nil);

    return error;
}
@end
