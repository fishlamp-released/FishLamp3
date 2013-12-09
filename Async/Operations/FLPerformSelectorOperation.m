//
//	FLPerformSelectorOperation.m
//	FishLamp
//
//	Created by Mike Fullerton on 9/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPerformSelectorOperation.h"
#import "FishLampAsync.h"

@implementation FLPerformSelectorOperation

- (id) initWithTarget:(id) target action:(SEL) action {
	if((self = [super init])) {
		[self setCallback:target action:action];
	}
	
	return self;
}

+ (id) performSelectorOperation:(id) target action:(SEL) action {
	return FLAutorelease([[[self class] alloc] initWithTarget:target action:action]);
}

- (FLPromisedResult) runSynchronously {
    FLPerformSelector1(_target, _action, self);

    return [FLSuccessfulResult successfulResult];
}

- (void) setCallback:(id) target action:(SEL) action {
	
    _target = target;
    _action = action;
    
	FLAssertWithComment([_target respondsToSelector:_action], @"target doesn't respond to selector");
}
@end

