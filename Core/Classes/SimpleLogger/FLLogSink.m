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

@synthesize outputFlags = _outputFlags;

- (id) initWithOutputFlags:(FLLogSinkOutputFlags) outputFlags  {

    self = [super init];
    if(self) {
        _outputFlags = outputFlags;
    }
    
    return self;
}

- (id) init {
    return [self initWithOutputFlags:0];
}

- (void) logEntry:(FLLogEntry*) entry stopPropagating:(BOOL*) stop {
}

- (void) indent:(FLIndentIntegrity*) integrity {
}

- (void) outdent:(FLIndentIntegrity*) integrity {
}

@end




