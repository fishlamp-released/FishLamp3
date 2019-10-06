//
//  FLServiceList.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLService.h"
#import "FLBroadcaster.h"

@interface FLServiceList : FLBroadcaster {
@private
    NSMutableArray* _services;
}

+ (id) serviceList;

@property (readonly, strong) NSArray* services;

@property (readonly, assign) BOOL hasOpenService;

- (void) addService:(id<FLService>) service;
- (void) removeService:(id<FLService>) service;

- (void) closeServices;

- (void) removeAllServices;

@end
