//
//  FLTimer.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/25/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "NSError+FLTimeout.h"
#import "FLCallback_t.h"

#define FLTimerDefaultCheckTimestampInterval 1.0f

@interface FLTimer : NSObject {
@private
    NSTimeInterval _timestamp;
    NSTimeInterval _timeoutInterval;
    NSTimeInterval _checkTimestampInterval;
    NSTimeInterval _startTime;
    NSTimeInterval _endTime;
    
    BOOL _timedOut;
    BOOL _timing;
    dispatch_source_t _timer;
    
    __unsafe_unretained id _delegate;
    SEL _timerDidTimeout;
    SEL _timerWasUpdated;
    
    FLCallback* _intermediary;
    
    NSInteger _updateCount;
}

// config
@property (readwrite, assign) NSTimeInterval timeoutInterval;
@property (readwrite, assign) NSTimeInterval checkTimestampInterval;

// info
@property (readonly, assign) NSTimeInterval startTime;
@property (readonly, assign) NSTimeInterval elapsedTime;
@property (readonly, assign) NSTimeInterval idleDuration;
@property (readonly, assign) BOOL timedOut;

// delegate
@property (readwrite, assign, nonatomic) id delegate;
@property (readwrite, assign, nonatomic) SEL timerDidTimeout;
@property (readwrite, assign, nonatomic) SEL timerWasUpdated;

// timer control
@property (readonly, assign, getter=isTiming) BOOL timing;
- (void) startTimer;
- (void) stopTimer;
- (void) restartTimer;

// last activity
@property (readonly, assign) NSTimeInterval timestamp;
- (void) touchTimestamp;

// construction
- (id) initWithTimeout:(NSTimeInterval) timeout;
+ (FLTimer*) timer;
+ (FLTimer*) timer:(NSTimeInterval) timeout;


// optional override
- (void) didTimeout;
@end

@protocol FLTimerDelegate <NSObject>
- (void) timerDidTimeout:(FLTimer*) timer;

@optional
- (void) timerWasUpdated:(FLTimer*) timer;
@end

extern NSString* const FLTimedOutNotification;

@interface FLBroadcastingTimer : FLTimer {
}

@end