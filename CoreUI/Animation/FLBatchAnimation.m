//
//  FLBatchAnimation.m
//  FishLampCocoaUI
//
//  Created by Mike Fullerton on 3/23/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBatchAnimation.h"

@implementation FLBatchAnimation 

- (id) init {	
	self = [super init];
	if(self) {
		_animations = [[NSMutableArray alloc] init];
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
    [_animations release];
    [super dealloc];
}
#endif

- (void) prepareAnimation:(CALayer*) layer {
    for(FLAnimation* animation in _animations) {
        [animation prepareAnimation:layer];
    }
}

- (void) commitAnimation:(CALayer*) layer {
    for(FLAnimation* animation in _animations) {
        [animation commitAnimation:layer];
    }
}

- (void) finishAnimation:(CALayer*) layer {
    for(FLAnimation* animation in _animations) {
        [animation finishAnimation:layer];
    }
}

- (void) addAnimation:(FLAnimation*) animation {
    animation.parentAnimation = self;
    [_animations addObject:animation];
}

@end
