/*
 
	Base on FLReachability.m
*/

#if 0

#if DEBUG
#define FAKE_OFFLINE 0
#if FAKE_OFFLINE 
#warning FAKE_OFFLINE is enabled
#endif
#endif

NSString* const FLReachabilityDidChangeNotification = @"FLReachabilityDidChangeNotification";
NSString* const FLReachabilityNotificationObjectKey = @"FLReachabilityNotificationObjectKey";

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreFoundation/CoreFoundation.h>

#import "FLReachability.h"

#if DEBUG
#define kShouldPrintReachabilityFlags 1
static void PrintReachabilityFlags(SCNetworkReachabilityFlags	 flags, const char* comment)
{
#if kShouldPrintReachabilityFlags
	
	NSLog(@"FLReachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
			(flags & kSCNetworkReachabilityFlagsIsWWAN)				  ? 'W' : '-',
			(flags & kSCNetworkReachabilityFlagsReachable)			  ? 'R' : '-',
			
			(flags & kSCNetworkReachabilityFlagsTransientConnection) ? 't' : '-',
			(flags & kSCNetworkReachabilityFlagsConnectionRequired)	  ? 'c' : '-',
			(flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) ? 'C' : '-',
			(flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
			(flags & kSCNetworkReachabilityFlagsConnectionOnDemand)	  ? 'D' : '-',
			(flags & kSCNetworkReachabilityFlagsIsLocalAddress)		  ? 'l' : '-',
			(flags & kSCNetworkReachabilityFlagsIsDirect)			  ? 'd' : '-',
			comment
			);
#endif
}
#endif


//NSString* const FLReachableNetworkChangedNotification = @"FLReachableNetworkChangedNotification";

@interface FLReachability ()
@property (readwrite, retain, nonatomic) NSString* hostName;
@end

@implementation FLReachability

static FLReachability* s_default = nil;

@synthesize hostName = _hostName;
@synthesize broadcastMask = _broadcastMask;
@synthesize reachabilityRef = _reachabilityRef;
@synthesize reachabilityType = _type;

- (void) setDefaults
{
	_broadcastMask = FLReachabilityDefaultBroadcastMask;
	_lastFlags = self.currentReachabilityFlags;
}

- (id) initWithHostName:(NSString*) hostName
{
	if((self = [super init]))
	{
		NSRange range = [hostName rangeOfString:@"//"];
		if(range.length)
		{
			hostName = [hostName substringFromIndex:range.location + 2];
		}

//#if DEBUG		   
//		  FLLog(FLDebugReachability, @"Set reachability for host: %@", hostName);
//#endif		
//		  
		_reachabilityRef = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [hostName UTF8String]);
		if(_reachabilityRef)
		{
			
		}
		
		self.hostName = hostName;
		_type = FLHostReachability;
		
		[self setDefaults];
	}

	return self;
}

- (id) initWithAddress:(const struct sockaddr_in*) hostAddress
{
	if((self = [super init]))
	{
		_reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
		_type = FLAddressReachability;
		[self setDefaults];
		// TODO save address?
	}
	
	return self;
}

- (id) initWithInternetConnection
{
	if((self = [super init]))
	{
		struct sockaddr_in zeroAddress;
		bzero(&zeroAddress, sizeof(zeroAddress));
		zeroAddress.sin_len = sizeof(zeroAddress);
		zeroAddress.sin_family = AF_INET;
		_reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
		_type = FLInternetReachability;
		self.hostName = @"0.0.0.0";
		[self setDefaults];
	}
	
	return self;
}

- (id) initWithWiFi
{
	if((self = [super init]))
	{
		struct sockaddr_in localWifiAddress;
		bzero(&localWifiAddress, sizeof(localWifiAddress));
		localWifiAddress.sin_len = sizeof(localWifiAddress);
		localWifiAddress.sin_family = AF_INET;
	// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
		localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
		_reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&localWifiAddress);
		_type = FLWifiReachability;
		[self setDefaults];
	}
	
	return self;
}

- (void) dealloc
{
	[self stopNotifer];

	FLReleaseWithNil(_hostName);
	if(_reachabilityRef!= NULL)
	{
		CFRelease(_reachabilityRef);
		_reachabilityRef = nil;
	}
	FLSuperDealloc();
}

+ (void) initialize
{
	s_default = [[FLReachability alloc] initWithInternetConnection];
}

+ (FLReachability*) defaultReachability
{
	return s_default;
}

+ (BOOL) isConnectedToNetwork 
{ 
#if FAKE_OFFLINE	
	return NO;
#endif
	
	return [FLReachability defaultReachability].isReachable;
}

- (void) broadcastDidChangeMessage
{
	[[NSNotificationCenter defaultCenter] postNotification:
		[NSNotification notificationWithName:FLReachabilityDidChangeNotification object:nil userInfo:
			[NSDictionary dictionaryWithObject:self forKey:FLReachabilityNotificationObjectKey]]];
}

- (void) onReachabilityCallback
{
	SCNetworkReachabilityFlags newFlags = self.currentReachabilityFlags;

#if DEBUG
	PrintReachabilityFlags(newFlags, "new flags");
	PrintReachabilityFlags(_lastFlags, "previous flags");
#endif

	if(newFlags != _lastFlags)
	{
		if( FLTestBits(newFlags, _broadcastMask) !=
			FLTestBits(_lastFlags, _broadcastMask))
		{
			[self broadcastDidChangeMessage];
		}
	
		_lastFlags = newFlags;
	}
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
	FLAssertWithComment(info != NULL, @"info was NULL in ReachabilityCallback");
	FLAssertWithComment([(NSObject*) info isKindOfClass: [FLReachability class]], @"info was wrong class in ReachabilityCallback");

	FLReachability* noteObject = (FLReachability*) info;
	[noteObject onReachabilityCallback];
}

- (BOOL) startNotifer
{


	BOOL retVal = NO;
	SCNetworkReachabilityContext	context = {0, self, NULL, NULL, NULL};
	if(SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context))
	{
		if(SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetMain(), kCFRunLoopDefaultMode))
		{
			retVal = YES;
		}
	}
	return retVal;
}

- (void) stopNotifer
{
	if(_reachabilityRef!= NULL)
	{
		SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	}
}

- (BOOL) isReachable
{

	return	FLTestBits(self.currentReachabilityFlags, kSCNetworkReachabilityFlagsReachable);
}

- (BOOL) connectionRequired;
{
	return (self.currentReachabilityFlags & kSCNetworkReachabilityFlagsConnectionRequired);
}

- (SCNetworkReachabilityFlags) currentReachabilityFlags
{
	FLAssertWithComment(_reachabilityRef != NULL, @"currentReachabilityFlags called with NULL _reachabilityRef");
	SCNetworkReachabilityFlags flags = 0;
	if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags))
	{
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
	}
	else
	{
		FLLog(@"Warning SCNetworkReachabilityGetFlags returned false!");
	}
	
	
	return flags;
}

@end

/*
// Create zero addy	 
	struct sockaddr_in zeroAddress; 
	bzero(&zeroAddress, sizeof(zeroAddress)); 
	zeroAddress.sin_len = sizeof(zeroAddress); 
	zeroAddress.sin_family = AF_INET;

// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags; 
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	if (!didRetrieveFlags) 
	{ 
		NSLog(@"Error. Could not recover network reachability flags."); 
		return NO;
	}
 
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired; 
	
	return (isReachable && !needsConnection) ? YES : NO;
*/



/*
// exceedingly lame
#define mySCNetworkReachabilityFlagsConnectionOnDemand 1<<5

- (FLNetworkStatus) localWiFiStatusForFlags: (SCNetworkReachabilityFlags) flags
{
	PrintReachabilityFlags(flags, "localWiFiStatusForFlags");

	BOOL retVal = gtNetworkNotReachable;
	if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))
	{
		retVal = gtNetworkReachableViaWiFi; 
	}
	return retVal;
}

- (FLNetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags
{
#if DEBUG
	if(FLTestBoolEnvironmentVariable(FLNetworkNotReachable))
	{
		FLLog(@"Warning fake not reachable is enabled");
		return gtNetworkNotReachable;
	}
#endif

	PrintReachabilityFlags(flags, "networkStatusForFlags");
	if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
	{
		// if target host is not reachable
		return gtNetworkNotReachable;
	}

	FLNetworkStatus retVal = gtNetworkNotReachable;
	
	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
	{
		// if target host is reachable and no connection is required
		//	then we'll assume (for now) that your on Wi-Fi
		retVal = gtNetworkReachableViaWiFi;
	}
	
	
	if ((((flags & mySCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
		(flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
	{
			// ... and the connection is on-demand (or on-traffic) if the
			//	   calling application is using the CFSocketStream or higher APIs

			if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
			{
				// ... and no [user] intervention is needed
				retVal = gtNetworkReachableViaWiFi;
			}
		}
	
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
	{
		// ... but WWAN connections are OK if the calling application
		//	   is using the CFNetwork (CFSocketStream?) APIs.
		retVal = gtNetworkReachableViaWWAN;
	}
	return retVal;
}
*/
/*

+ (FLReachability*) reachabilityWithHostName: (NSString*) hostName
{
	FLReachability* retVal = FLAutorelease([[FLReachability alloc] init]);
	retVal.reachabilityRef = ;
	retVal.hostName = hostName;
	retVal.isWifiRef = NO;
	return retVal; 
}



+ (void) reachabilityWithAddress: (const struct sockaddr_in*) hostAddress	
	outReachability:(FLReachability**) outValue
{
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
	FLReachability* retVal = NULL;
	if(reachability!= NULL)
	{
		retVal= [[self alloc] init];
		if(retVal!= NULL)
		{
			retVal->_reachabilityRef = reachability;
			retVal->_isLocalWiFiRef = NO;
		}
	}
	*outValue = retVal; 
}

+ (void) reachabilityForInternetConnection: (FLReachability**) outValue
{
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	[self reachabilityWithAddress: &zeroAddress outReachability:outValue];
}


+ (void) reachabilityForLocalWiFi: (FLReachability**) outValue
{
	[super init];
	struct sockaddr_in localWifiAddress;
	bzero(&localWifiAddress, sizeof(localWifiAddress));
	localWifiAddress.sin_len = sizeof(localWifiAddress);
	localWifiAddress.sin_family = AF_INET;
	// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
	localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
	FLReachability* retVal = nil;
	[self reachabilityWithAddress: &localWifiAddress outReachability:&retVal];
	if(retVal!= NULL)
	{
		retVal->_isLocalWiFiRef = YES;
	}
	*outValue = retVal; 
}
*/

#endif
