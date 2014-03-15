//
//  FLWriteStream.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/27/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLNetworkStream.h"

@protocol FLWriteStreamDelegate;

@interface FLWriteStream : FLNetworkStream {
@private
 	CFWriteStreamRef _streamRef;
}

@property (readonly, assign) BOOL canAcceptBytes;
@property (readonly, assign, nonatomic) CFWriteStreamRef streamRef;
@property (readonly, assign) unsigned long bytesWritten;

- (id) initWithWriteStream:(CFWriteStreamRef) streamRef;
+ (id) writeStream:(CFWriteStreamRef) streamRef;

- (void) writeData:(NSData*) data;
- (void) writeBytes:(const uint8_t*) bytes length:(unsigned long) length;


@end
