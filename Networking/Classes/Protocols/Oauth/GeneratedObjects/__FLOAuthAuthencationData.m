// [Generated]
//
// This file was generated at 6/18/12 2:01 PM by Whittle ( http://whittle.greentongue.com/ ). DO NOT MODIFY!!
//
// __FLOAuthAuthencationData.m
// Project: FishLamp
// Schema: FLOauth
//
// Copywrite (C) 2012 GreenTongue Software, LLC. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOAuthAuthencationData.h"
#import "FLObjectDescriber.h"

@implementation FLOAuthAuthencationData


@synthesize oauth_callback_confirmed = __oauth_callback_confirmed;
@synthesize oauth_token = __oauth_token;
@synthesize oauth_token_secret = __oauth_token_secret;
@synthesize oauth_verifier = __oauth_verifier;

+ (NSString*) oauth_callback_confirmedKey
{
    return @"oauth_callback_confirmed";
}

+ (NSString*) oauth_tokenKey
{
    return @"oauth_token";
}

+ (NSString*) oauth_token_secretKey
{
    return @"oauth_token_secret";
}

+ (NSString*) oauth_verifierKey
{
    return @"oauth_verifier";
}

- (void) dealloc
{
    FLRelease(__oauth_token_secret);
    FLRelease(__oauth_callback_confirmed);
    FLRelease(__oauth_token);
    FLRelease(__oauth_verifier);
    FLSuperDealloc();
}

- (id) init
{
    if((self = [super init]))
    {
    }
    return self;
}

+ (FLOAuthAuthencationData*) oAuthAuthencationData
{
    return FLAutorelease([[FLOAuthAuthencationData alloc] init]);
}


- (BOOL) isModelObject {
    return YES;
}
+ (BOOL) isModelObject {
    return YES;
}

@end

@implementation FLOAuthAuthencationData (ValueProperties) 
@end

// [/Generated]
