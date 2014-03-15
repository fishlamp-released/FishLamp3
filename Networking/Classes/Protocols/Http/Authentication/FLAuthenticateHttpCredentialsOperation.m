//
//  FLAuthenticateHttpCredentialsOperation.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/15/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAuthenticateHttpCredentialsOperation.h"
#import "FLAuthenticationCredentials.h"
#import "FLAuthenticatedEntity.h"

@implementation FLAuthenticateHttpCredentialsOperation

- (id) initWithAuthenticationCredentials:(id<FLAuthenticationCredentials>) credentials {
	self = [super init];
	if(self) {
        _credentials = [((id)credentials) copy];
        FLAssertNotNil(_credentials);
	}
	return self;
}


- (id) initWithHttpRequest:(FLHttpRequest*) request credentials:(id<FLAuthenticationCredentials>) credentials {
	self = [self initWithHttpRequest:request];
	if(self) {
        _credentials = [((id)credentials) copy];
        FLAssertNotNil(_credentials);
	}
	return self;

}

+ (id) authenticateHttpCredentialsOperation:(id<FLAuthenticationCredentials>) credentials {
    return FLAutorelease([[[self class] alloc] initWithAuthenticationCredentials:credentials]);
}

+ (id) authenticateHttpCredentialsOperation:(id<FLAuthenticationCredentials>) credentials withHttpRequest:(FLHttpRequest*) request {
    return FLAutorelease([[[self class] alloc] initWithHttpRequest:request credentials:credentials]);
}

#if FL_MRC
- (void)dealloc {
    [_credentials release];
	[super dealloc];
}
#endif

- (id<FLAuthenticatedEntity>) authenticate {
    FLAssertNotNil(_credentials);
    return [self authenticateCredentials:_credentials];
}

@end
