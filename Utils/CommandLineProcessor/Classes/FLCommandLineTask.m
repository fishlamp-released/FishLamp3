//
//  FLCommandLineTask.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/18/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCommandLineTask.h"
#import "FishLampAsync.h"

@implementation FLCommandLineTask

@synthesize operations = _operations;

- (id) init {	
	self = [super init];
	if(self) {
		_operations = [[NSMutableArray alloc] init];
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
	[_operations release];
	[super dealloc];
}
#endif

+ (id) commandLineTask {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) queueOperation:(FLOperation*) operation {
    [_operations addObject:operation];
}

- (FLPromisedResult) runSynchronously {

// TODO - run in a context

//    for(FLOperation* operation in _operations) {
//        [self runChildSynchronously:operation];
//    }

    return [FLSuccessfulResult successfulResult];
}


@end
