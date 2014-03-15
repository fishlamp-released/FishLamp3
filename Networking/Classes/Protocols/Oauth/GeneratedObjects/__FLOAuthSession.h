// [Generated]
//
// This file was generated at 6/18/12 2:01 PM by Whittle ( http://whittle.greentongue.com/ ). DO NOT MODIFY!!
//
// __FLOAuthSession.h
// Project: FishLamp
// Schema: FLOauth
//
// Copywrite (C) 2012 GreenTongue Software, LLC. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//



// --------------------------------------------------------------------
// FLOAuthSession
// --------------------------------------------------------------------
@interface FLOAuthSession : NSObject<NSCopying, NSCoding>{ 
@private
    NSString* __userGuid;
    NSString* __appName;
    NSString* __oauth_token;
    NSString* __oauth_token_secret;
    NSString* __user_id;
    NSString* __screen_name;
} 


@property (readwrite, strong, nonatomic) NSString* appName;

@property (readwrite, strong, nonatomic) NSString* oauth_token;

@property (readwrite, strong, nonatomic) NSString* oauth_token_secret;

@property (readwrite, strong, nonatomic) NSString* screen_name;

@property (readwrite, strong, nonatomic) NSString* userGuid;

@property (readwrite, strong, nonatomic) NSString* user_id;

+ (NSString*) appNameKey;

+ (NSString*) oauth_tokenKey;

+ (NSString*) oauth_token_secretKey;

+ (NSString*) screen_nameKey;

+ (NSString*) userGuidKey;

+ (NSString*) user_idKey;

+ (FLOAuthSession*) oAuthSession; 

@end

@interface FLOAuthSession (ValueProperties) 
@end

// [/Generated]
