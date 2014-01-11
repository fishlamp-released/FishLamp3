//
//  FLAuthenticateHttpEntityOperation.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/15/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLAuthenticateHttpRequestOperation.h"

@protocol FLAuthenticatedEntity;

@interface FLAuthenticateHttpEntityOperation : FLAuthenticateHttpRequestOperation {
@private
    id<FLAuthenticatedEntity> _entity;
}

+ (id) authenticateHttpEntityOperation:(id<FLAuthenticatedEntity>) entity withHttpRequest:(FLHttpRequest*) request;

+ (id) authenticateHttpEntityOperation:(id<FLAuthenticatedEntity>) entity;

@end
