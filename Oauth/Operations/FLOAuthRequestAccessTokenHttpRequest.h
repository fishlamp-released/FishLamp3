//
//  FLOAuthRequestAccessTokenHttpRequest.h
//  FishLamp
//
//  Created by Mike Fullerton on 6/1/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

#import "FLHttpRequest.h"
#import "FLOAuthAuthencationData.h"
#import "FLOAuthApp.h"

@interface FLOAuthRequestAccessTokenHttpRequest : FLHttpRequest {
@private
	FLOAuthAuthencationData* _authData;
	FLOAuthApp* _app;
    NSURL* _url;
}

- (id) initWithOAuthApp:(FLOAuthApp*) app authData:(FLOAuthAuthencationData*) data;
+ (FLOAuthRequestAccessTokenHttpRequest*) OAuthRequestAccessTokenNetworkOperation:(FLOAuthApp*) app authData:(FLOAuthAuthencationData*) data;

@end
