//
//  FLHttpOperationContext.m
//  FishLampConnect
//
//  Created by Mike Fullerton on 3/27/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpOperationContext.h"
#import "FLHttpRequest.h"
#import "FLStorageService.h"
#import "FLServiceList.h"
#import "FLAuthenticationCredentials.h"
#import "FLAuthenticateHttpRequestOperation.h"
#import "FLAuthenticatedEntity.h"

#import "FLAuthenticateHttpEntityOperation.h"
#import "FLAuthenticateHttpCredentialsOperation.h"

#import "FLUserDefaultsCredentialStorage.h"
#import "FLFifoDispatchQueue.h"

@interface FLHttpOperationContext ()
@property (readwrite, strong) FLServiceList* serviceList;
@property (readonly, strong) FLFifoDispatchQueue* authenticationQueue;
@property (readwrite, strong) id<FLAuthenticatedEntity> authenticatedEntity;
@property (readwrite, strong) id<FLCredentialsStorage> credentialsStorage;
@property (readwrite, strong) NSError* authenticationError;
@end

@implementation FLHttpOperationContext

@synthesize serviceList = _serviceList;
@synthesize authenticatedEntity = _authenticatedEntity;
@synthesize authenticationQueue = _authenticationQueue;
@synthesize authenticationDelegate = _authenticationDelegate;
@synthesize authenticationCredentials = _authenticationCredentials;
@synthesize credentialsStorage = _credentialsStorage;
@synthesize authenticationError = _authenticationError;

- (id) init {
    self = [super init];
    if(self) {
        _authenticationQueue = [[FLFifoDispatchQueue alloc] init];
        _serviceList = [[FLServiceList alloc] init];

   		self.credentialsStorage = [FLUserDefaultsCredentialStorage instance];
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_authenticationQueue release];
    [_authenticationError release];
    [_credentialsStorage release];
    [_authenticationCredentials release];
    [_authenticatedEntity release];
    [_serviceList release];
    [super dealloc];
}
#endif

+ (id) httpContext {
    return FLAutorelease([[[self class] alloc] init]);
}

- (BOOL) canAuthenticate {
    return self.authenticationCredentials && [self.authenticationCredentials canAuthenticate];
}

- (void) closeService {
    [self requestCancel];
}

//- (void) didChangeAuthenticationCredentials:(id<FLAuthenticationCredentials>) credentials {
//}

- (void) setAuthenticationCredentials:(id<FLAuthenticationCredentials>) credentials {
    [self.serviceList closeServices];
    FLSetObjectWithRetain(_authenticationCredentials, credentials);
    self.authenticatedEntity = nil;
    self.authenticationError = nil;

    [self saveCredentials];
}

- (BOOL) isAuthenticated {
    return [self.authenticatedEntity isAuthenticated];
}

- (id<FLHttpRequestAuthenticator>) httpRequestAuthenticator {
    return self;
}

- (void) authenticateHttpRequest:(FLHttpRequest*) request {

    FLThrowIfError(self.authenticationError);

    FLOperation* authenticator = nil;

    if(self.authenticatedEntity) {
        authenticator = [FLAuthenticateHttpEntityOperation authenticateHttpEntityOperation:self.authenticatedEntity withHttpRequest:request];
    }
    else if(self.authenticationCredentials) {
        authenticator = [FLAuthenticateHttpCredentialsOperation authenticateHttpCredentialsOperation:self.authenticationCredentials withHttpRequest:request];
    }

    FLAssertNotNil(authenticator);

    FLPromisedResult result = [self runSynchronously:authenticator];

    if([result isError]) {
        self.authenticationError = result;
        FLThrowError(result);
    }
}

- (void) willStartOperation:(id) operation {

    if([operation respondsToSelector:@selector(setAuthenticationDelegate:)]) {
        [operation setAuthenticationDelegate:self.authenticationDelegate];
        [operation setOperationStarter:self.authenticationQueue];
    }

    [operation addListener:self sendEventsOnMainThread:NO];
}

- (void) didRemoveOperation:(FLOperation*) operation {
    [operation removeListener:self];
}

- (FLPromise*) beginAuthenticating:(fl_completion_block_t) completion {

    return [self queueOperation:[FLAuthenticateHttpCredentialsOperation authenticateHttpCredentialsOperation:self.authenticationCredentials]
                     completion:completion];

}

- (void) authenticateHttpRequestOperation:(FLAuthenticateHttpRequestOperation*) operation
                    didAuthenticateEntity:(id<FLAuthenticatedEntity>) entity {
    self.authenticatedEntity = entity;

    [self saveCredentials];

    [self sendEvent:@selector(httpOperationContext:didAuthenticateUser:) withObject:self withObject:entity];
}

- (id<FLStorageService>) createStorageService {
    return [FLNoStorageService noStorageService];
}

- (void) saveCredentials {
    if(self.credentialsStorage) {
        [self.credentialsStorage setCredentialsForLastUser:self.authenticationCredentials];
    }
}

- (void) logoutEntity {
    [self requestCancel];

    id<FLAuthenticationCredentials> creds = self.authenticationCredentials;
    self.authenticationCredentials = [FLAuthenticationCredentials authenticationCredentials:creds.userName password:nil];

    [self saveCredentials];

    [self sendEvent:@selector(httpOperationContext:didLogoutUser:)
                      withObject:self
                      withObject:self.authenticationCredentials];

    [self closeService];
}

//- (id<FLAuthenticationCredentials>) loginPanelGetCredentials:(FLLoginPanel*) panel {
//    return self.authenticationCredentials;
//}
//
//- (void) loginPanel:(FLLoginPanel*) panel setCredentials:(id<FLAuthenticationCredentials>) credentials {
//    self.authenticationCredentials = credentials;
//}

- (void) cancelAuthentication {
    [self requestCancel];
}

- (BOOL) shouldSavePassword {
    return self.credentialsStorage.rememberPasswordSetting;
}

- (void) setShouldSavePassword:(BOOL) savePassword {
    self.credentialsStorage.rememberPasswordSetting = savePassword;
}


@end
