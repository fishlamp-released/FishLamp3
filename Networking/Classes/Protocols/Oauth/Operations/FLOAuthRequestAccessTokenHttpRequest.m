//
//  FLOAuthRequestAccessTokenHttpRequest.m
//  FishLamp
//
//  Created by Mike Fullerton on 6/1/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOAuthRequestAccessTokenHttpRequest.h"
#import "FLOAuthAuthorizationHeader.h"
#import "NSString+URL.h"
#import "FLOAuthSession.h"
#import "FLUrlParameterParser.h"

#import "FLHttpResponse.h"


@implementation FLOAuthRequestAccessTokenHttpRequest

#if DEBUG
- (void) testMe
{
//	FLOAuthAuthorizationHeader* oauthHeader = [FLOAuthAuthorizationHeader OAuthSignature:@"POST" url:[NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"]];
//
//	[oauthHeader addParameter:kFLOAuthHeaderConsumerKey value:@"GDdmIQH6jhtmLUypg82g"];
//	[oauthHeader addParameter:kFLOAuthHeaderNonce value:@"9zWH6qe0qG7Lc1telCn7FhUbLyVdjEaL3MO5uHxn8"];
//	[oauthHeader addParameter:kFLOAuthHeaderTimestamp value:@"1272323047"];
//	[oauthHeader addParameter:kFLOAuthHeaderSignatureMethod value:kFLOAuthSignatureMethodHMAC_SHA1];
//	[oauthHeader addParameter:kFLOAuthHeaderVersion value:FLOAuthVersion];
//	
//	[oauthHeader addParameter:kFLOAuthHeaderToken value:@"8ldIZyxQeVrFZXFOZH5tAwj6vzJYuLQpl0WUEYtWc"];
//	[oauthHeader addParameter:@"oauth_verifier" value:@"pDNg57prOHapMbhv25RNf75lVRd6JDsni1AJJIDYoTY"];
//	
//	NSString* baseUrlString = [oauthHeader computeBaseURL];
//	
//	FLDebugCompareStrings(baseUrlString,
//		@"POST&https%3A%2F%2Fapi.twitter.com%2Foauth%2Faccess_token&oauth_consumer_key%3DGDdmIQH6jhtmLUypg82g%26oauth_nonce%3D9zWH6qe0qG7Lc1telCn7FhUbLyVdjEaL3MO5uHxn8%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1272323047%26oauth_token%3D8ldIZyxQeVrFZXFOZH5tAwj6vzJYuLQpl0WUEYtWc%26oauth_verifier%3DpDNg57prOHapMbhv25RNf75lVRd6JDsni1AJJIDYoTY%26oauth_version%3D1.0");
//    
//
//	NSString* key = [oauthHeader buildHMAC_SHA1Signature:[NSString stringWithFormat:@"%@&%@", 
//		@"MCD8BKwGdgPHvAuvgvz4EQpqDAtx89grbuNMRd7Eh98", // consumer secret
//		@"x6qpRnlEmW9JbQn4PQVVeVG8ZLPEx6A0TOebgwcuA"]]; // oauth_token_secret
//
//	FLDebugCompareStrings(@"PUw/dHA4fnlJYM6RhXk5IU/0fCc=", key);
//
//	[oauthHeader addParameter:kFLOAuthHeaderSignature value:key];
//
//	NSString* authHeader = [oauthHeader buildAuthorizationHeader];
//	
//	FLDebugCompareHeaders([authHeader substringFromIndex:6],
//	@"oauth_nonce=\"9zWH6qe0qG7Lc1telCn7FhUbLyVdjEaL3MO5uHxn8\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1272323047\", oauth_consumer_key=\"GDdmIQH6jhtmLUypg82g\", oauth_token=\"8ldIZyxQeVrFZXFOZH5tAwj6vzJYuLQpl0WUEYtWc\", oauth_verifier=\"pDNg57prOHapMbhv25RNf75lVRd6JDsni1AJJIDYoTY\", oauth_signature=\"PUw%2FdHA4fnlJYM6RhXk5IU%2F0fCc%3D\", oauth_version=\"1.0\"");

}
#endif

- (id) initWithOAuthApp:(FLOAuthApp*) app authData:(FLOAuthAuthencationData*) data {
    self = [super init];
	if(self) {
		_url = [[NSURL alloc] initWithString:app.accessTokenUrl];
        _app = FLRetain(app);
		_authData = FLRetain(data);
	}
	
	return self;
}

+ (FLOAuthRequestAccessTokenHttpRequest*) OAuthRequestAccessTokenNetworkOperation:(FLOAuthApp*) app authData:(FLOAuthAuthencationData*) data {
	return FLAutorelease([[FLOAuthRequestAccessTokenHttpRequest alloc] initWithOAuthApp:app authData:data]);
}

#if FL_MRC
- (void) dealloc {
    [_url release];
    [_app release];
    [_authData release];
    [super dealloc];
}
#endif

- (void) willSendHttpRequest {
    
	FLOAuthAuthorizationHeader* oauthHeader = [FLOAuthAuthorizationHeader authorizationHeader];
	[oauthHeader setParameter:kFLOAuthHeaderToken value:_authData.oauth_token];
	[oauthHeader setParameter:@"oauth_verifier" value:_authData.oauth_verifier];

    NSString* secret = [NSString stringWithFormat:@"%@&%@", _app.consumerSecret, _authData.oauth_token_secret];
 	[self setOAuthAuthorizationHeader:oauthHeader consumerKey:_app.consumerKey secret:secret];
}

- (id) resultFromHttpResponse:(FLHttpResponse*) httpResponse {

    FLOAuthSession* session = [FLOAuthSession oAuthSession];
    [FLUrlParameterParser parseData:httpResponse.responseData.data 
        intoObject:session 
        strict:YES 
        requiredKeys:[NSArray arrayWithObjects:@"oauth_token", @"oauth_token_secret", @"user_id", @"screen_name", nil]];

    return session;
}

//- (FLPromisedResult) runSynchronously {
//
//
//    FLHttpRequest* request = [FLHttpRequest httpPostRequestWithURL:_url];
//
//    FLHttpResponse* response = [self runChildSynchronously:request];
//
//    FLOAuthSession* session = [FLOAuthSession oAuthSession];
//    [FLUrlParameterParser parseData:response.responseData 
//        intoObject:session 
//        strict:YES 
//        requiredKeys:[NSArray arrayWithObjects:@"oauth_token", @"oauth_token_secret", @"user_id", @"screen_name", nil]];
//
//    return session;
//}

@end
