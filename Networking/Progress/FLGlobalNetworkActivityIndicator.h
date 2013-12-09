//
//  FLGlobalNetworkActivityIndicator.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/23/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

extern NSString* const FLGlobalNetworkActivityShow;
extern NSString* const FLGlobalNetworkActivityHide;

extern NSString* const FLNetworkActivityStartedNotification;
extern NSString* const FLNetworkActivityStoppedNotification;
extern NSString* const FLNetworkActivitySenderKey;

@interface FLGlobalNetworkActivityIndicator : NSObject {
@private
    NSInteger _busyCount;
    BOOL _busy;
    NSTimeInterval _lastChange;
}
FLSingletonProperty(FLGlobalNetworkActivityIndicator);

@property (readwrite, assign, getter=isNetworkBusy) BOOL networkBusy;

@end

