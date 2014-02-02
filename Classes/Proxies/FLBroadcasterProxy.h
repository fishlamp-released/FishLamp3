//
//  FLBroadcasterProxy.h
//  Pods
//
//  Created by Mike Fullerton on 1/5/14.
//
//

#import "FishLampCore.h"
#import "FLBroadcaster.h"

@interface FLBroadcasterProxy : NSProxy<FLEventBroadcaster> {
@private
    FLBroadcaster* _broadcaster;
}
- (id) initWithBroadcaster:(FLBroadcaster*) broadcaster;
@end
