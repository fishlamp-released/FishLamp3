//
//  FLLengthyOperation.m
//  Pods
//
//  Created by Mike Fullerton on 2/17/14.
//
//

#import "FLLengthyOperation.h"

#import "FLTimer.h"

@interface FLLengthyOperation ()
@property (readwrite, strong) FLTimer* timer;
@end

@implementation FLLengthyOperation

@synthesize timer =_timer;

- (id) init {	
	self = [super init];
	if(self) {
        _timer = [[FLTimer alloc] init];
        _timer.delegate = self;
	}
	return self;
}

- (void) dealloc {
    _timer.delegate = nil;
#if FL_MRC
    [_timer release];
    [super dealloc];
#endif
}

- (void) setTimeoutInterval:(NSTimeInterval) timeoutInterval {
    self.timer.timeoutInterval = timeoutInterval;
}

- (NSTimeInterval) timeoutInterval {
    return self.timer.timeoutInterval;
}

- (void) startTimeoutTimer {

    FLTimer* timer = self.timer;
    if(!timer) {
        timer = [FLTimer timer];
        timer.delegate = self;
        self.timer = timer;
    }

    [timer startTimer];
}

- (void) stopTimeoutTimer {
    [self.timer stopTimer];
}

- (void) updateActivityTimestamp {
    FLAssertNotNil(self.timer);
    [self.timer  touchTimestamp];
}

- (void) timerWasUpdated:(FLTimer*) timer {

#if DEBUG
//    if(timer.idleDuration - self.idleDuration > 5.0f) {
//        FLDebugLog(@"Server hasn't responded for %f seconds (%@)", timer.idleDuration, self.identifier);
//        self.idleDuration = timer.idleDuration;
//    }
#endif
}

- (void) operationDidTimeout {

}

- (void) timerDidTimeout:(FLTimer*) timer {
    [self operationDidTimeout];
}

@end
