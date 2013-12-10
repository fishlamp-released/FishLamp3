//
//  FLAuthenticateHttpRequestOperation.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/10/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAuthenticateHttpRequestOperation.h"
#import "FLAuthenticationCredentials.h"
#import "FLHttpRequest.h"
#import "FLReachableNetwork.h"
#import "FLAuthenticationCredentials.h"
#import "FLAuthenticatedEntity.h"
#import "FLAuthenticationToken.h"

@interface FLAuthenticateHttpRequestOperation ()
// instance ctors
//- (id) initWithAuthenticationCredentials:(id<FLAuthenticationCredentials>) credentials;
//
//- (id) initWithAuthenticatedEntity:(id<FLAuthenticatedEntity>) entity;
//
//- (id) initWithHttpRequest:(FLHttpRequest*) request credentials:(id<FLAuthenticationCredentials>) credentials;
//
//- (id) initWithHttpRequest:(FLHttpRequest*) request entity:(id<FLAuthenticatedEntity>) entity;

@end

@implementation FLAuthenticateHttpRequestOperation

@synthesize authenticationDelegate = _authenticationDelegate;

- (id) initWithHttpRequest:(FLHttpRequest*) request {
	self = [super init];
	if(self) {
        _httpRequest = FLRetain(request);
        FLAssertNotNil(_httpRequest);
	}
	return self;

}

#if FL_MRC
- (void)dealloc {
    [_httpRequest release];
	[super dealloc];
}
#endif

- (BOOL) sessionNeedsReauthentication:(id<FLAuthenticationSession>) session {

	FLAssertIsNotNil(session);

#if TEST_CACHE_EXPIRE
	creds.authTokenLastUpdateTimeValue = creds.authTokenLastUpdateTimeValue - (_timeoutInterval*2);
#endif
    
    if(session.hasExpired) {
    
        if([FLReachableNetwork instance].isReachable) {
            FLTrace(@"Login expired, will reauthenticate %@", user.userLogin.userName);
            return YES;
        }
        else {
            // don't want to reauthenticate if we're offline.
            return NO;
        }
    }

    return [self.authenticationDelegate authenticateHttpRequestOperation:self sessionNeedsReauthentication:session];
}

- (id<FLAuthenticatedEntity>) authenticateCredentials:(id<FLAuthenticationCredentials>) credentials {

    id<FLAuthenticatedEntity> entity = [self.authenticationDelegate authenticateHttpRequestOperation:self
                                                                                    authenticateUser:credentials];

    [entity.session touchAuthenticationTimestamp];

    [self sendMessageToListeners:@selector(authenticateHttpRequestOperation:didAuthenticateEntity:) withObject:self withObject:entity];

    return entity;
}

- (void) authenticateHttpRequest:(FLHttpRequest*) httpRequest
         withAuthenticatedEntity:(id<FLAuthenticatedEntity>) authenticatedEntity {

    [self.authenticationDelegate authenticateHttpRequestOperation:self
                                          authenticateHttpRequest:httpRequest
                                          withAuthenticatedEntity:authenticatedEntity];

}

- (id<FLAuthenticatedEntity>) authenticate {
    return nil;
}

- (void) startOperation {

    id<FLAuthenticatedEntity> authenticatedEntity = [self authenticate];

    if(_httpRequest) {
        [self authenticateHttpRequest:_httpRequest withAuthenticatedEntity:authenticatedEntity];
    }

    [self setFinishedWithResult:authenticatedEntity];
}

- (void) didFinishWithResult:(id)result {
    [super didFinishWithResult:result];

    if([result isError]) {
        [_httpRequest setFinishedWithResult:result];
    }
}

@end
