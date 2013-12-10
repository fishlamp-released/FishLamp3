//
//  FLTestResultLogEntry.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/10/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTestResultLogEntry.h"
#import "FishLampCore.h"
#import "FLStackTrace.h"

@implementation FLTestResultLogEntry

@synthesize line = _line;
@synthesize stackTrace = _stackTrace;

- (id) initWithLine:(NSString*) line
        stackTrace:(FLStackTrace*) stackTrace {
    self = [super init];
    if(self) {
        _line = FLRetain(line);
        _stackTrace = FLRetain(stackTrace);
    }

    return self;
}

+ (id) testResultLogEntry:(NSString*) line
               stackTrace:(FLStackTrace*) stackTrace {
   return FLAutorelease([[[self class] alloc] initWithLine:line stackTrace:stackTrace]);
}

#if FL_MRC
- (void)dealloc {
	[_line release];
    [_stackTrace release];
	[super dealloc];
}
#endif

- (NSString*) description {
    return [self prettyDescription];
}

- (void) prettyDescription:(id<FLStringFormatter>)stringFormatter  {
    [stringFormatter appendLineWithFormat:self.line];
    if(self.stackTrace) {
        [stringFormatter appendPrettyDescriptionForObject:self.stackTrace];
    }
}


@end