//
//  FLReachableNetwork.h
//  FishLamp
//
//  Created by Mike Fullerton on 5/9/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "FishLampMinimum.h"


// monitored reachability objects send this notification and themselves as the object when
// the monitored flags changes (in main runloop)

extern NSString* const FLReachabilityChangedNotification; 

@interface FLReachable : NSObject {
@private
	SCNetworkReachabilityRef _reachabilityRef;
	SCNetworkReachabilityContext _context;
	SCNetworkReachabilityFlags _monitoredFlags;
    SCNetworkReachabilityFlags _lastMonitoredFlags;
    BOOL _isMonitoring;
}

- (BOOL) testCurrentFlags:(SCNetworkReachabilityFlags) mask;
@property (readonly, assign, nonatomic) BOOL isReachable; // [self testCurrentFlags:kSCNetworkReachabilityFlagsReachable]

// optional
// interesting flags are flags that we care about that could change while monitoring is on.
@property (readwrite, assign, nonatomic) SCNetworkReachabilityFlags monitoredFlags; // kSCNetworkReachabilityFlagsReachable byDefault
@property (readwrite, assign, nonatomic) BOOL isMonitoring;
- (void) startMonitoring;
- (void) stopMonitoring;

// these are here for custom subclasses.
@property (readwrite, assign, nonatomic) SCNetworkReachabilityRef reachability;
@property (readwrite, assign, nonatomic) SCNetworkReachabilityContext context;
@property (readonly, assign, nonatomic) SCNetworkReachabilityFlags currentReachabilityFlags;

// this broadcasts change message 
- (void) monitoredFlagsDidChange:(SCNetworkReachabilityFlags) fromMonitoredFlags 
                toMonitoredFlags:(SCNetworkReachabilityFlags) toFlags;
@end

// FLReachableNetwork
// This monitors the general status of the network connection,
// which is why it's a singleton.

@interface FLReachableNetwork : FLReachable {
}
FLSingletonProperty(FLReachableNetwork);
@end

// FLServerReachability
// This monitors the status of specific server

@interface FLReachableHost : FLReachable {
@private
    NSString* _hostName;
}

@property (readonly, retain, nonatomic) NSString* hostName;

- (id) initWithHostName:(NSString*) host;

+ (FLReachableHost*) reachableHost:(NSString*) hostName;

@end
