//
//  FLBase64Data.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 7/4/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLBase64Data.h"
#import "FLBase64Encoding.h"

@implementation FLBase64Data

@synthesize decodedData = _decodedData;
@synthesize encodedData = _encodedData;

#if FL_MRC
- (void)dealloc {
	[_decodedData release];
	[_encodedData release];
	[super dealloc];
}
#endif

- (id) initWithEncodedData:(NSData*) data {
	self = [super init];
	if(self) {
		_encodedData = FLRetain(data);
        _decodedData = FLRetain([data base64Decode]);
	}
	return self;
}

- (id) initWithDecodedData:(NSData*) data {
	self = [super init];
	if(self) {
		_decodedData = FLRetain(data);
        _encodedData = FLRetain([data base64Encode]);
	}
	return self;
}

+ (id) base64DataWithEncodedData:(NSData*) data {
    return FLAutorelease([[[self class] alloc] initWithEncodedData:data]);
}

+ (id) base64DataWithDecodedData:(NSData*) data {
    return FLAutorelease([[[self class] alloc] initWithDecodedData:data]);
}


@end
