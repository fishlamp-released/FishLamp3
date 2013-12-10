//
//  FLNotificationListener.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLNotificationListener.h"
#import "FLSelectorPerforming.h"

@interface FLNotificationListener ()
@property (readwrite, assign, nonatomic) id sender;
@property (readwrite, strong, nonatomic) NSString* parameterKey;
@property (readwrite, strong, nonatomic) NSString* eventName;
@property (readwrite, assign, nonatomic) SEL action;
@property (readwrite, assign, nonatomic) id target;
@end

@implementation FLNotificationListener
@synthesize target = _target;
@synthesize sender = _sender;
@synthesize eventName = _eventName;
@synthesize parameterKey = _parameterKey;
@synthesize action = _action;

- (id) initWithEventName:(NSString*) eventName {
    return [self initWithEventName:eventName sender:nil parameterKey:nil];
}

- (id) initWithEventName:(NSString*) eventName sender:(id) sender {
    return [self initWithEventName:eventName sender:sender parameterKey:nil];
}

- (id) initWithEventName:(NSString*) eventName parameterKey:(NSString*) parameterKey {
    return [self initWithEventName:eventName sender:nil parameterKey:parameterKey];
}

- (id) initWithEventName:(NSString*) eventName sender:(id) sender parameterKey:(NSString*) parameterKey {
	self = [super init];
	if(self) {
        self.eventName = eventName;
        self.parameterKey = parameterKey;
        self.sender = sender;
	}
	return self;
}

+ (id) notificationListener:(NSString*) eventName {
    return FLAutorelease([[[self class] alloc] initWithEventName:eventName sender:nil parameterKey:nil]);
}

+ (id) notificationListener:(NSString*) eventName sender:(id) sender{
    return FLAutorelease([[[self class] alloc] initWithEventName:eventName sender:sender parameterKey:nil]);
}

+ (id) notificationListener:(NSString*) eventName parameterKey:(NSString*) parameterKey{
    return FLAutorelease([[[self class] alloc] initWithEventName:eventName sender:nil parameterKey:parameterKey]);
}

+ (id) notificationListener:(NSString*) eventName sender:(id) sender parameterKey:(NSString*) parameterKey{
    return FLAutorelease([[[self class] alloc] initWithEventName:eventName sender:sender parameterKey:parameterKey]);
}

- (void) setEventName:(NSString*) eventName withSender:(id) sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.eventName = eventName;
    self.sender = sender;
}

- (void) setAction:(SEL) action withParameterKey:(NSString*) parameterKey {
    self.action = action;
    self.parameterKey = parameterKey;
}

- (void) receiveEvent:(NSNotification*) note {
    if(self.parameterKey) {
        id parameter = [[note userInfo] objectForKey:self.parameterKey];
        FLPerformSelector1(_target, _action, parameter);
    }
    else {
        FLPerformSelector1(_target, _action, [note userInfo]);
    }
}

- (void) removeTarget {
    [self setTarget:nil action:nil];
}

- (void) setTarget:(id) target action:(SEL) action {
    
    if(_registered) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        _registered = NO;
    }
    
    self.target = target;
    self.action = action;
    
    if(target && action) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEvent:) name:self.eventName object:self.sender];
        _registered = YES;
    }
}


- (void) dealloc {
    if(_registered) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }

#if FL_MRC
	[_eventName release];
    [_parameterKey release];
    [super dealloc];
#endif
}

@end



//@implementation FLBatchNotificationListener
//
//
//- (id) initWithTarget:(id) target {
//    self = [super init];
//}
//
//- (void) addAction:(SEL) action forEvent:(NSString*) event {
//}
//
//
//- (void) addAction:(SEL) action forEvent:(NSString*) event withParameterKey:(id) key;
//
//
//- (void) removeAllActions {
//    for(NSString* key in _actions) {
//        FLNotificationDescriptor* note = [_actions objectForKey:key]; 
//    }
//    
//    [_actions removeAllObjects];
//}
//
//- (void) dealloc {
//    [self removeAllActions];
//
//#if FL_MRC
//	[_actions release];
//	[super dealloc];
//#endif
//}
//
//
//@end
