//
//  FLTimedObject.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

#import "FLTimer.h"

@interface FLTimedObject : NSObject {
@private
    FLTimer* _timeoutTimer;
}

@property (readonly, strong) FLTimer* timeoutTimer;
- (void) touchTimestamp;

// override. by default this stops the timer.
- (void) timeoutTimerDidTimeout:(FLTimer*) timer;

@end



