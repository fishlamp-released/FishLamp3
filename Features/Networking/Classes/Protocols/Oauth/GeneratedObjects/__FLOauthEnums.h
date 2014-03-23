// [Generated]
//
// This file was generated at 6/18/12 2:01 PM by Whittle ( http://whittle.greentongue.com/ ). DO NOT MODIFY!!
//
// __FLOauthEnums.h
// Project: FishLamp
// Schema: FLOauth
//
// Copywrite (C) 2012 GreenTongue Software, LLC. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampCore.h"

#define FLOAuthHttpAuthorizationHeader @"Authorization" // for http header
#define FLOAuthVersion @"1.0" 

#define kFLOAuthHeaderConsumerKey @"oauth_consumer_key"
#define kFLOAuthHeaderToken @"oauth_token"
#define kFLOAuthHeaderSignatureMethod @"oauth_signature_method"
#define kFLOAuthHeaderTimestamp @"oauth_timestamp"
#define kFLOAuthHeaderNonce @"oauth_nonce"
#define kFLOAuthHeaderSignature @"oauth_signature"
#define kFLOAuthHeaderCallback @"oauth_callback"
#define kFLOAuthHeaderVersion @"oauth_version"
#define kFLOAuthSignatureMethodHMAC_SHA1 @"HMAC-SHA1"
#define kFLOAuthSignatureMethodRSA_SHA1 @"RSA-SHA1"
#define kFLOAuthSignatureMethodPlaintext @"PLAINTEXT"

typedef enum {
    FLOAuthHeaderConsumerKey,
    FLOAuthHeaderToken,
    FLOAuthHeaderSignatureMethod,
    FLOAuthHeaderTimestamp,
    FLOAuthHeaderNonce,
    FLOAuthHeaderSignature,
    FLOAuthHeaderCallback,
    FLOAuthHeaderVersion,
} FLOAuthHeader;

typedef enum {
    FLOAuthSignatureMethodHMAC_SHA1,
    FLOAuthSignatureMethodRSA_SHA1,
    FLOAuthSignatureMethodPlaintext,
} FLOAuthSignatureMethod;


@interface FLOauthEnumLookup : NSObject {
	NSDictionary* _strings;
}
FLSingletonProperty(FLOauthEnumLookup);

- (NSString*) stringFromOAuthHeader:(FLOAuthHeader) inEnum;
- (FLOAuthHeader) oAuthHeaderFromString:(NSString*) inString;

- (NSString*) stringFromOAuthSignatureMethod:(FLOAuthSignatureMethod) inEnum;
- (FLOAuthSignatureMethod) oAuthSignatureMethodFromString:(NSString*) inString;
@end
// [/Generated]
