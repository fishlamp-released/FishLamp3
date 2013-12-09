/*
 
// based on Apple's Reachability.h
// this needs to be refactor - this is piece of poo

*/

#if 0
#import "FishLampMinimum.h"

#import "FishLampMinimum.h"
#import <SystemConfiguration/SystemConfiguration.h>


// use with NSNotificationCenter
extern NSString* const FLReachabilityDidChangeNotification;
extern NSString* const FLReachabilityNotificationObjectKey;

typedef enum {
	FLInternetReachability,
	FLHostReachability,
	FLAddressReachability,
	FLWifiReachability
} FLReachabilityType;

#define FLReachabilityDefaultBroadcastMask kSCNetworkReachabilityFlagsReachable

#define FLReachabilityErrorDomain @"FLReachabilityErrorDomain"

typedef enum {
	FLReachabilityErrorDomainCodeNoConnection		= -2000,
	FLReachabilityErrorDomainCodeHostNotReachable	= -2001
} FLReachabilityErrorDomainCode;

@protocol FLReachablityListener;

@interface FLReachability: NSObject {
@private
	SCNetworkReachabilityRef _reachabilityRef;
	NSString* _hostName;
	FLReachabilityType _type;
	SCNetworkReachabilityFlags _lastFlags;
	SCNetworkReachabilityFlags _broadcastMask;
}

- (id) initWithHostName:(NSString*) hostName;
- (id) initWithAddress:(const struct sockaddr_in*) address;
- (id) initWithInternetConnection;
- (id) initWithWiFi;

@property (readonly, assign, nonatomic) FLReachabilityType reachabilityType;

@property (readonly, retain, nonatomic) NSString* hostName;
@property (readonly, assign, nonatomic) SCNetworkReachabilityRef reachabilityRef;

@property (readonly, assign, nonatomic) BOOL isReachable;
@property (readonly, assign, nonatomic) BOOL connectionRequired;

@property (readonly, assign, nonatomic) SCNetworkReachabilityFlags currentReachabilityFlags;
@property (readonly, assign, nonatomic) SCNetworkReachabilityFlags broadcastMask; //defaults to FLReachabilityDefaultBroadcastMask

//Start listening for reachability notifications on the current run loop
- (BOOL) startNotifer;
- (void) stopNotifer;

+ (FLReachability*) defaultReachability;
+ (BOOL) isConnectedToNetwork; // checks default reachability

@end

#endif