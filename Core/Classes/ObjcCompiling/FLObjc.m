//
//  FLObjc.m
//  FishLampCore
//
//  Created by Mike Fullerton on 6/23/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjc.h"

id FLCopyOrRetainObject(id src) {	
	if([src conformsToProtocol:@protocol(NSMutableCopying)]) {
		return FLAutorelease([src mutableCopy]);
	}
	else if([src conformsToProtocol:@protocol(NSCopying)]) {
		return FLAutorelease([src copy]);
	}

	return FLAutorelease(FLRetain(src));
}
