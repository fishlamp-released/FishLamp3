//
//  NSError+_FLNetworking_.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSError+FLNetworking.h"

@implementation NSError (FLNetworking)

- (BOOL) didLoseNetwork {
	return	FLStringsAreEqual(NSURLErrorDomain, self.domain) &&
			((self.code == NSURLErrorNetworkConnectionLost) || 
			(self.code == NSURLErrorNotConnectedToInternet));
}


- (BOOL) isNotConnectedToInternetError {
	return FLStringsAreEqual(NSURLErrorDomain, self.domain) && self.code == NSURLErrorNotConnectedToInternet;
}

@end
