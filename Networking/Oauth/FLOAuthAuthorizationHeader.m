//
//  FLOAuthAuthorizationHeader.m
//  FishLamp
//
//  Created by Mike Fullerton on 5/19/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOAuthAuthorizationHeader.h"
#import "NSString+URL.h"
#import <CommonCrypto/CommonHMAC.h>
#import "Base64Transcoder.h"
#import "NSString+GUID.h"
#import "FLStringUtils.h"
#import "FLHttpRequestHeaders.h"

@interface FLOAuthAuthorizationHeader ()
@end


#if DEBUG
extern void FLDebugCompareStrings(NSString* lhs, NSString* rhs);
extern void TestEncoding();
extern void FLDebugCompareHeaders(NSString* lhs, NSString* rhs);
#endif


@implementation FLOAuthAuthorizationHeader

+ (NSString*) generateNonce {
	return [NSString guidString];
}

+ (NSString *)generateTimestamp  {
	return [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
}

+ (id) authorizationHeader {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {
    self = [super init];
    if(self) {
		_parameters = [[NSMutableDictionary alloc] init];
        [self setParameter:kFLOAuthHeaderSignatureMethod value:kFLOAuthSignatureMethodHMAC_SHA1];
        [self setParameter:kFLOAuthHeaderVersion value:FLOAuthVersion];
    }
    
    return self;
}

#if FL_MRC
- (void) dealloc {
	FLRelease(_parameters);
	FLSuperDealloc();
}
#endif

- (void) setParameter:(NSString*) parameter value:(NSString*) value {
	FLAssertStringIsNotEmpty(parameter);
	FLAssertStringIsNotEmpty(value);

	[_parameters setObject:value forKey:parameter];
}

- (NSArray*) sortedParameters {
	NSArray* parameters = [_parameters allKeys];
    
    NSComparator sorter = ^NSComparisonResult(id lhs, id rhs) {
        FLAssertStringIsNotEmpty(lhs);
        FLAssertStringIsNotEmpty(rhs);

    // order first by param
        NSComparisonResult result = [lhs compare:rhs];
    
    // if dupe param sort by param's value.
        if(result == NSOrderedSame) {
            result = [[_parameters objectForKey:lhs] compare:[_parameters objectForKey:rhs]];
        }

        return result;
    };
    
    return [parameters sortedArrayUsingComparator:sorter];
}


- (NSString*) computeBaseURLForRequest:(FLHttpRequest*) request  {

    NSArray* parameters = [self sortedParameters];
	NSMutableString* outString = [NSMutableString string];
	for(NSString* parm in parameters) {
		NSString* value = [_parameters objectForKey:parm];
	
		value = [value urlEncodeString:NSUTF8StringEncoding];

		if(outString.length) {	
			[outString appendFormat:@"&%@=%@", parm, value];
		}
		else {
			[outString appendFormat:@"%@=%@", parm, value];
		}
	}
	
	return [NSString stringWithFormat:@"%@&%@&%@",
            request.requestHeaders.httpMethod,
			[request.requestHeaders.requestURL.absoluteString urlEncodeString:NSUTF8StringEncoding],
			[outString urlEncodeString:NSUTF8StringEncoding]];
}


- (NSString *) buildHMAC_SHA1SignatureWithBaseURL:(NSString*) baseURL withSecret:(NSString*) secret {

    FLConfirmStringIsNotEmptyWithComment(secret, @"secret is empty");

	NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
	NSData *textData = [baseURL dataUsingEncoding:NSUTF8StringEncoding];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];

	CCHmacContext hmacContext;
	bzero(&hmacContext, sizeof(CCHmacContext));
    CCHmacInit(&hmacContext, kCCHmacAlgSHA1, secretData.bytes, secretData.length);
    CCHmacUpdate(&hmacContext, textData.bytes, textData.length);
    CCHmacFinal(&hmacContext, result);
	
	//Base64 Encoding
	char base64Result[32];
	size_t theResultLength = 32;
	Base64EncodeData((const char*) result, 
		20, 
		base64Result, 
		&theResultLength);
		
	NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
	NSString *base64EncodedResult = FLAutorelease([[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding]);
	
	return base64EncodedResult;
}

- (NSString*) buildAuthorizationHeaderForRequest:(FLHttpRequest*) request
                             oauthParametersOnly:(BOOL) oauthParametersOnly
                                     consumerKey:(NSString*) consumerKey
                                          secret:(NSString*) secret {

 	[self setParameter:kFLOAuthHeaderConsumerKey value:consumerKey];
    [self setParameter:kFLOAuthHeaderNonce value:[FLOAuthAuthorizationHeader generateNonce]];
    [self setParameter:kFLOAuthHeaderTimestamp value:[FLOAuthAuthorizationHeader generateTimestamp]];
    
    NSString* baseURL = [self computeBaseURLForRequest:request];
    NSString* signature = [self buildHMAC_SHA1SignatureWithBaseURL:baseURL withSecret:secret];
    [self setParameter:kFLOAuthHeaderSignature value:signature];
	
    NSArray* parameters = [self sortedParameters];
    NSMutableString* outString = [NSMutableString stringWithFormat:@"OAuth"];
	
	BOOL first = YES;
	for(NSString* parm in parameters) {
		if(!oauthParametersOnly || [parm rangeOfString:@"oauth"].length > 0) {
			NSString* value = [_parameters objectForKey:parm];
		
			value = [value urlEncodeString:NSUTF8StringEncoding];
		
			if(first) {	
				first = NO;
				[outString appendFormat:@" %@=\"%@\"", parm, value];
			}
			else {
				[outString appendFormat:@", %@=\"%@\"", parm, value];
			}
		}
	}

#if LOG
	FLLog(@"OAuth auth header: %@", outString);
#endif
	
	return outString;
}



@end

@implementation FLHttpRequest (OAuth)

- (void) setOAuthAuthorizationHeader:(FLOAuthAuthorizationHeader*) signature
                         consumerKey:(NSString*) consumerKey
                              secret:(NSString*) secret {

    NSString* header = [signature buildAuthorizationHeaderForRequest:self
                                                 oauthParametersOnly:YES
                                                         consumerKey:consumerKey
                                                              secret:secret];
#if DEBUG
    FLLog(@"%@ = %@", FLOAuthHttpAuthorizationHeader, header);
#endif
    [self.requestHeaders setValue:header forHTTPHeaderField:FLOAuthHttpAuthorizationHeader];
}

@end

#if DEBUG

NSDictionary* FLGetHeaders(NSString* header)
{	
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	NSArray* list = [header componentsSeparatedByString:@","];
	for(NSString* item in list)
	{
		NSArray* pair = [item componentsSeparatedByString:@"="];
		if(pair.count == 2)
		{
			[dict setObject:[[pair objectAtIndex:1] trimmedString_fl] forKey:[[pair objectAtIndex:0] trimmedString_fl] ];
		}
	}
	
	return dict;
}

BOOL FLCompareDicts(NSDictionary* lhsDict, NSDictionary* rhsDict)
{
	BOOL equal = YES;
	for(NSString* key in lhsDict)
	{
		NSString* lhsValue = [lhsDict objectForKey:key];
		NSString* rhsValue = [rhsDict objectForKey:key];
		if(!rhsValue)
		{
			equal = NO;
			FLLog(@"rhs missing %@/%@", key, lhsValue);
		}
		else if(!FLStringsAreEqual(lhsValue, rhsValue))
		{
			equal = NO;
			FLLog(@"value for key %@ are not equal: %@ != %@", key, lhsValue, rhsValue);
		}
		else 
		{
			FLLog(@"found %@=%@ in both headers", key, lhsValue);
		}
	}
	
	return equal;
}

NSString* removeOAuth(NSString* str)
{
	if([str hasPrefix:@"OAuth "])
	{
		return [str substringFromIndex:@"OAuth ".length];
	}
	
	return str;
}

void FLDebugCompareHeaders(NSString* lhs, NSString* rhs)
{
	NSDictionary* lhsDict = FLGetHeaders(removeOAuth(lhs));
	NSDictionary* rhsDict = FLGetHeaders(removeOAuth(rhs));
	
	BOOL equal = FLCompareDicts(lhsDict, rhsDict);
	if(!FLCompareDicts(lhsDict, lhsDict))
	{
		equal = NO;
	}
	
	if(equal)
	{
		FLLog(@"header:\n%@\n==\n%@", lhs, rhs);
	}
	else
	{
		FLLog(@"header:\n%@\n!=\n%@", lhs, rhs);
	}
}

void FLDebugCompareStrings(NSString* lhs, NSString* rhs)
{
	FLLog(@"lhs:\n%@", lhs);
	FLLog(@"rhs:\n%@", rhs);

	if(lhs.length != rhs.length)
	{
		FLLog(@"lhs length: %ld != rhs length: %ld", (unsigned long)lhs.length, (unsigned long)rhs.length);
	}

	NSMutableString* str = [NSMutableString string];
	for(int i = 0; i < (int) MAX(lhs.length, rhs.length); i++)
	{
		if(i >= (int)lhs.length)
		{
			FLLog(@"lhs ran out of chars");
			FLLog(str);
		}
		else if(i >= (int)rhs.length)
		{
			FLLog(@"rhs ran out of chars");
			FLLog(str);
		}
		else if([lhs characterAtIndex:i] == [rhs characterAtIndex:i])
		{
			[str appendFormat:@"%c", [lhs characterAtIndex:i]];
		}
		else
		{
			FLLog(str);
			FLLog(@"%d: %c != %c", i, [lhs characterAtIndex:i], [rhs characterAtIndex:i]); 
			return;
		}
	}
	
	FLLog(@"%@\n==\n%@", lhs, rhs); 

}
void TestEncoding()
{
//	FLOAuthAuthorizationHeader* sig = [FLOAuthAuthorizationHeader OAuthSignature];
//	
//	//\alloc] initWithMethod:@"POST" url:[NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"]];
//	
//	[sig setParameter:kFLOAuthHeaderCallback value:[@"http://localhost:3005/the_dance/process_callback?service_provider_id=11" urlEncodeString:NSUTF8StringEncoding]];
//
//	[sig setParameter:kFLOAuthHeaderConsumerKey value:@"GDdmIQH6jhtmLUypg82g"];
//	[sig setParameter:kFLOAuthHeaderNonce value:@"QP70eNmVz8jvdPevU3oJD2AfF7R7odC2XJcn4XlZJqk"];
//	[sig setParameter:kFLOAuthHeaderTimestamp value:@"1272323042"];
//	[sig setParameter:kFLOAuthHeaderSignatureMethod value:kFLOAuthSignatureMethodHMAC_SHA1];
//	[sig setParameter:kFLOAuthHeaderVersion value:FLOAuthVersion];
//	
//	NSString* baseUrl = [sig computeBaseURL];
//	
//	NSString* refString = @"POST&https%3A%2F%2Fapi.twitter.com%2Foauth%2Frequest_token&oauth_callback%3Dhttp%253A%252F%252Flocalhost%253A3005%252Fthe_dance%252Fprocess_callback%253Fservice_provider_id%253D11%26oauth_consumer_key%3DGDdmIQH6jhtmLUypg82g%26oauth_nonce%3DQP70eNmVz8jvdPevU3oJD2AfF7R7odC2XJcn4XlZJqk%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1272323042%26oauth_version%3D1.0";
//	
//	FLDebugCompareStrings(
//		baseUrl, refString);
//	
////	baseUrl = [baseUrl urlEncodeString:NSUTF8StringEncoding];
//	
//	
////	if(FLStringsAreEqual(@"POST&https%3A%2F%2Fapi.twitter.com%2Foauth%2Frequest_token&oauth_callback%3Dhttp%253A%252F%252Flocalhost%253A3005%252Fthe_dance%252Fprocess_callback%253Fservice_provider_id%253D11%26oauth_consumer_key%3DGDdmIQH6jhtmLUypg82g%26oauth_nonce%3DQP70eNmVz8jvdPevU3oJD2AfF7R7odC2XJcn4XlZJqk%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1272323042%26oauth_version%3D1.0
////", baseURL))
////{
////
////}
//	
//	NSString* key = [sig buildHMAC_SHA1Signature:[NSString stringWithFormat:@"%@&", @"MCD8BKwGdgPHvAuvgvz4EQpqDAtx89grbuNMRd7Eh98"]];
//
//	FLDebugCompareStrings(key, @"8wUi7m5HFQy76nowoCThusfgB+Q=");
//	
////	FLLog(@"Keys are equal: %d", FLStringsAreEqual(@"8wUi7m5HFQy76nowoCThusfgB+Q=", key));
//
//	FLLog(key);
//
//	[sig setParameter:kFLOAuthHeaderSignature value:key];
//
//	NSString* authHeader = [sig buildAuthorizationHeader];
//	NSString* refAuthHeader = @"OAuth oauth_nonce=\"QP70eNmVz8jvdPevU3oJD2AfF7R7odC2XJcn4XlZJqk\", oauth_callback=\"http%3A%2F%2Flocalhost%3A3005%2Fthe_dance%2Fprocess_callback%3Fservice_provider_id%3D11\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1272323042\", oauth_consumer_key=\"GDdmIQH6jhtmLUypg82g\", oauth_signature=\"8wUi7m5HFQy76nowoCThusfgB%2BQ%3D\", oauth_version=\"1.0\"";
//	
//	FLDebugCompareStrings(authHeader, refAuthHeader);

}
//
//void test2(NSString* consumerKey)
//{
//
//	FLOAuthAuthorizationHeader* sig = [[FLOAuthAuthorizationHeader alloc] initWithMethod:@"POST" url:@"http://api.twitter.com/oauth/request_token"];
//	
////	[sig setParameter:kFLOAuthHeaderCallback value:[@"http://localhost:3005/the_dance/process_callback?service_provider_id=11" urlEncodeString:NSUTF8StringEncoding]];
//
//	[sig setParameter:kFLOAuthHeaderConsumerKey value:consumerKey];
//	[sig setParameter:kFLOAuthHeaderNonce value:@"AA79DF97-AEA9-4DBA-96A6-C9C203E263C0"];
//	[sig setParameter:kFLOAuthHeaderTimestamp value:@"1305849268"];
//	[sig setParameter:kFLOAuthHeaderSignature value:kFLOAuthHeaderSignatureMethod];
//	[sig setParameter:kFLOAuthHeaderVersion value:kFLOAuthHeaderVersion];
//	
//	NSString* baseUrl = [sig computeBaseURL];
//	
////	NSString* refString = @"POST&https%3A%2F%2Fapi.twitter.com%2Foauth%2Frequest_token&oauth_callback%3Dhttp%253A%252F%252Flocalhost%253A3005%252Fthe_dance%252Fprocess_callback%253Fservice_provider_id%253D11%26oauth_consumer_key%3DGDdmIQH6jhtmLUypg82g%26oauth_nonce%3DQP70eNmVz8jvdPevU3oJD2AfF7R7odC2XJcn4XlZJqk%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1272323042%26oauth_version%3D1.0";
////	
////	FLDebugCompareStrings(
////		baseUrl, refString);
//	
////	baseUrl = [baseUrl urlEncodeString:NSUTF8StringEncoding];
//		
//	NSString* key = [sig buildHMAC_SHA1Signature:[NSString stringWithFormat:@"%@&", [FLT instance].consumerSecret]];
//
//	FLDebugCompareStrings(key, [@"TV9uaB7Wl4w9uRW4%2BQ6K%2FkEQeYg%3D" urlDecodeString:NSUTF8StringEncoding]);
//	
////	FLLog(@"Keys are equal: %d", FLStringsAreEqual(@"8wUi7m5HFQy76nowoCThusfgB+Q=", key));
//
//	FLLog(key);
//
//	[sig setParameter:kFLOAuthHeaderSignature value:key];
//
//
//	
//	NSString* authHeader = [sig buildAuthorizationHeader];
//	
//	FLLog(authHeader);
//	
////	NSString* refAuthHeader = @"OAuth oauth_nonce=\"QP70eNmVz8jvdPevU3oJD2AfF7R7odC2XJcn4XlZJqk\", oauth_callback=\"http%3A%2F%2Flocalhost%3A3005%2Fthe_dance%2Fprocess_callback%3Fservice_provider_id%3D11\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1272323042\", oauth_consumer_key=\"GDdmIQH6jhtmLUypg82g\", oauth_signature=\"8wUi7m5HFQy76nowoCThusfgB%2BQ%3D\", oauth_version=\"1.0\"";
//	
////	FLDebugCompareStrings(authHeader, refAuthHeader);
//
//
//}

#endif
