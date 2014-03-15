//
//  FLLogSink.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampRequired.h"
#import "FLStringFormatter.h"
#import "FLLogSinkBehavior.h"

@class FLLogEntry;

@protocol FLLogSink <NSObject>
- (void) logEntry:(FLLogEntry*) entry stopPropagating:(BOOL*) stop;

- (void) indent:(FLIndentIntegrity*) integrity;
- (void) outdent:(FLIndentIntegrity*) integrity;

- (void) updateLogSinkBehavior:(id<FLLogSinkBehavior>) behavior;

@end

@interface FLLogSink : NSObject<FLLogSink> {
@private
    id<FLLogSinkBehavior> _behavior;
}

- (id) initWithBehavior:(id<FLLogSinkBehavior>) behavior;

@property (readwrite, strong) id<FLLogSinkBehavior> behavior;
@end


