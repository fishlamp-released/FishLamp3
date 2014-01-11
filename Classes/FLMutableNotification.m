//
//  FLMutableNotification.m
//  FishLamp
//
//  Created by Mike Fullerton on 9/17/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLMutableNotification.h"

@implementation FLMutableNotification
@synthesize name = _name;
@synthesize object = _object;
@synthesize userInfo = _userInfo;

#if FL_MRC
- (void)dealloc {
    [_object release];
    [_userInfo release];
    [_name release];
	[super dealloc];
}
#endif
@end
