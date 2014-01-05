//
//  FLNetworkActivity.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/23/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLNetworkActivity.h"
#import "FishLampSimpleLogger.h"

@interface FLNetworkActivityState : NSObject<FLNetworkActivityState> {
@private
    FLNetworkActivity* _activity;
}
+ (id) networkActivityState:(FLNetworkActivity*) activity;
@end

@interface FLNetworkActivity()
@property (readwrite, assign, getter=isBusy) BOOL busy;
@end

#define kPostDelay 1.0f

@implementation FLNetworkActivity

@synthesize busy = _busy;

- (void) updateListeners {
    if(_busy && _busyCount <= 0) {

        if(([NSDate timeIntervalSinceReferenceDate] - _lastChange) > 0.3) {
            _busyCount = 0; // i've seen it go to -1
            _busy = NO;
            FLTrace(@"hiding global network indicator");

            [self sendMessageToListeners:@selector(networkActivityDidStop:) withObject:self];
        }
        else {  
        
            FLTrace(@"delaying update listeners");

            __block id selfForBlock = FLRetain(self);

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [selfForBlock updateListeners];
                FLReleaseWithNil(selfForBlock);
                });
        }
    }
    else if(!_busy && _busyCount > 0) {
        _busy = YES;
        FLTrace(@"showing global network indicator");
        [self sendMessageToListeners:@selector(networkActivityDidStart:) withObject:self];
    }
    else {
        FLTrace(@"nothing happending in update listeners");
    }
}

- (void) changeBusyState:(BOOL) busy {
    dispatch_async(dispatch_get_main_queue(), ^{
        _busyCount += (busy ? 1 : -1);
        _lastChange = [NSDate timeIntervalSinceReferenceDate];
        FLTrace(@"busy count: %d", self.busyCount);
        [self updateListeners];
    });
}

- (id<FLNetworkActivityState>) setBusy {
    [self changeBusyState:YES];
    return [FLNetworkActivityState networkActivityState:self];
}


@end

@implementation FLGlobalNetworkActivity
FLSynthesizeSingleton(FLNetworkActivity);
@end

@implementation FLNetworkActivityState

- (BOOL) isBusy {
    return _activity != nil;
}

- (id) initWithActivity:(FLNetworkActivity*) activity {
	self = [super init];
	if(self) {
		_activity = FLRetain(activity);
	}
	return self;
}

+ (id) networkActivityState:(FLNetworkActivity*) activity {
    return FLAutorelease([[[self class] alloc] initWithActivity:activity]);
}

- (void) setNotBusy {
    if(_activity) {
        FLNetworkActivity* activity = nil;
        @synchronized(self) {
            if(_activity) {
                activity = _activity;
                _activity = nil;
            }
        }
        if(activity) {
            [activity changeBusyState:NO];
            FLReleaseWithNil(activity);
        }
    }
}

- (void)dealloc {
    [self setNotBusy];
#if FL_MRC

	[super dealloc];
#endif
}
@end

