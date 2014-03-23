//
//  FLTcpRequest.m
//  FishLamp
//
//  Created by Mike Fullerton on 9/5/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTcpRequest.h"
#import "FLReadStream.h"
#import "FLWriteStream.h"

@implementation FLTcpRequest

- (BOOL) readData:(FLReadStream*) reader {
    return NO;
}

- (BOOL) writeData:(FLReadStream*) writer {
    return NO;
}

+ (FLTcpRequest*) tcpNetworkRequest {
    return FLAutorelease([[[self class] alloc] init]);
}


@end