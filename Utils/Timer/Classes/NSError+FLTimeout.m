//
//  NSError+FLTimeout.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSError+FLTimeout.h"

@implementation NSError (FLTimeout)
+ (NSError*) timeoutError {
    return [NSError errorWithDomain:NSURLErrorDomain
                                   code:FLErrorCodeTimedOut
                   localizedDescription:NSLocalizedString(@"TimeOut Error", @"used in cancel error localized description")];
}

- (BOOL) isTimeoutError {
	return	FLStringsAreEqual(NSURLErrorDomain, self.domain) && 
			self.code == FLErrorCodeTimedOut; 
}
@end
