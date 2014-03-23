//
//	FLBase64Encoding.m
//	FishLamp
//
//	Created By Mike Fullerton on 4/23/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLBase64Encoding.h"
#import "Base64Transcoder.h"
#import <CommonCrypto/CommonDigest.h>

//@interface NSData (Base64Encoding)
//
//
////- (NSData*) base64Decode; // returns autoreleased NSData
////- (void) base64Encode:(NSData**) outData;
////
////- (NSData*) base64Encode; // returns autoreleased NSData
////- (void) base64Decode:(NSData**) outData;
////
////// strings
////- (void) base64EncodeToString:(NSString**) outString;
////+ (void)base64DecodeString:(NSString*) str	outData:(NSData**) outData;
////+ (NSData*)base64DecodeString:(NSString*) str;
//
//@end

@implementation NSData (Base64Encoding)

- (NSData*) base64Encode {
	
    if(self.length == 0) {
        return self;
	}

	char* buffer = nil;
	@try {
		size_t encodedSize = EstimateBas64EncodedDataSize(self.length);
		buffer = malloc(encodedSize);
	   
		if(Base64EncodeData(self.bytes, self.length, buffer, &encodedSize)) {
            return FLAutorelease([[NSData alloc] initWithBytes:buffer length:encodedSize]);
        }
		
        FLThrowIfError([NSError errorWithDomain:NSCocoaErrorDomain code:NSFormattingError userInfo:nil]);
	}
	@finally {
		if(buffer){
			free(buffer);
		}
	}
}

- (NSData*) base64Decode {
	if(self.length == 0) {
        return self;
	}

	char* buffer = nil;
	@try
	{
		size_t decodedSize = EstimateBas64DecodedDataSize(self.length);
		buffer = malloc(decodedSize);
		if(Base64DecodeData(self.bytes, self.length, buffer, &decodedSize)) {
            return FLAutorelease([[NSData alloc] initWithBytes:buffer length:decodedSize]);
		}

        FLThrowIfError([NSError errorWithDomain:NSCocoaErrorDomain code:NSFormattingError userInfo:nil]);
	}
	@finally {
		if(buffer) {
			free(buffer);
		}
	}
}

//+ (NSData*) decodedDataFromBase64EncodedString:(NSString*) string {
//	return [NSData decodedDataFromBase64EncodedData:[string dataUsingEncoding: NSASCIIStringEncoding]];
//}

//- (void) base64EncodeToString:(NSString**) outString
//{
//	NSData* encoded = nil; 
//	
//	@try
//	{
//		[self base64Encode:&encoded];
//	
//		*outString = [[NSString alloc] initWithBytes:[encoded bytes] 
//									length:[encoded length] 
//									encoding:NSASCIIStringEncoding];
//	}
//	@finally
//	{
//		FLReleaseWithNil(encoded);
//	}
//}

- (NSData*) SHA256Hash {
//    NSMutableData* tempData = FLAutorelease([[NSMutableData alloc] initWithData:self]);
//    [tempData appendData:rhs];
    
    const char hash[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256((char*) [self bytes],
              (unsigned int) [self length], 
              (unsigned char*) hash);

    return FLAutorelease([[NSData alloc] initWithBytes:hash length:CC_SHA256_DIGEST_LENGTH]);
}

- (NSData*) dataWithAppendedData:(NSData*) data {
    NSMutableData* newData = FLAutorelease([self mutableCopy]);
    [newData appendData:data];
    return newData;
}

@end

@implementation NSString (Base64Encoding)

- (NSData*) asciiData {
    return [self dataUsingEncoding:NSASCIIStringEncoding];
}

+ (NSString*) stringWithAsciiData:(NSData*) data {
    return FLAutorelease([[NSString alloc] initWithBytes:[data bytes] 
                                                  length:[data length] 
                                                encoding:NSASCIIStringEncoding]);
}

- (NSData*) base64Decode {
    return [[self asciiData] base64Decode];
}


@end