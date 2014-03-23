//
//  FLAuthenticateHttpEntityOperation.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/15/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAuthenticateHttpEntityOperation.h"
#import "FLAuthenticationCredentials.h"
#import "FLAuthenticatedEntity.h"

@implementation FLAuthenticateHttpEntityOperation

- (id) initWithAuthenticatedEntity:(id<FLAuthenticatedEntity>) entity {
	self = [super init];
	if(self) {
        _entity = [((id)entity) copy];
        FLAssertNotNil(_entity);
	}
	return self;
}

- (id) initWithHttpRequest:(FLHttpRequest*) request entity:(id<FLAuthenticatedEntity>) entity {
	self = [super initWithHttpRequest:request];
	if(self) {
        _entity = [((id)entity) copy];
        FLAssertNotNil(_entity);
	}
	return self;
}

+ (id) authenticateHttpEntityOperation:(id<FLAuthenticatedEntity>) entity
                   withHttpRequest:(FLHttpRequest*) request {

    return FLAutorelease([[[self class] alloc] initWithHttpRequest:request entity:entity]);
}

+ (id) authenticateHttpEntityOperation:(id<FLAuthenticatedEntity>) entity {
    return FLAutorelease([[[self class] alloc] initWithAuthenticatedEntity:entity]);
}

#if FL_MRC
- (void)dealloc {
    [_entity release];
	[super dealloc];
}
#endif

- (id<FLAuthenticatedEntity>) authenticate {
    FLAssertNotNil(_entity);

    id<FLAuthenticationCredentials> credentials = _entity.authenticationCredentials;
    id<FLAuthenticatedEntity> outEntity = nil;

    if(!_entity.session || [self sessionNeedsReauthentication:_entity.session]) {

        outEntity = [self authenticateCredentials:credentials];
    }
    else {
        outEntity = FLRetainWithAutorelease(_entity);
    }

    return outEntity;
}
@end
