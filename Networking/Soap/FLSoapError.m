//
//	FLSoapError.m
//	FishLamp
//
//	Created by Mike Fullerton on 12/20/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLSoapError.h"
#import "FLErrorCodes.h"

@implementation NSError (FLSoapExtras) 

- (id) initWithSoapFault:(FLSoapFault11*) fault
{
	NSDictionary* userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
		fault, FLUnderlyingSoapFaultKey, 
        [NSString stringWithFormat:@"%@:%@", fault.faultcode, fault.faultstring], NSLocalizedDescriptionKey, nil];

	if((self = [self initWithDomain:FLNetworkErrorDomain
							   code:FLNetworkErrorCodeSoapFault
						   userInfo:userInfo]))
	{
	}
	
	FLReleaseWithNil(userInfo); 
	
	return self;
}

+ (id) errorWithSoapFault:(FLSoapFault11*) fault {
    return FLAutorelease([[[self class] alloc] initWithSoapFault:fault]);
}

- (FLSoapFault11*) soapFault {
	return self.userInfo ? [self.userInfo objectForKey:FLUnderlyingSoapFaultKey] : nil;
}


@end
