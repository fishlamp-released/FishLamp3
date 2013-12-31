//
//  FLAuthenticationHandler.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/12/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FLAuthenticationCredentials;
@protocol FLAuthenticatedEntity;

typedef void (^FLAuthenticationHandlerCompletionBlock)(id result);

@protocol FLAuthenticationHandler <NSObject>

@property (readwrite, assign, nonatomic) BOOL shouldSavePassword;

- (id<FLAuthenticationCredentials>) authenticationCredentials;
- (void) setAuthenticationCredentials:(id<FLAuthenticationCredentials>) credentials;

- (id<FLAuthenticatedEntity>) authenticatedEntity;
- (void) setAuthenticatedEntity:(id<FLAuthenticatedEntity>) entity;

- (void) beginAuthenticating:(FLAuthenticationHandlerCompletionBlock) completion;

- (void) cancelAuthentication;

@end