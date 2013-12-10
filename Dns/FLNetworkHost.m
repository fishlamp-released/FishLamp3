//
//  FLNetworkHost.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLNetworkHost.h"

#if IOS
    #import <CFNetwork/CFNetwork.h>
#else
    #import <CoreServices/CoreServices.h>
#endif

#import "FLCoreFoundation.h"
#include <netdb.h>

@interface FLNetworkHost ()

@property (readwrite, nonatomic, assign) CFHostRef hostRef;
@property (readwrite, nonatomic, strong) NSString* hostName;
@property (readwrite, nonatomic, strong) NSData* addressData;
@property (readwrite, nonatomic, strong) NSArray* resolvedAddresses;
@property (readwrite, nonatomic, strong) NSArray* resolvedAddressStrings;
@property (readwrite, nonatomic, strong) NSArray* resolvedHostNames;
@end

@implementation FLNetworkHost

@synthesize hostRef = _hostRef;
@synthesize hostName = _hostHame;
@synthesize addressData = _addressData;
@synthesize resolved = _resolved;
@synthesize resolvedAddresses = _resolvedAddresses;
@synthesize resolvedAddressStrings = _resolvedAddressStrings;
@synthesize resolvedHostNames = _resolvedHostNames;

- (id) initWithName:(NSString*) name {
    self = [super init];
    if(self) {
        FLAssertStringIsNotEmpty(name);
        _hostRef = CFHostCreateWithName(nil, FLBridge(CFStringRef, name));
        FLAssertNotNil(_hostRef);
        self.hostName = name;
    }
    
    return self;
}

- (id) initWithAddress:(NSData*) address {
    self = [super init];
    if(self) {
        _hostRef = CFHostCreateWithAddress(NULL, FLBridge(CFDataRef, address));
        FLAssertNotNil(_hostRef);
        self.addressData = address;
    }
    
    return self;
}

-  (id) initWithAddressString:(NSString*) addressString {
    self = [super init];
    if(self) {
        
        // Use a BSD-level routine to convert the address string into an address.  It's
        // important that we specificy AI_NUMERICHOST and AI_NUMERICSERV so that this routine 
        // just does numeric conversion; without that, if addressString was a DNS name, 
        // we would hit the network trying to resolve it, and do that synchronously.
        
        struct addrinfo *   result;
        struct addrinfo     template;
        memset(&template, 0, sizeof(template));
        template.ai_flags = AI_NUMERICHOST | AI_NUMERICSERV;
        int err = getaddrinfo([addressString UTF8String], NULL, &template, &result);

        NSData* data = nil;

        if (err == 0) {
            data = [NSData dataWithBytes:result->ai_addr length:result->ai_addrlen];
        }
        
        if(result) {
            freeaddrinfo(result);
        }
        
        if(data) {
            _hostRef = CFHostCreateWithAddress(NULL, FLBridge(CFDataRef, data));
        }
        
        FLAssertNotNil(_hostRef);
        
        self.addressData = data;
        
    }
    
    return self;
}

+ (FLNetworkHost*) networkHostWithName:(NSString*) name {
    return FLAutorelease([[FLNetworkHost alloc] initWithName:name]);
}

+ (FLNetworkHost*) networkHostWithAddress:(NSData*) data {
    return FLAutorelease([[FLNetworkHost alloc] initWithAddress:data]);
}

+ (FLNetworkHost*) networkHostWithAddressString:(NSString*) addressString {
    return FLAutorelease([[FLNetworkHost alloc] initWithAddressString:addressString]);
}

- (NSArray *) resolvedAddresses {
    FLAssertIsNotNilWithComment(_hostRef, nil);
    
    if(!_resolvedAddresses && _hostRef) {
        NSArray* result = FLBridge(id, CFHostGetAddressing(_hostRef, (Boolean*) &_resolved));
        if (_resolved ) {
            self.resolvedAddresses  = result;
        }
    }
    return _resolvedAddresses;
}

- (NSArray *) resolvedAddressStrings {
    FLAssertIsNotNilWithComment(_hostRef, nil);
    
    if(!_resolvedAddressStrings && _hostRef) {
    
            // Get the resolved addresses and convert each in turn to an address string.
        NSArray* addresses = self.resolvedAddresses;
        
        if (addresses != nil) {
            NSMutableArray*  result = [NSMutableArray array];
            for (NSData * address in addresses) {
                int         err;
                char        addrStr[NI_MAXHOST];

                FLAssertIsKindOfClass(address, NSData);

                err = getnameinfo((const struct sockaddr *) [address bytes], (socklen_t) [address length], addrStr, sizeof(addrStr), NULL, 0, NI_NUMERICHOST);
                if (err == 0) {
                    [result addObject:[NSString stringWithUTF8String:addrStr]];
                } else {
                    result = nil;
                    break;
                }
            }

            self.resolvedAddressStrings = result;
        }
        
    }
    
    return _resolvedAddressStrings;
}

- (NSArray *)resolvedHostNames {
    FLAssertIsNotNilWithComment(_hostRef, nil);
    
    if(!_resolvedHostNames && _hostRef) {
        NSArray* result = FLBridge(id, CFHostGetNames(_hostRef, (Boolean*) &_resolved));
        if (_resolved) {
            self.resolvedHostNames = result;
        }
    }
    return _resolvedHostNames;
}

- (CFHostInfoType) hostInfoType {
    return FLStringIsNotEmpty(self.hostName) ? kCFHostAddresses : kCFHostNames;
}

- (void) dealloc {

    if (_hostRef) {
        CFHostSetClient(_hostRef, nil, nil);
        CFRelease(_hostRef);
    }
    
    FLRelease(_resolvedHostNames);
    FLRelease(_resolvedAddressStrings);
    FLRelease(_resolvedAddresses);
    FLRelease(_hostHame);
    FLRelease(_addressData);
    FLSuperDealloc();
}

@end
