
//
//  FLOAuthRequestTokenHttpRequest.h
//  FishLamp
//
//  Created by Mike Fullerton on 6/1/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLHttpRequest.h"

@class FLOAuthApp;

@interface FLOAuthRequestTokenHttpRequest : FLHttpRequest {
@private 
	FLOAuthApp* _app;
    NSURL* _url;
}

- (id) initWithOAuthApp:(FLOAuthApp*) app;
+ (id) OAuthRequestTokenNetworkOperation:(FLOAuthApp*) app;

@end
