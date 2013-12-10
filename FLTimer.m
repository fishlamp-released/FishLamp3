//
//  FLTimer.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/25/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTimer.h"

#define TRACE 0


NSString* const FLTimedOutNotification = @"FLTimedOutNotification";

@interface FLTimer ()
@property (readwrite, assign) NSTimeInterval startTime;
@property (readwrite, assign) NSTimeInterval endTime;
@property (readwrite, assign) BOOL timedOut;
@property (readwrite, assign) NSTimeInterval timestamp;
@property (readwrite, assign, getter=isTiming) BOOL timing;
- (void) checkForTimeout;
@end

@implementation FLTimer
@synthesize timeoutInterval = _timeoutInterval;
@synthesize timestamp = _timestamp;
@synthesize timedOut = _timedOut;
@synthesize checkTimestampInterval = _checkTimestampInterval;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize timing = _timing;

@synthesize delegate = _delegate;
@synthesize timerDidTimeout = _timerDidTimeout;
@synthesize timerWasUpdated = _timerWasUpdated;

- (id) init {
    return [self initWithTimeout:0];
}

- (id) initWithTimeout:(NSTimeInterval) interval {
    self = [super init];
    if(self) {
        self.checkTimestampInterval = FLTimerDefaultCheckTimestampInterval;
        self.timeoutInterval = interval;
        self.timerDidTimeout = @selector(timerDidTimeout:);
        self.timerWasUpdated = @selector(timerWasUpdated:);
        
        _intermediary = [[FLCallbackWithUnretainedTarget alloc] initWithTarget:self action:@selector(checkForTimeout)];
    }
    return self;
}

- (NSTimeInterval) idleDuration {
    return [NSDate timeIntervalSinceReferenceDate] - self.timestamp;
}

+ (FLTimer*) timer:(NSTimeInterval) timeoutInterval {
    return FLAutorelease([[[self class] alloc] initWithTimeout:timeoutInterval]);
}

+ (id) timer {
    return FLAutorelease([[[self class] alloc] init]);
}

- (BOOL) isLate {
    return ((_timeoutInterval > 0.0f) && (self.idleDuration > _timeoutInterval));
}

- (void) didTimeout {
    self.timedOut = YES;
    [self stopTimer];
            
    [self.delegate timerDidTimeout:self];
}

- (void) checkForTimeout {
    
    
#if TRACE
    FLLog(@"checked for timeout: %d, elapsed time: %f", _updateCount, self.idleDuration);
#endif
    ++_updateCount;
    
    FLPerformSelector1(_delegate, _timerWasUpdated, self);

    if(self.isLate) {
        [self didTimeout];
    }
}

- (NSTimeInterval) elapsedTime {
    return self.isTiming ? 
        [NSDate timeIntervalSinceReferenceDate] - self.startTime :
        self.endTime - self.startTime;
}

   
- (void) startTimer {
    self.timedOut = NO;
    self.timing = YES;
    self.startTime = [NSDate timeIntervalSinceReferenceDate];
    self.endTime = 0;
    
    [self stopTimer];
    [self touchTimestamp];

    dispatch_queue_t queue = dispatch_get_global_queue(
                                    DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    // create our timer source
    _timer = dispatch_source_create(
                       DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                       queue);

    // set the time to fire (we're only going to fire once,
    // so just fill in the initial time).
    dispatch_source_set_timer(_timer,
           dispatch_time(DISPATCH_TIME_NOW, _checkTimestampInterval * NSEC_PER_SEC),
           _checkTimestampInterval * NSEC_PER_SEC, 
           0);

    FLCallback* callback = FLRetainWithAutorelease(_intermediary);

    // Hey, let's actually do something when the timer fires!
    dispatch_source_set_event_handler(_timer, ^{
        [callback perform];
    });

    // now that our timer is all set to go, start it
    dispatch_resume(_timer);
    
}

- (void) killTimer {
    if(_timer) {
        dispatch_source_cancel(_timer);
        FLDispatchRelease(_timer);
    }
    _timer = nil;
}

- (void) dealloc  {
    _intermediary.target = nil;
    [self killTimer];
    
#if FL_MRC
    [_intermediary release];
    [super dealloc];
#endif
}

- (void) stopTimer {
    [self killTimer];
    self.timing = NO;
    self.endTime = [NSDate timeIntervalSinceReferenceDate];
}

- (void) restartTimer {
    [self stopTimer];
    [self startTimer];
}

- (void) touchTimestamp {
    self.timestamp = [NSDate timeIntervalSinceReferenceDate];
}

#if 0
- (void) _checkForIdleEvent:(NSTimeInterval) idleDuration {
    
    if(idleDuration <= 1.0 && self.isIdle) {
        self.idle = NO;
        [self connectionIsIdle:0];
    }

    if(idleDuration > 1.0f) {
        self.idle = YES;
        [self connectionIsIdle:idleDuration];
    }
}

- (void) connectionIsIdle:(NSTimeInterval) idleDuration {
    [self visitObservers:^(id observer, BOOL* stop) {
        if([observer respondsToSelector:@selector(networkConnection:idleSince:idleDuration:)]) {
            [observer networkConnection:self idleSince:self.lastActivityTimestamp idleDuration:idleDuration];
        }
    }];
}

#endif


@end

@implementation FLBroadcastingTimer

- (void) didTimeout {
    [super didTimeout];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FLTimedOutNotification object:self];
    });
}

@end


