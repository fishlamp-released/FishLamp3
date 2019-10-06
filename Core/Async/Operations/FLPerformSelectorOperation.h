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

@interface FLPerformSelectorOperation : FLOperation

@property (readonly, weak, nonatomic) id target;
@property (readonly, assign, nonatomic) SEL action;

- (void) setCallback:(id) target action:(SEL) action; // target is NOT retained

- (id) initWithTarget:(id) target action:(SEL) action; // target is NOT retained

+ (id) performSelectorOperation:(id) target action:(SEL) action; // target is NOT retained

@end
