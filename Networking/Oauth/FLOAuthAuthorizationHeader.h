//
//  FLOAuthAuthorizationHeader.h
//  FishLamp
//
//  Created by Mike Fullerton on 5/19/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

#import "FLOAuthApp.h"
#import "FLOAuthEnums.h"
#import "FLHttpRequest.h"

@interface FLOAuthAuthorizationHeader : NSObject {
@private
	NSMutableDictionary* _parameters;
}

+ (FLOAuthAuthorizationHeader*) authorizationHeader;

// add/set parameters in any order. They'll be sorted when added to the request
- (void) setParameter:(NSString*) parameter
                value:(NSString*) unencodedURLValue;

@end

@interface FLHttpRequest (OAuth)
- (void) setOAuthAuthorizationHeader:(FLOAuthAuthorizationHeader*) signature
                         consumerKey:(NSString*) consumerKey
                              secret:(NSString*) secret;
@end