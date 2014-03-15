//
//  NSURLResponse+(Extras).m
//  FishLamp
//
//  Created by Mike Fullerton on 5/19/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSURLResponse+Extras.h"
#import "FLPrettyString.h"

@implementation NSHTTPURLResponse (Extras)

- (NSError*) simpleHttpResponseErrorCheck 
{
	NSInteger statusCode = [self statusCode];
	if(statusCode >= 400)
	{
		NSDictionary *errorInfo
		  = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
			  NSLocalizedString(@"Server returned error code:%d (%@)",@""),
				statusCode,
				[NSHTTPURLResponse localizedStringForStatusCode:statusCode]
				]
				forKey:NSLocalizedDescriptionKey];
	
	   return FLAutorelease([[NSError alloc] initWithDomain:FLErrorDomain 
			code:statusCode
			userInfo:errorInfo]);
	}

	return nil;
}

- (void) prettyDescription:(id<FLStringFormatter>) stringFormatter {

	NSDictionary* headers = [self allHeaderFields];
	
	[stringFormatter appendLineWithFormat:@"HTTP response: %ld (%@)", (long) self.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:self.statusCode]];

	[stringFormatter appendLine:@"headers:"];

    [stringFormatter indentLinesInBlock:^{
        for(id key in headers) {
            [stringFormatter appendLineWithFormat:@"%@: %@", [key description], [[headers objectForKey:key] description]];
        }
    }];
}



@end
