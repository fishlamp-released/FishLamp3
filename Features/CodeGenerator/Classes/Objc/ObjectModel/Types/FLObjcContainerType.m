//
//  FLObjcContainerType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcContainerType.h"

@implementation FLObjcContainerType
@synthesize containerSubTypes = _containerSubTypes;

- (id) init {	
	self = [super init];
	if(self) {
		_containerSubTypes = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (id) objcContainerType {
    return FLAutorelease([[[self class] alloc] init]);
}


#if FL_MRC
- (void) dealloc {
	[_containerSubTypes release];
	[super dealloc];
}
#endif

- (void) addContainerSubType:(FLObjcContainerSubType*) subType {
    [_containerSubTypes addObject:subType];
}

@end
