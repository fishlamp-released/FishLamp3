//
//  FLPrerequisite.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/6/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLPrerequisite.h"

#import "FLObjcRuntime.h"


@implementation FLProtocolPrerequisite

- (id) initWithProtocol:(Protocol*) protocol {
	self = [super init];
	if(self) {
		_protocol = protocol;
	}
	return self;
}

+ (id) protocolPrerequisite:(Protocol*) protocol {
    return FLAutorelease([[[self class] alloc] initWithProtocol:protocol]);
}

- (BOOL) objectMeetsCondition:(id) object {
    if(FLClassConformsToProtocol([object class], _protocol)) {
        return YES;
    }
    
    return NO;
}

@end
