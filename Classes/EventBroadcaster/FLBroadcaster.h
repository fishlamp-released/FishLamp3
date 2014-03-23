//
//  FLBroadcaster.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/24/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLEventBroadcaster.h"

@interface FLBroadcaster : NSObject <FLEventBroadcaster> {
@private
    FLEventBroadcaster* _eventBroadcaster;
}

@property (readonly, strong) FLEventBroadcaster* events;

@end


