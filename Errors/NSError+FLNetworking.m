//
//  NSError+_FLNetworking_.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSError+FLNetworking.h"
#import "FLPrettyString.h"

/*
#import <Foundation/NSURLError.h>
#import <CFNetwork/CFNetworkErrors.h>
*/

@implementation NSError (FLNetworking)

- (BOOL) didLoseNetwork {
	return	FLStringsAreEqual(NSURLErrorDomain, self.domain) &&
			((self.code == NSURLErrorNetworkConnectionLost) || 
			(self.code == NSURLErrorNotConnectedToInternet));
}


- (BOOL) isNotConnectedToInternetError {
	return FLStringsAreEqual(NSURLErrorDomain, self.domain) && self.code == NSURLErrorNotConnectedToInternet;
}

- (NSString*) localizedDescriptionForSDKErrorCode {

    if( [self.domain isEqualToString:NSURLErrorDomain]) {

        FLPrettyString* text = [FLPrettyString prettyString];
        
        switch(self.code)
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

    return nil;
}

@end
