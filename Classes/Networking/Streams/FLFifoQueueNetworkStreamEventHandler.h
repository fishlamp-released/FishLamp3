//
//  FLFifoQueueNetworkStreamEventHandler.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/15/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLNetworkStream.h"
#import "FLDispatchQueues.h"

@interface FLFifoQueueNetworkStreamEventHandler : NSObject<FLNetworkStreamEventHandler> {
@private
    FLFifoDispatchQueue* _asyncQueue;
    __weak FLNetworkStream* _stream;
}

@property (readonly, strong, nonatomic) FLFifoDispatchQueue* asyncQueue;
@end
