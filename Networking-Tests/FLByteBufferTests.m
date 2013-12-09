//
//  FLByteBufferTests.m
//  FishLamp
//
//  Created by Mike Fullerton on 9/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLByteBufferTests.h"
#import "FLByteBuffer.h"

FLDeclareFixedSizedBuffer(2)
FLSynthesizeFixedSizedBuffer(2)



@implementation FLByteBufferTests


//+ (Class) testGroupClass {
//    return @"FishLampNetworking";
//}

- (void) testSimpleCopy {
    
    FLByteBuffer* buffer = [FLByteBuffer128 byteBuffer];
    
    const char* str = "hello world";

    [buffer appendBytes:str length:strlen(str)];
    
    FLAssert(buffer.length == strlen(str));
    
    FLAssertWithComment(strncmp(str, (char*)buffer.content, strlen(str)) == 0, @"buffer write failed");
    
}

- (void) testTooSmall {
    
    FLByteBuffer* buffer = [FLByteBuffer2 byteBuffer];
    
    const char* str = "hello world";

    [buffer appendBytes:str length:strlen(str)];
    FLAssert(buffer.length == 2);
    
    FLAssertWithComment(strncmp(str, (char*)buffer.content, 2) == 0,@"buffer write failed");
    
}




@end
