//
//  FLNetworkActivity.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/23/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLBroadcaster.h"

@protocol FLNetworkActivityState;

@interface FLNetworkActivity : FLBroadcaster {
@private
    NSInteger _busyCount;
    BOOL _busy;
    NSTimeInterval _lastChange;
}

@property (readonly, assign, getter=isBusy) BOOL isBusy;

- (id<FLNetworkActivityState>) setBusy;

@end

@interface FLGlobalNetworkActivity : FLNetworkActivity
FLSingletonProperty(FLGlobalNetworkActivity);
@end

@protocol FLNetworkActivityState <NSObject>
@property (readonly, assign) BOOL isBusy;
- (void) setNotBusy;
@end

@protocol FLNetworkActivityEvents <NSObject>
- (void) networkActivityDidStart:(FLNetworkActivity*) networkActivity;
- (void) networkActivityDidStop:(FLNetworkActivity*) networkActivity;
@end