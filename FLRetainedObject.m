//
//  FLRetainedObject.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLRetainedObject.h"

@implementation FLRetainedObject

@synthesize containedObject = _containedObject;

- (id) initWithRetainedObject:(id) object {
    _containedObject = FLRetain(object);
	return self;
}

#if FL_MRC
- (void)dealloc {
	[_containedObject release];
	[super dealloc];
}
#endif

+ (id) retainedObject:(id) object {
    return FLAutorelease([[[self class] alloc] initWithRetainedObject:object]);
}

@end
