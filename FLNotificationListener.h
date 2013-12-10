//
//  FLNotificationListener.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/19/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

@interface FLNotificationListener : NSObject {
@private
    __unsafe_unretained id _sender;
    __unsafe_unretained id _target;
    NSString* _eventName;
    NSString* _parameterKey;
    SEL _action;
    BOOL _registered;
}
@property (readonly, assign, nonatomic) id target;
@property (readonly, assign, nonatomic) id sender;
@property (readonly, strong, nonatomic) NSString* parameterKey;
@property (readonly, strong, nonatomic) NSString* eventName;
@property (readonly, assign, nonatomic) SEL action;

- (id) initWithEventName:(NSString*) eventName;
- (id) initWithEventName:(NSString*) eventName sender:(id) sender;
- (id) initWithEventName:(NSString*) eventName parameterKey:(NSString*) parameterKey;
- (id) initWithEventName:(NSString*) eventName sender:(id) sender parameterKey:(NSString*) parameterKey;

+ (id) notificationListener:(NSString*) eventName;
+ (id) notificationListener:(NSString*) eventName sender:(id) sender;
+ (id) notificationListener:(NSString*) eventName parameterKey:(NSString*) parameterKey;
+ (id) notificationListener:(NSString*) eventName sender:(id) sender parameterKey:(NSString*) parameterKey;

- (void) setTarget:(id) target action:(SEL) action;
- (void) removeTarget;

- (void) receiveEvent:(NSNotification*) note;

@end

//
//@interface FLBatchNotificationListener : NSObject {
//@private
//    __unsafe_unretained id _target;
//    NSMutableDictionary* _actions;
//}
//
//- (id) initWithTarget:(id) target;
//
//- (void) setAction:(SEL) action forEvent:(NSString*) event fromSender:(id) sender 
//- (void) setAction:(SEL) action forEvent:(NSString*) event fromSender:(id) sender withParameterKey:(NSString*) key;
//
//addAction:(SEL) action forEvent:(NSString*) event;
//- (void) addAction:(SEL) action forEvent:(NSString*) event withParameterKey:(id) key;
//
//@end
