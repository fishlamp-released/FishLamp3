//
//  FLURLErrorDomain.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSURLErrorDomainGenericDescriber.h"
#import "FLPrettyString.h"

//#import <CFNetwork/CFNetworkErrors.h>

@implementation NSURLErrorDomainGenericDescriber


- (NSString*) descriptionForErrorCode:(NSInteger) errorCode {
 
    FLPrettyString* text = [FLPrettyString prettyString];
	
    switch(errorCode)
    {
        case NSURLErrorUserAuthenticationRequired:
            [text appendLine:NSLocalizedString(@"Authentication Required.", nil)];
            break;
    
        case NSURLErrorTimedOut:
            [text appendLine:NSLocalizedString(@"The server is not responding.", nil)];
//			[text closeLine];
//			[text appendLine:MovePhone];
            break;

        case kCFURLErrorNotConnectedToInternet:
            [text appendLine:NSLocalizedString(@"A network connection can't be found.", nil)];
            [text closeLine];
            [text appendLine:NSLocalizedString(@"Please try again when you have a network connection.", nil)];
            break;
            
        case NSURLErrorNetworkConnectionLost:
            [text appendLine:NSLocalizedString(@"The network connection was lost.", nil)];
//			[text closeLine];
//			[text appendLine:MovePhone];
            break;

        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:		
            [text appendLine:NSLocalizedString(@"Unable to connect to server.", nil)];
//			[text closeLine];
            break;

        default:
            [text appendLine:NSLocalizedString(@"A network error occured.", nil)];
            break;
    }

	return [text string];
}

@end
