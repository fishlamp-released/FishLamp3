//
//  FLMutableNotification.h
//  FishLamp
//
//  Created by Mike Fullerton on 9/17/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

@interface FLMutableNotification : NSNotification {
@private
    NSString* _name;
    id _object;
    NSDictionary* _userInfo;
}

@property (readwrite, copy) NSString *name;
@property (readwrite, retain) id object;
@property (readwrite, copy) NSDictionary *userInfo;

@end
