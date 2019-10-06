//
//  ZFActivityLogView.m
//  FishLamp
//
//  Created by Mike Fullerton on 3/11/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLActivityLogViewController.h"
#import "FLTextViewLogger.h"
#import "FishLampAsync.h"

#define kInterval 0.15

@implementation FLActivityLogViewController

@synthesize activityLog = _activityLog;

- (id) init {	
	self = [super init];
	if(self) {
		
	}
	return self;
}

- (void) dealloc {
#if FL_MRC
    [_activityLog release];
    [_queue release];
    [super dealloc];
#endif
}

- (void) update {

    if(_queue) {
        [self.logger appendString:_queue];
        [self.textView scrollRangeToVisible:NSMakeRange([[self.textView string] length], 0)];
        FLReleaseWithNil(_queue);
    }

    _lastUpdate = [NSDate timeIntervalSinceReferenceDate];
}

- (void) activityLog:(FLActivityLog*) activityLog
     didAppendString:(NSAttributedString*) string {

    if(string) {

        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(update) object:nil];

        if(!_queue) {
            _queue = [[NSMutableAttributedString alloc] init];
        }

        [_queue appendAttributedString:string];

        if(_lastUpdate + kInterval < [NSDate timeIntervalSinceReferenceDate]) {
            [self update];
        }
        else {
            [self performSelector:@selector(update) withObject:nil afterDelay:kInterval];
        }
    }
}

- (void) activityLogClearActivity:(FLActivityLog*) activityLog {
    [self.logger clearContents];
}

- (void) setActivityLog:(FLActivityLog*) log {

    if(_activityLog) {
        [_activityLog.events removeListener:self];
    }

    FLSetObjectWithRetain(_activityLog, log);

    [self.activityLog.events addListener:self sendEventsOnMainThread:NO];

    [self.logger clearContents];

    // don't think we need this...???
    [self setLinkAttributes];

    [self activityLog:self.activityLog didAppendString:[self.activityLog formattedAttributedString]];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [self.textView setEditable:NO];
}

@end
