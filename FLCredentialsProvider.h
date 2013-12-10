//
//  FLCredentialsProvider.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/12/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FLAuthenticationCredentials;
@protocol FLAuthenticatedEntity;

@protocol FLCredentialsProvider <NSObject>
- (id<FLAuthenticationCredentials>) authenticationCredentials;
//- (void) updateCredentials:(id<FLAuthenticationCredentials>) authenticationCredentials;

- (id<FLAuthenticatedEntity>) authenticatedEntity;
- (void) updateEntity:(id<FLAuthenticatedEntity>) entity;
@end