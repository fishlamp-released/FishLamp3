// [Generated]
//
// This file was generated at 6/18/12 2:01 PM by Whittle ( http://whittle.greentongue.com/ ). DO NOT MODIFY!!
//
// __FLOAuthAuthencationData.h
// Project: FishLamp
// Schema: FLOauth
//
// Copywrite (C) 2012 GreenTongue Software, LLC. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//



// --------------------------------------------------------------------
// FLOAuthAuthencationData
// --------------------------------------------------------------------
@interface FLOAuthAuthencationData : NSObject{ 
@private
    NSString* __oauth_token_secret;
    NSString* __oauth_callback_confirmed;
    NSString* __oauth_token;
    NSString* __oauth_verifier;
} 


@property (readwrite, strong, nonatomic) NSString* oauth_callback_confirmed;

@property (readwrite, strong, nonatomic) NSString* oauth_token;

@property (readwrite, strong, nonatomic) NSString* oauth_token_secret;

@property (readwrite, strong, nonatomic) NSString* oauth_verifier;

+ (NSString*) oauth_callback_confirmedKey;

+ (NSString*) oauth_tokenKey;

+ (NSString*) oauth_token_secretKey;

+ (NSString*) oauth_verifierKey;

+ (FLOAuthAuthencationData*) oAuthAuthencationData; 

@end

@interface FLOAuthAuthencationData (ValueProperties) 
@end

// [/Generated]
