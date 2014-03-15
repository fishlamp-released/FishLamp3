//
//  FLAssertionFailedError.h
//  FishLampCore
//
//  Created by Mike Fullerton on 3/20/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"

@class FLStackTrace;

@interface NSError (FLAssertions)
+ (id) assertionFailedError:(NSInteger) code 
                     reason:(NSString*) reason 
                    comment:(NSString*) comment
                 stackTrace:(FLStackTrace*) stackTrace;
@end

extern NSString* const FLAssertionFailedExceptionName;


