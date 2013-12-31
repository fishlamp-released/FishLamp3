//
//	FLPerformSelectorOperation.h
//	FishLamp
//
//	Created by Mike Fullerton on 9/22/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLOperation.h"

@interface FLPerformSelectorOperation : FLOperation {
@private
	__unsafe_unretained id _target;
    SEL _action;
}

- (void) setCallback:(id) target action:(SEL) action; // target is NOT retained

- (id) initWithTarget:(id) target action:(SEL) action; // target is NOT retained

+ (id) performSelectorOperation:(id) target action:(SEL) action; // target is NOT retained

@end
