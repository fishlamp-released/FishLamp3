// [Generated]
//
// This file was generated at 6/18/12 2:01 PM by Whittle ( http://whittle.greentongue.com/ ). DO NOT MODIFY!!
//
// __FLOAuthApp.m
// Project: FishLamp
// Schema: FLOauth
//
// Copywrite (C) 2012 GreenTongue Software, LLC. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOAuthApp.h"
#import "FLObjectDescriber.h"

@implementation FLOAuthApp


@synthesize accessTokenUrl = __accessTokenUrl;
@synthesize apiKey = __apiKey;
@synthesize appId = __appId;
@synthesize authorizeUrl = __authorizeUrl;
@synthesize callback = __callback;
@synthesize consumerKey = __consumerKey;
@synthesize consumerSecret = __consumerSecret;
@synthesize requestTokenUrl = __requestTokenUrl;

+ (NSString*) accessTokenUrlKey
{
    return @"accessTokenUrl";
}

+ (NSString*) apiKeyKey
{
    return @"apiKey";
}

+ (NSString*) appIdKey
{
    return @"appId";
}

+ (NSString*) authorizeUrlKey
{
    return @"authorizeUrl";
}

+ (NSString*) callbackKey
{
    return @"callback";
}

+ (NSString*) consumerKeyKey
{
    return @"consumerKey";
}

+ (NSString*) consumerSecretKey
{
    return @"consumerSecret";
}

+ (NSString*) requestTokenUrlKey
{
    return @"requestTokenUrl";
}

- (void) dealloc
{
    FLRelease(__appId);
    FLRelease(__apiKey);
    FLRelease(__consumerKey);
    FLRelease(__consumerSecret);
    FLRelease(__requestTokenUrl);
    FLRelease(__accessTokenUrl);
    FLRelease(__authorizeUrl);
    FLRelease(__callback);
    FLSuperDealloc();
}

- (id) init
{
    if((self = [super init]))
    {
    }
    return self;
}

+ (FLOAuthApp*) oAuthApp
{
    return FLAutorelease([[FLOAuthApp alloc] init]);
}



- (BOOL) isModelObject {
    return YES;
}
+ (BOOL) isModelObject {
    return YES;
}

@end

@implementation FLOAuthApp (ValueProperties) 
@end

// [/Generated]
