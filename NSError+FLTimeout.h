//
//  NSError+FLTimeout.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@interface NSError (FLTimeout)
+ (NSError*) timeoutError;
@property (readonly, nonatomic) BOOL isTimeoutError;
@end
