//
//  FLBufferedLogSink.h
//  Pods
//
//  Created by Mike Fullerton on 2/23/14.
//
//

#import "FLLogSink.h"


@protocol FLBufferedLogSinkDelegate;

@interface FLBufferedLogSink : FLLogSink

@end


@protocol FLBufferedLogSinkDelegate <NSObject>
- (void) bufferedLogSinkWasUpdated:(FLBufferedLogSink*) logSink;
@end