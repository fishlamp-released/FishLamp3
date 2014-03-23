//
//  FLServiceList.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/2/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLServiceList.h"

@implementation FLServiceList

@synthesize services = _services;

+ (id) serviceList {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id) init {	
	self = [super init];
	if(self) {
		_services = [[NSMutableArray alloc] init];
	}
	return self;
}

#if FL_MRC
- (void) dealloc {
    [_services release];
    [super dealloc];
}
#endif

- (BOOL) canOpenService {
    return YES;
}

- (BOOL) hasOpenService {
    for(id<FLService> service in _services) {
        if(service.isServiceOpen) {
            return YES;
        }
    }

    return NO;
}

- (void) closeServices {

    for(id<FLService> service in _services) {
        if([service isServiceOpen]) {
            [service closeService];
        }
    }
}

- (void) addService:(id<FLService>) service {
    [_services addObject:service];
}

- (void) removeService:(id<FLService>) service {
    [_services removeObject:service];
}

- (void) removeAllServices {
    [_services removeAllObjects];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_services countByEnumeratingWithState:state objects:buffer count:len];
}

@end
