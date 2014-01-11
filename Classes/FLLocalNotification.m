//
//  FLLocalNotification.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#if __MAC_10_8
#import "FLLocalNotification.h"

@interface FLLocalNotification ()
@end

@implementation FLLocalNotification

@synthesize name = _name;
@synthesize subtitle = _subtitle;
@synthesize informativeText = _informativeText;

- (id) initWithName:(NSString*) name {
    self = [super init];
    if(self) {
        self.name = name;
    }
    return self;
}

+ (id) localNotificationWithName:(NSString*) name {
    return FLAutorelease([[[self class] alloc] initWithName:name]);
}

#if FL_MRC
- (void) dealloc {
    [_name release];
    [super dealloc];
}
#endif

- (void) deliverNotification {

#if OSX
    if(OSXVersionIsAtLeast10_8()) {
        NSUserNotification* userNotification = FLAutorelease([[NSUserNotification alloc] init]);
        userNotification.title = self.name;
        userNotification.subtitle = self.subtitle;
        userNotification.informativeText = self.informativeText;
        
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:userNotification];
    }
#else

#endif    

}

@end
#endif