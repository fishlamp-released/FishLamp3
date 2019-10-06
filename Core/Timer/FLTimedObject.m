//
//  FLTimedObject.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTimedObject.h"

@interface FLTimedObject ()
@property (readwrite, strong) FLTimer* timeoutTimer;
@end

@implementation FLTimedObject

@synthesize timeoutTimer = _timeoutTimer;

- (id) init {
    self = [super init];
    if(self) {
        self.timeoutTimer = [FLTimer timer];
        self.timeoutTimer.delegate = self;
        self.timeoutTimer.timerDidTimeout = @selector(timeoutTimerDidTimeout:);
    }
    return self;
}

- (void) dealloc {
    _timeoutTimer.delegate = nil;

#if FL_MRC
    [_timeoutTimer release];
    [super dealloc];
#endif
}

- (void) timeoutTimerDidTimeout:(FLTimer*) timer {
    [timer stopTimer];
}

- (void) touchTimestamp {
    [self.timeoutTimer touchTimestamp];
}

@end
