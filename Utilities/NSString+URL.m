//
//  NSString+URL.m
//  FishLamp
//
//  Created by Mike Fullerton on 5/18/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSString+URL.h"
#import "FLCoreFoundation.h"

@implementation NSString (URL)

+ (NSString*) URLString:(NSString*) url params:(NSString*) firstParameter, ... 
{
	if(firstParameter)
	{
		NSMutableString* outUrl = FLAutorelease([url mutableCopy]);
		BOOL isFirst = YES;
		NSString* key = firstParameter;
		id obj = nil;
	
		va_list valist;
		va_start(valist, firstParameter);   
		while ((obj = va_arg(valist, id)))
		{ 
			if(key)
			{
				NSString* value = [obj urlEncodeString:NSUTF8StringEncoding];
				if(isFirst)
				{
					isFirst = NO;
					[outUrl appendFormat:@"?%@=%@", key, value];
				}	
				else
				{
					[outUrl appendFormat:@"&%@=%@", key, value];
				}
				key = nil;
			}
			else
			{
				key = (NSString*) obj;
			}
		}
		va_end(valist);
		return outUrl;

	}

	return url;
}

- (NSString*) appendURLParameters:(NSString*) firstParameter, ...  
{
	NSMutableString* outUrl = FLAutorelease([self mutableCopy]);
	BOOL isFirst = YES;
	NSString* key = firstParameter;
	id obj = nil;

	va_list valist;
	va_start(valist, firstParameter);   
	while ((obj = va_arg(valist, id)))
	{ 
		if(key)
		{
			NSString* value = [obj urlEncodeString:NSUTF8StringEncoding];
			if(isFirst)
			{
				isFirst = NO;
				[outUrl appendFormat:@"?%@=%@", key, value];
			}	
			else
			{
				[outUrl appendFormat:@"&%@=%@", key, value];
			}
			key = nil;
		}
		else
		{
			key = (NSString*) obj;
		}
	}
	va_end(valist);
	return outUrl;


}

+ (NSDictionary*) parseURLParams:(NSString *)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = FLAutorelease([[NSMutableDictionary alloc] init]);
	
	for (NSString *pair in pairs) 
	{
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		if(kv.count == 2)
		{
			NSString *val = [[kv objectAtIndex:1] urlDecodeString:NSUTF8StringEncoding];
			[params setObject:val forKey:[kv objectAtIndex:0]];
		}
	}
	return params;
}

- (NSString *) urlEncodeString:(NSStringEncoding)encoding
{
	return FLAutorelease(FLBridgeTransfer(NSString*,CFURLCreateStringByAddingPercentEscapes(
			kCFAllocatorDefault, 
			FLBridge(void*,self),
			NULL, // escape all
			FLBridge(void*,@";/?:@&=$+{}<>,'\""),
			CFStringConvertNSStringEncodingToEncoding(encoding))));
}  

- (NSString *) urlDecodeString:(NSStringEncoding)encoding {

	return FLAutorelease(FLBridgeTransfer(NSString*,
                CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                    kCFAllocatorDefault, 
                    FLBridge(void*,self),
                    CFSTR(""), 
                    CFStringConvertNSStringEncodingToEncoding(encoding))));
}

@end

@implementation NSMutableString (URL)

- (void) appendAndEncodeURLParameter:(NSString*) parameter name:(NSString*)name seperator:(NSString*) seperator
{
	[self appendFormat:@"%@%@=%@", seperator, name, [parameter urlEncodeString:NSUTF8StringEncoding]];
}

@end
