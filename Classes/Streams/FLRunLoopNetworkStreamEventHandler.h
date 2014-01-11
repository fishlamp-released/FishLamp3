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
    __unsafe_unretained NSRunLoop* _runLoop;
    __unsafe_unretained FLNetworkStream* _stream;
    __unsafe_unretained NSThread* _thread;
}
- (NSString*) runLoopMode;
@end
