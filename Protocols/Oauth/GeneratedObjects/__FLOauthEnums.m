// [Generated]
//
// This file was generated at 6/18/12 2:01 PM by Whittle ( http://whittle.greentongue.com/ ). DO NOT MODIFY!!
//
// __FLOauthEnums.m
// Project: FishLamp
// Schema: FLOauth
//
// Copywrite (C) 2012 GreenTongue Software, LLC. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOauthEnums.h"
@implementation FLOauthEnumLookup
FLSynthesizeSingleton(FLOauthEnumLookup);
- (id) init {
    if((self = [super init])) {
        _strings = [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithInt:FLOAuthHeaderConsumerKey], kFLOAuthHeaderConsumerKey, 
            [NSNumber numberWithInt:FLOAuthHeaderToken], kFLOAuthHeaderToken, 
            [NSNumber numberWithInt:FLOAuthHeaderSignatureMethod], kFLOAuthHeaderSignatureMethod, 
            [NSNumber numberWithInt:FLOAuthHeaderTimestamp], kFLOAuthHeaderTimestamp, 
            [NSNumber numberWithInt:FLOAuthHeaderNonce], kFLOAuthHeaderNonce, 
            [NSNumber numberWithInt:FLOAuthHeaderSignature], kFLOAuthHeaderSignature, 
            [NSNumber numberWithInt:FLOAuthHeaderCallback], kFLOAuthHeaderCallback, 
            [NSNumber numberWithInt:FLOAuthHeaderVersion], kFLOAuthHeaderVersion, 
            [NSNumber numberWithInt:FLOAuthSignatureMethodHMAC_SHA1], kFLOAuthSignatureMethodHMAC_SHA1, 
            [NSNumber numberWithInt:FLOAuthSignatureMethodRSA_SHA1], kFLOAuthSignatureMethodRSA_SHA1, 
            [NSNumber numberWithInt:FLOAuthSignatureMethodPlaintext], kFLOAuthSignatureMethodPlaintext, 
         nil];
    }
    return self;
}

- (NSInteger) lookupString:(NSString*) inString {
    NSNumber* num = [_strings objectForKey:inString];
    if(!num) { FLThrowErrorCodeWithComment(FLErrorDomain, FLErrorUnknownEnumValue, [NSString stringWithFormat:(NSLocalizedString(@"Unknown enum value (case sensitive): %@", nil)), inString]); } 
    return [num intValue];
}

- (NSString*) stringFromOAuthHeader:(FLOAuthHeader) inEnum {
    switch(inEnum) {
        case FLOAuthHeaderConsumerKey: return kFLOAuthHeaderConsumerKey;
        case FLOAuthHeaderToken: return kFLOAuthHeaderToken;
        case FLOAuthHeaderSignatureMethod: return kFLOAuthHeaderSignatureMethod;
        case FLOAuthHeaderTimestamp: return kFLOAuthHeaderTimestamp;
        case FLOAuthHeaderNonce: return kFLOAuthHeaderNonce;
        case FLOAuthHeaderSignature: return kFLOAuthHeaderSignature;
        case FLOAuthHeaderCallback: return kFLOAuthHeaderCallback;
        case FLOAuthHeaderVersion: return kFLOAuthHeaderVersion;
    }
    return nil;
}

- (FLOAuthHeader) oAuthHeaderFromString:(NSString*) inString {
    return (FLOAuthHeader) [self lookupString:inString];
}


- (NSString*) stringFromOAuthSignatureMethod:(FLOAuthSignatureMethod) inEnum {
    switch(inEnum) {
        case FLOAuthSignatureMethodHMAC_SHA1: return kFLOAuthSignatureMethodHMAC_SHA1;
        case FLOAuthSignatureMethodRSA_SHA1: return kFLOAuthSignatureMethodRSA_SHA1;
        case FLOAuthSignatureMethodPlaintext: return kFLOAuthSignatureMethodPlaintext;
    }
    return nil;
}

- (FLOAuthSignatureMethod) oAuthSignatureMethodFromString:(NSString*) inString {
    return (FLOAuthSignatureMethod) [self lookupString:inString];
}

@end
// [/Generated]
