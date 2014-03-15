//
//	OMKeyValuePair.m
//	FishLamp
//
//	Created by Mike Fullerton on 6/19/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLKeyValuePair.h"

@implementation FLKeyValuePair

@synthesize key = _key;
@synthesize value = _value;

- (id) initWithKey:(id) key value:(id) value {
	self.key = key;
	self.value = value;
	return self;
}

+ (FLKeyValuePair*) keyValuePair:(id) key value:(id) value {
	return FLAutorelease([[FLKeyValuePair alloc] initWithKey:key value:value]);
}

#if FL_MRC
- (void) dealloc {
    FLRelease(_key);
    FLRelease(_value);
	FLSuperDealloc();
}
#endif


@end
