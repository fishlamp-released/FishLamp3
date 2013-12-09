// [Generated]
//
// This file was generated at 6/18/12 2:01 PM by Whittle ( http://whittle.greentongue.com/ ). DO NOT MODIFY!!
//
// __FLOAuthApp.h
// Project: FishLamp
// Schema: FLOauth
//
// Copywrite (C) 2012 GreenTongue Software, LLC. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//


#import "FLNetworkServerContext.h"

// --------------------------------------------------------------------
// FLOAuthApp
// --------------------------------------------------------------------
@interface FLOAuthApp : FLNetworkServerContext{ 
@private
    NSString* __appId;
    NSString* __apiKey;
    NSString* __consumerKey;
    NSString* __consumerSecret;
    NSString* __requestTokenUrl;
    NSString* __accessTokenUrl;
    NSString* __authorizeUrl;
    NSString* __callback;
} 


@property (readwrite, strong, nonatomic) NSString* accessTokenUrl;

@property (readwrite, strong, nonatomic) NSString* apiKey;

@property (readwrite, strong, nonatomic) NSString* appId;

@property (readwrite, strong, nonatomic) NSString* authorizeUrl;

@property (readwrite, strong, nonatomic) NSString* callback;

@property (readwrite, strong, nonatomic) NSString* consumerKey;

@property (readwrite, strong, nonatomic) NSString* consumerSecret;

@property (readwrite, strong, nonatomic) NSString* requestTokenUrl;

+ (NSString*) accessTokenUrlKey;

+ (NSString*) apiKeyKey;

+ (NSString*) appIdKey;

+ (NSString*) authorizeUrlKey;

+ (NSString*) callbackKey;

+ (NSString*) consumerKeyKey;

+ (NSString*) consumerSecretKey;

+ (NSString*) requestTokenUrlKey;

+ (FLOAuthApp*) oAuthApp; 

@end

@interface FLOAuthApp (ValueProperties) 
@end

// [/Generated]
