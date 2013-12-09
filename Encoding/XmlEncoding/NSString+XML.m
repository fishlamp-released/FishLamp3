//
//  NSString+XML.m
//  FishLamp
//
//  Created by Mike Fullerton on 5/11/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSString+XML.h"


@implementation NSString (XML)

- (NSString*) xmlEncode
{
	NSString* encoded = self;
	encoded = [encoded stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
	encoded = [encoded stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
	encoded = [encoded stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
	encoded = [encoded stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
	encoded = [encoded stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];	
	encoded = [encoded stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];	   
	return encoded;
}

- (NSString*) xmlDecode
{
	NSString* decoded = self;
	decoded = [decoded stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	decoded = [decoded stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
	decoded = [decoded stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
	decoded = [decoded stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];	
	decoded = [decoded stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
//	  decoded = [decoded stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
	return decoded;
}

@end
