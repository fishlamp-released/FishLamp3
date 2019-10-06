//
//  FLBufferedLogSink.m
//  Pods
//
//  Created by Mike Fullerton on 2/23/14.
//
//

#import "FLBufferedLogSink.h"

@implementation FLBufferedLogSink

/*
    double delayInSeconds = kDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
*/

- (void) logEntry:(FLLogEntry*) entry stopPropagating:(BOOL*) stop {
}

- (void) indent:(FLIndentIntegrity*) integrity {
}

- (void) outdent:(FLIndentIntegrity*) integrity {
}


@end
