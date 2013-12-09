//
//  FLAuthenticatedEntity.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/15/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"

@protocol FLAuthenticationCredentials;
@protocol FLAuthenticationSession;

/*!
 *  An authenticated entity, e.g. a user, *has* credentials.
 */
@protocol FLAuthenticatedEntity <NSObject, NSCopying>
@property (readwrite, copy) id<FLAuthenticationSession> session;
@property (readwrite, copy) id<FLAuthenticationCredentials> authenticationCredentials;

@property (readonly, assign) BOOL isAuthenticated;
- (void) setUnathenticated;

- (NSString*) userName;

@end
