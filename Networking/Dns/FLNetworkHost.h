//
//  FLNetworkHost.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#if __MAC_10_8
#import <CFNetwork/CFNetwork.h>
#endif

@interface FLNetworkHost : NSObject {
@private
    CFHostRef _hostRef;
    NSString* _hostHame;
    NSData* _addressData;
    BOOL _resolved;
    
    NSArray* _resolvedAddresses;
    NSArray* _resolvedAddressStrings;
    NSArray* _resolvedHostNames;
}

@property (readonly, nonatomic, assign) CFHostRef hostRef;

@property (readwrite, nonatomic, assign, getter=isResolved) BOOL resolved;
@property (readonly, nonatomic, strong) NSString* hostName;

@property (readonly, nonatomic, strong) NSArray* resolvedAddresses;
@property (readonly, nonatomic, strong) NSArray* resolvedAddressStrings;
@property (readonly, nonatomic, strong) NSArray* resolvedHostNames;

@property (readonly, nonatomic, assign) CFHostInfoType hostInfoType;

- (id) initWithName:(NSString*) name;
- (id) initWithAddress:(NSData*) address;
- (id) initWithAddressString:(NSString*) addressString;

+ (FLNetworkHost*) networkHostWithName:(NSString*) name;
+ (FLNetworkHost*) networkHostWithAddress:(NSData*) data;
+ (FLNetworkHost*) networkHostWithAddressString:(NSString*) addressString;

@end
