//
//  FLReachableNetwork.m
//  FishLamp
//
//  Created by Mike Fullerton on 5/9/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLReachableNetwork.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#if DEBUG
#define FAKE_AIRPLANE_MODE 0
#endif

NSString* const FLReachabilityChangedNotification = @"FLReachabilityChangedNotification";

// some experimental async handlers for status checking..

//- (void) testReachability:(void (^)(FLReachability* monitor, BOOL isReachable)) resultBlock;
//- (void) getCurrentFlags:(void (^)(FLReachability* monitor, SCNetworkReachabilityFlags flags)) resultBlock;
//- (void) testReachability:(void (^)(FLReachability* monitor, BOOL isReachable)) resultBlock
//{
//    resultBlock(self, FLTestBits(self.currentReachabilityFlags, self.interestingFlags));
//}
//
//- (void) getCurrentFlags:(void (^)(FLReachability* monitor, SCNetworkReachabilityFlags flags)) resultBlock
//{
//    resultBlock(self, self.currentReachabilityFlags);
//}


@interface FLReachable ()
@end

@implementation FLReachable 

@synthesize reachability = _reachabilityRef;
@synthesize context = _context;
@synthesize monitoredFlags = _monitoredFlags;
@synthesize isMonitoring = _isMonitoring;

- (id) init {
	if((self = [super init])) {
		_reachabilityRef = nil;
        memset(&_context, 0, sizeof(SCNetworkReachabilityContext));
        
        _context.info = FLBridge(void*,self);
        
        _monitoredFlags = kSCNetworkReachabilityFlagsReachable;
	}
	
	return self;
}

- (void) dealloc {
    [self stopMonitoring];
    self.reachability = nil;
    FLSuperDealloc();
}

- (void) setReachablility:(SCNetworkReachabilityRef) reachability {

    if(_reachabilityRef != NULL) {
		CFRelease(_reachabilityRef);
		_reachabilityRef = nil;
	}
    
    _reachabilityRef = reachability;
}

- (void) monitoredFlagsDidChange:(SCNetworkReachabilityFlags) oldFlags 
                toMonitoredFlags:(SCNetworkReachabilityFlags) newFlags {

    FLLog(@"%@ reachability status changed to %@",
                    [self description],
                    self.isReachable ? @"reachable" : @"unreachable");

    [[NSNotificationCenter defaultCenter] postNotification:
        [NSNotification notificationWithName:FLReachabilityChangedNotification object:self userInfo:nil]];
}


- (void) onReachabilityCallback:(SCNetworkReachabilityRef) target 
                          flags:(SCNetworkReachabilityFlags) flags {

    SCNetworkReachabilityFlags newFlags = FLTestBits(flags, self.monitoredFlags);
    if(newFlags != _lastMonitoredFlags) {
        SCNetworkReachabilityFlags lastFlags = _lastMonitoredFlags;
        _lastMonitoredFlags = newFlags;
        [self monitoredFlagsDidChange:lastFlags toMonitoredFlags:newFlags];
    }
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {
	[FLBridge(id, info) onReachabilityCallback:target flags:flags];
}

- (BOOL) testCurrentFlags:(SCNetworkReachabilityFlags) mask {
    return FLTestBits(self.currentReachabilityFlags, mask);
}

- (void) startMonitoring {
#if FAKE_AIRPLANE_MODE
    return;
#endif

	if(	!_isMonitoring &&
		SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &_context) && 
		SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetMain(), kCFRunLoopDefaultMode)) {
       
        _lastMonitoredFlags = FLTestBits(self.currentReachabilityFlags, self.monitoredFlags);
		_isMonitoring = YES;
	}
}

- (void) stopMonitoring
{
	if(_isMonitoring) {
		SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
        _isMonitoring = NO;
	}
}

- (void) setMonitoredFlags:(SCNetworkReachabilityFlags) flags
{
    BOOL isMonitoring = _isMonitoring;
    if(isMonitoring) {
        [self stopMonitoring];
    }

    _monitoredFlags = flags;

    if(isMonitoring) {
        [self startMonitoring];
    }
}


- (SCNetworkReachabilityFlags) currentReachabilityFlags
{
	FLAssertWithComment(_reachabilityRef != NULL, @"currentReachabilityFlags called with NULL _reachabilityRef");
	SCNetworkReachabilityFlags flags = 0;
	if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags)) {
#if DEBUG
	/*
		if(!flags)
		{
			FLLog(@"Warning SCNetworkReachabilityGetFlags returned 0 for host: %@ (check url for illegal prefix like http://)", self.hostName ? self.hostName : @"unknown");
		}
	 */
	 
#endif
	/*
		if(_isLocalWiFiRef)
		{
			retVal = [self localWiFiStatusForFlags: flags];
		}
		else
		{
			retVal = [self networkStatusForFlags: flags];
		}
	*/
	} else {
		FLLog(@"Warning SCNetworkReachabilityGetFlags returned false!");
	}
	
	
	return flags;
}

- (BOOL) isReachable {
    return FLTestBits(self.currentReachabilityFlags, kSCNetworkReachabilityFlagsReachable);
}


@end

@implementation FLReachableHost 

@synthesize hostName = _hostName;

- (id) initWithHostName:(NSString*) hostName{
    self = [super init];
    if(self) {
   		NSRange range = [hostName rangeOfString:@"//"];
		if(range.length) {
			hostName = [hostName substringFromIndex:range.location + 2];
		}
        
        FLSetObjectWithRetain(_hostName, hostName);

//#if DEBUG		   
//		  FLLog(FLDebugReachability, @"Set reachability for host: %@", hostName);
//#endif		
//		  
		self.reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [hostName UTF8String]);
    }
    
    return self;
}

+ (FLReachableHost*) reachableHost:(NSString*) hostName {
    return FLAutorelease([[FLReachableHost alloc] initWithHostName:hostName]);
}

- (void) dealloc {
    FLRelease(_hostName);
    FLSuperDealloc();
}

- (NSString*) description {
    return [NSString stringWithFormat:@"reachability for host: %@", self.hostName];
}

@end

@implementation FLReachableNetwork

FLSynthesizeSingleton(FLReachableNetwork);

- (id) init {
	if((self = [super init])) {
		struct sockaddr_in zeroAddress;
		bzero(&zeroAddress, sizeof(zeroAddress));
		zeroAddress.sin_len = sizeof(zeroAddress);
		zeroAddress.sin_family = AF_INET;
		self.reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    }
	
	return self;
}


@end
