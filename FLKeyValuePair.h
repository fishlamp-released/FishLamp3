//
//	OMKeyValuePair.h
//	FishLamp
//
//	Created By Mike Fullerton on 4/23/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@interface FLKeyValuePair : NSObject {
@private
	id _key;
	id _value;
}

- (id) initWithKey:(id) key value:(id) value;

+ (FLKeyValuePair*) keyValuePair:(id) key value:(id) value;

@property (readwrite, retain, nonatomic) id key;
@property (readwrite, retain, nonatomic) id value;

@end



