//
//  NSError+FLCancel.m
//  FishLampCore
//
//  Created by Mike Fullerton on 3/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSError+FLCancel.h"

#import "FishLampExceptions.h"
#import "NSError+FishLampCore.h"
#import "NSString+FishLamp.h"
#import "FishLampCoreErrorDomain.h"
#import "FishLampAssertions.h"

NSString* const FLCancelExceptionName = @"cancel";

@implementation NSError (FLCancelling)

+ (NSError*) cancelError {
    return [NSError errorWithDomain:FLErrorDomain
                               code:FLErrorCodeCancel
               localizedDescription:NSLocalizedString(@"Cancelled", @"used in cancel error localized description")];

}

- (BOOL) isCancelError {
	return	[FLErrorDomain isEqualToString:self.domain] && self.code == FLErrorCodeCancel;
}

@end
