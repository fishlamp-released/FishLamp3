//
//  FLRunLoopNetworkStreamEventHandler.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/15/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLNetworkStream.h"

@interface FLRunLoopNetworkStreamEventHandler : NSObject<FLNetworkStreamEventHandler> {
@private
    FL_WEAK NSRunLoop* _runLoop;
    FL_WEAK FLNetworkStream* _stream;
    FL_WEAK NSThread* _thread;
}
- (NSString*) runLoopMode;
@end
