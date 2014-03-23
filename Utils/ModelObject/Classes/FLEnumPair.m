//
//  FLEnumPair.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLEnumPair.h"


@implementation FLEnumPair 
@synthesize enumName = _enumName;
@synthesize enumValue = _enumValue;

- (id) initWithName:(NSString*) enumName enumValue:(NSInteger) enumValue {	
	self = [super init];
	if(self) {
		_enumName = [enumName copy];
        _enumValue = enumValue;
	}
	return self;
}

+ (id) enumPair:(NSString*) enumName enumValue:(NSInteger) enumValue {
    return FLAutorelease([[[self class] alloc] initWithName:enumName enumValue:enumValue]);
}

#if FL_MRC
- (void) dealloc {
	[_enumName release];
	[super dealloc];
}
#endif

@end
