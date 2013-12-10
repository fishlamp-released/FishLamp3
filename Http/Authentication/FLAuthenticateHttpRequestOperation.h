//
//  FLAuthenticateHttpRequestOperation.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/10/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLOperation.h"

@class FLHttpRequest;
@protocol FLAuthenticationCredentials;
@protocol FLAuthenticatedEntity;
@protocol FLAuthenticateHttpRequestOperationDelegate;
@protocol FLAuthenticationSession;

@interface FLAuthenticateHttpRequestOperation : FLOperation {
@private
    FLHttpRequest* _httpRequest;
    __unsafe_unretained id<FLAuthenticateHttpRequestOperationDelegate> _authenticationDelegate;
}

@property (readwrite, assign) id<FLAuthenticateHttpRequestOperationDelegate> authenticationDelegate;

- (id) initWithHttpRequest:(FLHttpRequest*) request;

// required override
- (id<FLAuthenticatedEntity>) authenticate;

// optional overrides
- (BOOL) sessionNeedsReauthentication:(id<FLAuthenticationSession>) session;

- (id<FLAuthenticatedEntity>) authenticateCredentials:(id<FLAuthenticationCredentials>) credentials;
- (void) authenticateHttpRequest:(FLHttpRequest*) httpRequest
         withAuthenticatedEntity:(id<FLAuthenticatedEntity>) authenticatedEntity;
@end

@protocol FLAuthenticateHttpRequestOperationDelegate <NSObject>

- (BOOL) authenticateHttpRequestOperation:(FLAuthenticateHttpRequestOperation*) operation
             sessionNeedsReauthentication:(id<FLAuthenticationSession>) session;

- (id<FLAuthenticatedEntity>) authenticateHttpRequestOperation:(FLAuthenticateHttpRequestOperation*) operation
                                              authenticateUser:(id<FLAuthenticationCredentials>) credentials;

- (void) authenticateHttpRequestOperation:(FLAuthenticateHttpRequestOperation*) operation
                  authenticateHttpRequest:(FLHttpRequest*) httpRequest
                  withAuthenticatedEntity:(id<FLAuthenticatedEntity>) entity;
@end


@protocol FLAuthenticateHttpRequestOperationListener <NSObject>
- (void) authenticateHttpRequestOperation:(FLAuthenticateHttpRequestOperation*) operation
                    didAuthenticateEntity:(id<FLAuthenticatedEntity>) entity;
@end