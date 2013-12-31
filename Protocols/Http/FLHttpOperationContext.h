//
//  FLHttpOperationContext.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOperationContext.h"
#import "FLHttpRequest.h"
#import "FLAuthenticationCredentials.h"
#import "FLAuthenticationHandler.h"

@protocol FLStorageService;
@protocol FLAuthenticationCredentials;
@protocol FLAuthenticateHttpRequestOperationDelegate;
@protocol FLAuthenticatedEntity;
@protocol FLCredentialsStorage;

@class FLServiceList;

@interface FLHttpOperationContext : FLOperationContext<FLHttpRequestAuthenticator, FLAuthenticationHandler> {
@private
    id<FLStorageService> _storageService;
    id<FLAuthenticatedEntity> _authenticatedEntity;
    id<FLAuthenticationCredentials> _authenticationCredentials;
    id<FLCredentialsStorage> _credentialsStorage;

    FLFifoAsyncQueue* _authenticationQueue;
    FLServiceList* _serviceList;

    NSError* _authenticationError;

    __unsafe_unretained id<FLAuthenticateHttpRequestOperationDelegate> _authenticationDelegate;
}

@property (readonly, strong) id<FLCredentialsStorage> credentialsStorage;

@property (readwrite, assign) id<FLAuthenticateHttpRequestOperationDelegate> authenticationDelegate;

@property (readwrite, strong, nonatomic) id<FLAuthenticationCredentials> authenticationCredentials;

@property (readonly, strong) id<FLAuthenticatedEntity> authenticatedEntity;

// getters
@property (readonly, assign, nonatomic) BOOL isAuthenticated;

@property (readonly, strong) id<FLStorageService> storageService;

- (FLPromise*) beginAuthenticating:(fl_completion_block_t) completion;

- (void) logoutEntity;

@end

@interface FLHttpOperationContext (OptionalOverrides)

/// @return FLDatabaseStorageService by default
- (id<FLStorageService>) createStorageService;

- (void) prepareAuthenticatedOperation:(id) operation;

@end

@protocol FLHttpOperationContextListener <NSObject>

- (void) httpOperationContext:(FLHttpOperationContext*) context
          didAuthenticateUser:(id<FLAuthenticatedEntity>) userLogin;

- (void) httpOperationContext:(FLHttpOperationContext*) context
                didLogoutUser:(id<FLAuthenticationCredentials>) userLogin;

- (void) httpOperationContextDidClose:(FLHttpOperationContext*) context;

- (void) httpOperationContextDidOpen:(FLHttpOperationContext*) context;
@end

