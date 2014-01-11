//
//  FLObjcEnumValueType.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcEnumValueType.h"

@implementation FLObjcEnumValueType
@synthesize enumValue = _enumValue;
#if FL_MRC
- (void) dealloc {
//	[_enumValue release];
	[super dealloc];
}
#endif

- (id) initWithName:(FLObjcName*) name value:(NSUInteger) value {	
	self = [super initWithTypeName:name importFileName:nil];
	if(self) {
		self.enumValue = value;
	}
	return self;
}

+ (id) objcEnumValue:(FLObjcName*) name value:(NSUInteger) value {
    return FLAutorelease([[[self class] alloc] initWithName:name value:value]);
}

@end