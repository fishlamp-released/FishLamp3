//
//  FLService.h
//  FLCore
//
//  Created by Mike Fullerton on 11/2/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLBroadcaster.h"
//#import "FishLampAsync.h"
//
//extern NSString* const FLServiceDidCloseNotificationKey;
//extern NSString* const FLServiceDidOpenNotificationKey;

@protocol FLService <NSObject, FLBroadcaster>
@property (readonly, assign) BOOL canOpenService;
@property (readonly, assign) BOOL isServiceOpen;
- (void) openService;
- (void) closeService;
@end

@interface FLService : FLBroadcaster<FLService> {
@private
    BOOL _isServiceOpen;
}
@end


