//
//  FLAuthenticationToken.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/15/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAuthenticationToken.h"

@interface FLAuthenticationToken ()
@property (readwrite, assign, nonatomic) NSTimeInterval authTokenLastUpdateTime;
@property (readwrite, assign, nonatomic) NSTimeInterval lastAuthenticationTimestamp;
- (void) resetAuthenticationTimestamp;
- (void) touchAuthenticationTimestamp;

@end

@implementation FLAuthenticationToken

@synthesize authTokenLastUpdateTime = _authTokenLastUpdateTime;
@synthesize token = _token;
@synthesize lastAuthenticationTimestamp = _lastAuthenticationTimestamp;
@synthesize timeoutInterval = _timeoutInterval;

- (id) initWithAutheticationToken:(NSString*) token {
	self = [super init];
	if(self) {
        _timeoutInterval = 60 * 60;
        _token = [token copy];
	}
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_token release];
	[super dealloc];
}
#endif

+ (id) authenticationToken:(NSString*) authenticationToken {
    return FLAutorelease([[[self class] alloc] initWithAutheticationToken:authenticationToken]);
}

- (void) touchAuthenticationTimestamp {
    _lastAuthenticationTimestamp = [NSDate timeIntervalSinceReferenceDate];
}

- (void) resetAuthenticationTimestamp {
	_lastAuthenticationTimestamp = 0;
}

- (BOOL) hasExpired {
    return ([NSDate timeIntervalSinceReferenceDate] - _lastAuthenticationTimestamp) > _timeoutInterval;
}

- (id) copyWithZone:(NSZone *)zone {
    FLAuthenticationToken* copy = [[[self class] alloc] initWithAutheticationToken:self.token];
    copy.authTokenLastUpdateTime  = self.authTokenLastUpdateTime;
    copy.lastAuthenticationTimestamp = self.lastAuthenticationTimestamp;
    copy.timeoutInterval = self.timeoutInterval;
    return copy;
}

//- (id<FLAuthenticationSession>) authenticatedSessionWithUpdatedTimestamp {
//
//    FLAuthenticationToken* session = [self copy];
//    [session touchAuthenticationTimestamp];
//
//    return session;
//}

@end
