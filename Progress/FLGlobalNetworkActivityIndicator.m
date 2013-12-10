//
//  FLGlobalNetworkActivityIndicator.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/23/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLGlobalNetworkActivityIndicator.h"

//#define TRACE 1

NSString* const FLGlobalNetworkActivityShow = @"FLGlobalNetworkActivityShow";
NSString* const FLGlobalNetworkActivityHide = @"FLGlobalNetworkActivityHide";

NSString* const FLNetworkActivityStartedNotification = @"FLNetworkActivityStartedNotification";
NSString* const FLNetworkActivityStoppedNotification = @"FLNetworkActivityStoppedNotification";
NSString* const FLNetworkActivitySenderKey = @"FLNetworkActivitySenderKey";

@interface FLGlobalNetworkActivityIndicator()
@property (readwrite, assign) NSInteger busyCount;
@property (readwrite, assign) NSTimeInterval lastChange;
@property (readwrite, assign) BOOL busy;
@end

#define kPostDelay 1.0f

@implementation FLGlobalNetworkActivityIndicator
@synthesize busyCount = _busyCount;
@synthesize busy = _busy;
@synthesize lastChange = _lastChange;

FLSynthesizeSingleton(FLGlobalNetworkActivityIndicator);

- (void) networkActivityDidStart:(id) sender {
    [self setNetworkBusy:YES];
}

- (void) networkActivityDidFinish:(id) sender {
    [self setNetworkBusy:NO];
}

- (id) init {	
	self = [super init];
	if(self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkActivityDidStart:) name:FLNetworkActivityStartedNotification object:nil];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkActivityDidFinish:) name:FLNetworkActivityStoppedNotification object:nil];
	}
	return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if FL_MRC
	[super dealloc];
#endif
}

- (BOOL) isNetworkBusy {
    return self.busy;
}

- (void) updateListeners {
    if(self.busy && self.busyCount <= 0) {

        if(([NSDate timeIntervalSinceReferenceDate] - self.lastChange) > 0.3) {
            self.busyCount = 0; // i've seen it go to -1
            self.busy = NO;
            FLTrace(@"hiding global network indicator");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FLGlobalNetworkActivityHide object:self];
        }
        else {  
        
            FLTrace(@"delaying update listeners");
            
//            [NSObject cancelPreviousPerformRequestsWithTarget:self];            
//            [self performSelector:@selector(updateListeners) withObject:nil afterDelay:0.5 ];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self updateListeners];
                });
        }
    }
    else if(!self.busy && self.busyCount > 0) {
        self.busy = YES;
        FLTrace(@"showing global network indicator");
        [[NSNotificationCenter defaultCenter] postNotificationName:FLGlobalNetworkActivityShow object:self];
    }
    else {
        FLTrace(@"nothing happending in update listeners");
    }
}

- (void) setNetworkBusy:(BOOL) busy {

    self.busyCount += (busy ? 1 : -1);
    self.lastChange = [NSDate timeIntervalSinceReferenceDate];
    
    FLTrace(@"busy count: %d", self.busyCount);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateListeners];
    });
}

@end