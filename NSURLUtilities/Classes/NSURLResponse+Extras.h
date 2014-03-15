//
//  NSURLResponse+(Extras).h
//  FishLamp
//
//  Created by Mike Fullerton on 5/19/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

@protocol FLStringFormatter;

@interface NSHTTPURLResponse (Extras)
- (NSError*) simpleHttpResponseErrorCheck;

- (void) prettyDescription:(id<FLStringFormatter>) stringFormatter;

@end
