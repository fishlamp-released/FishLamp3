//
//  FLHttpStream.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLReadStream.h"
#import "FLHttpMessage.h"
#import "FLStreamWorker.h"

@interface FLHttpStream : FLReadStream {
@private
    FLHttpMessage* _requestHeaders;
    FLHttpMessage* _responseHeaders;
    NSInputStream* _bodyStream;
}

@property (readonly, assign, nonatomic) unsigned long bytesWritten;

// if bodyStream == nil, it will use bodyData in request.
- (id) initWithHttpMessage:(FLHttpMessage*) request 
            withBodyStream:(NSInputStream*) bodyStream
            streamSecurity:(FLNetworkStreamSecurity) security
            inputSink:(id<FLInputSink>) inputSink;

+ (id) httpStream:(FLHttpMessage*) request 
   withBodyStream:(NSInputStream*) bodyStream
   streamSecurity:(FLNetworkStreamSecurity) security
        inputSink:(id<FLInputSink>) inputSink;


@end


@interface FLHttpStreamSuccessfulResult : NSObject {
@private
    FLHttpMessage* _responseHttpHeaders;
    id<FLInputSink> _responseData;
}
@property (readonly, strong, nonatomic) FLHttpMessage* responseHttpHeaders;
@property (readonly, strong, nonatomic) id<FLInputSink> responseData;

@end

