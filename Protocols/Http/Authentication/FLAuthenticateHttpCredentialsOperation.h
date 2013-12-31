//
//  FLAuthenticateHttpCredentialsOperation.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/15/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAuthenticateHttpRequestOperation.h"

@class FLHttpRequest;
@protocol FLAuthenticationCredentials;

@interface FLAuthenticateHttpCredentialsOperation : FLAuthenticateHttpRequestOperation {
@private
    id<FLAuthenticationCredentials> _credentials;
}


+ (id) authenticateHttpCredentialsOperation:(id<FLAuthenticationCredentials>) credentials ;

+ (id) authenticateHttpCredentialsOperation:(id<FLAuthenticationCredentials>) credentials withHttpRequest:(FLHttpRequest*) request;

@end
