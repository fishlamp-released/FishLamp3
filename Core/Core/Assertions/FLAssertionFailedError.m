//
//  FLAssertionFailedError.m
//  FishLampCore
//
//  Created by Mike Fullerton on 3/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAssertionFailedError.h"
#import "FishLampExceptions.h"
#import "NSError+FLStackTrace.h"
#import "NSString+FishLamp.h"
#import "FLAssertionFailureErrorDomain.h"

@implementation NSError (FLAssertions)

+ (id) assertionFailedError:(NSInteger) code 
                     reason:(NSString*) reason 
                    comment:(NSString*) comment
                 stackTrace:(FLStackTrace*) stackTrace{

    NSString* localizedDescription = nil;
    if([comment length] > 0) {
        localizedDescription = [NSString stringWithFormat:@"%@ (%@)", comment, reason];
    }
    else {
        localizedDescription = reason;
    }

    return [self errorWithDomain:FLAssertionFailureErrorDomain
                            code:code
            localizedDescription:localizedDescription
                        userInfo:nil
                      stackTrace:stackTrace];
}                    

@end

NSString* const FLAssertionFailedExceptionName = @"assert";

