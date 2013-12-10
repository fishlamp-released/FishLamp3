//
//  FLLocalNotification.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#if __MAC_10_8
#import "FishLampMinimum.h"

@interface FLLocalNotification : NSObject {
@private
    NSString* _name;
    NSString* _subtitle;
    NSString* _informativeText;
}

- (id) initWithName:(NSString*) name;
+ (id) localNotificationWithName:(NSString*) name;

@property (readwrite, strong, nonatomic) NSString* name;
@property (readwrite, strong, nonatomic) NSString* subtitle;
@property (readwrite, strong, nonatomic) NSString* informativeText;

- (void) deliverNotification;

@end
#endif
