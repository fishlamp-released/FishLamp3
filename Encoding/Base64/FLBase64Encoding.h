//
//	FLBase64Encoding.h
//	FishLamp
//
//	Created By Mike Fullerton on 4/23/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@interface NSString (Base64Encoding)
- (NSData*) asciiData;
+ (NSString*) stringWithAsciiData:(NSData*) data;

- (NSData*) base64Decode;

@end

@interface NSData (Base64Encoding)

- (NSData*) base64Decode;
- (NSData*) base64Encode;

- (NSData*) SHA256Hash;

- (NSData*) dataWithAppendedData:(NSData*) data;

@end
