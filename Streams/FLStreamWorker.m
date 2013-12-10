//
//  FLOpenStreamWorker.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStreamWorker.h"

//@interface FLStreamWorker ()
//@property (readwrite, strong, nonatomic) FLFinisher* finisher;
//@property (readwrite, strong, nonatomic) id networkStream;
//@end
//
//@implementation FLStreamWorker
//
//@synthesize networkStream = _networkStream;
//@synthesize finisher = _finisher;
//@synthesize asyncQueue = _asyncQueue;
//
//- (id) initWithNetworkStream:(FLNetworkStream*) stream asyncQueue:(FLFifoAsyncQueue*) asyncQueue {
//    self = [super init];
//    if(self) {
//        self.networkStream = stream;
//        self.asyncQueue = asyncQueue;
//    }
//    return self;
//}
//
//- (void) requestCancel {
//    [self.networkStream closeStreamWithError:[NSError cancelError]];
//}
//
//+ (id) streamWorker:(FLNetworkStream*) networkStream {
//   return FLAutorelease([[[self class] alloc] initWithNetworkStream:networkStream]);
//}
//
//#if FL_MRC
//- (void) dealloc {
//    [_networkStream release];
//    [_finisher release];
//    [super dealloc];
//}
//#endif
//
//- (void) setFinished {
//    NSError* error = [self.networkStream error];
//    if(error) {
//        [self.finisher setFinishedWithResult:error];
//    }
//    else {
//        [self.finisher setFinished];
//    }
//}
//
//- (void) networkStreamDidClose:(FLNetworkStream*) networkStream {
//    [self setFinished];
//}
//
//- (void) runAsynchronously:(FLFinisher*) finisher {
//    self.finisher = finisher;
//}  
//
//@end
//
//
//@implementation FLStreamOpener 
//
//+ (id) streamOpener:(FLNetworkStream*) networkStream {
//    return FLAutorelease([[[self class] alloc] initWithNetworkStream:networkStream]);
//}
//
//- (void) runAsynchronously:(FLFinisher*) finisher {
//    [super runAsynchronously:finisher];
//    [self.networkStream openStreamWithDelegate:self asyncQueue:self.asyncQueue];
//}
//
//- (void) networkStreamDidOpen:(FLNetworkStream*) networkStream {
//    [self setFinished];
//}
//
//@end
