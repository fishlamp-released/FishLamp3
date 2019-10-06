//
//  FLLogSink.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLLogSink.h"
#import "FLPrettyString.h"

@implementation FLLogSink

@synthesize behavior = _behavior;

- (id) initWithBehavior:(id<FLLogSinkBehavior>) behavior  {

    self = [super init];
    if(self) {
        _behavior = FLRetain(behavior);
    }
    
    return self;
}

- (id) init {
    return [self initWithBehavior:nil];
}

- (void) updateLogSinkBehavior:(id<FLLogSinkBehavior>) behavior {
    self.behavior = behavior;
}


#if FL_MRC
- (void)dealloc {
	[_behavior release];
	[super dealloc];
}
#endif

- (void) logEntry:(FLLogEntry*) entry stopPropagating:(BOOL*) stop {
}

- (void) indent:(FLIndentIntegrity*) integrity {
}

- (void) outdent:(FLIndentIntegrity*) integrity {
}

@end




