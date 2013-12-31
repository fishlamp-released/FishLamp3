//
//  FLObjcContainerSubType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcContainerSubType.h"


@implementation FLObjcContainerSubType
@synthesize subTypeName = _subTypeName;
@synthesize objcType = _objcType;

#if FL_MRC
- (void) dealloc {
	[_subTypeName release];
    [_objcType release];
    [super dealloc];
}
#endif

- (id) initWithName:(NSString*) name objcType:(FLObjcType*) objcType {	
	self = [super init];
	if(self) {
		self.subTypeName = name;
        self.objcType = objcType;
	}
	return self;
}

+ (id) objcContainerSubType:(NSString*) name objcType:(FLObjcType*) objcType {
    return FLAutorelease([[[self class] alloc] initWithName:name objcType:objcType]);
}

@end