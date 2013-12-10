//
//  FLTcpStream.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#if REFACTOR
#import "FLTcpStream.h"

@interface FLTcpStream ()
@property (readwrite, assign, nonatomic) int32_t remotePort;
@property (readwrite, strong) NSString* remoteHost;
@property (readwrite, strong) FLReadStream* readStream;
@property (readwrite, strong) FLWriteStream* writeStream;
@property (readwrite, strong) FLAsyncQueue* dispatchQueue;
@property (readwrite, assign, getter=wasTerminated) BOOL terminate;

- (void) updateRequestQueue;
@end

@implementation FLTcpStream
@synthesize remotePort = _remotePort;
@synthesize remoteHost = _remoteHost;
@synthesize readStream = _readStream;
@synthesize writeStream = _writeStream;
@synthesize dispatchQueue = _dispatchQueue;
@synthesize terminate = _terminate;

- (id) initWithRemoteHost:(NSString*) remoteHost remotePort:(int32_t) remotePort {
    self = [self init];
    if(self) {
        self.remoteHost = remoteHost;
        self.remotePort = remotePort;
        
        _requests = [[NSMutableArray alloc] init];
        _additions = [[NSMutableArray alloc] init];
        
        static int s_count = 0;
        _dispatchQueue = [[FLAsyncQueue alloc] initWithLabel:[NSString stringWithFormat:@"com.fishlamp.queue.tcp-stream-%d", ++s_count] 
            attr:DISPATCH_QUEUE_SERIAL];
 
    }
    
    return self;
}

+ (id) tcpStream:(NSString*) remoteHost  remotePort:(int32_t) remotePort {
    return FLAutorelease([[[self class] alloc] initWithRemoteHost:remoteHost remotePort:remotePort]);
}

- (FLFinisher*) openConnection {

//    return [self.dispatchQueue queueBlock:^{
//        
//        FLAssertIsNil(self.readStream);
//        FLAssertIsNil(self.writeStream);
//
//        CFReadStreamRef readStream = nil;
//        CFWriteStreamRef writeStream = nil;
//        CFHostRef host = nil;
//        
//        @try {
//            FLAssertWithComment(self.remotePort != 0, @"remote port can't be zero");
//            FLAssertStringIsNotEmpty(self.remoteHost);
//           
//            host = CFHostCreateWithName(NULL, FLBridge(void*,self.remoteHost));
//            if(!host) {
//                FLThrowIfError([NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotFindHost localizedDescription:@"Unable to find to host"]);
//            }
//            
//            CFStreamCreatePairWithSocketToCFHost(NULL, host, self.remotePort, &readStream, &writeStream);
//            if(!readStream || !writeStream) {
//                FLThrowIfError([NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNetworkConnectionLost localizedDescription:@"Unable to connect to host"]);
//            }
//                    
//            self.readStream = [FLReadStream readStream:readStream];
//            [self.readStream setDelegate:self];
//            
//            self.writeStream = [FLWriteStream writeStream:writeStream];
//            [self.writeStream setDelegate:self];
//            
//            [self.readStream openStream];
//            [self.writeStream openStream];
//        }
//        @finally {
//            if(host) {
//                CFRelease(host);
//            }
//            if(readStream) {
//                CFRelease(readStream);
//            }
//            if(writeStream) {
//                CFRelease(writeStream);
//            }
//        }
//   
//    }];

    return nil;
}

- (void) dealloc {

    FLAssert(!self.isOpen);
    
#if FL_MRC
    [_requests release];
    [_additions release];
    [_dispatchQueue release];
    [_remoteHost release];
    [_writeStream release];
    [_readStream release];
    [super dealloc];
#endif
}

- (void) closeConnectionWithResult:(id) result error:(NSErro*) error {
    self.terminate = YES;
    
    [self.dispatchQueue queueBlock:^{
//        if(_readStream) {
//            [_readStream setDelegate:nil];
//            [_readStream closeStreamWithResult:result];
//            self.readStream = nil;
//        }
//        if(_writeStream) {
//            [_writeStream setDelegate:nil];
//            [_writeStream closeStreamWithResult:result];
//            self.writeStream = nil;
//        }
    }];
}

- (BOOL) isOpen {
    return self.writeStream.isOpen && self.readStream.isOpen;
}

- (void) readStreamDidOpen:(FLReadStream*) networkStream {
    if(self.isOpen) {
//        [self sendMessage:@"networkStreamDidOpen:"];
    }
}

- (void) readStream:(FLReadStream*) networkStream 
    didCloseWithResult:(id) result
    error:(NSError*) error{
    
    [self closeConnectionWithResult:result error:error];
}

- (void) readStream:(FLReadStream*) readStream
      encounteredError:(NSError*) error {
    
    [self closeConnectionWithResult:nil error:error];
}

- (void) readStreamHasBytesAvailable:(FLReadStream*) networkStream {
//    [self sendMessage:@"readStreamHasBytesAvailable:"];
    if(self.isOpen) {
        [self updateRequestQueue];
    }
}

- (void) readStream:(FLReadStream*) stream didReadBytes:(NSNumber*) amountRead {
//    [self sendMessage:@"readStreamDidReadBytes:"];
}

- (void) writeStreamDidOpen:(FLWriteStream*) networkStream {
    if(self.isOpen) {
//        [self sendMessage:@"networkStreamDidOpen:"];

        [self updateRequestQueue];
    }
}

- (void) writeStream:(FLWriteStream*) networkStream 
  didCloseWithResult:(id) result
  error:(NSError*) error{
    
    [self closeConnectionWithResult:result error:error];
}

- (void) writeStream:(FLWriteStream*) writeStream
   encounteredError:(NSError*) error {
    
    [self closeConnectionWithResult:nil error:error];
}      

- (void) writeStreamCanAcceptBytes:(FLWriteStream*) networkStream {
//    [self sendMessage:@"writeStreamCanAcceptBytes:"];

    if(self.isOpen) {
        [self updateRequestQueue];
    }
}

- (void) writeStream:(FLWriteStream*) stream didWriteBytes:(NSNumber*) amountWritten {
//    [self sendMessage:@"writeStreamDidWriteBytes:"];

}

- (void) requestCancel {
    [self closeConnectionWithResult:nil error:[NSError cancelError]];
}

#pragma mark -- request queue

- (void) writeAvailableBytes {
    
//    for(FLTcpRequest* request in _requests) {
//        while(request && [request writeData:self.writeStream]) {
//            FLThrowAbortExeptionIf(self.wasTerminated);
//        }
//    }
}

- (void) readAvailableBytes {

//    while(self.readStream.hasBytesAvailable) {
//        BOOL stop = YES;
//
//        for(FLTcpRequest* request in _requests) {
//            FLThrowAbortExeptionIf(self.wasTerminated);
//
//            if(request && request.wantsRead) {
//                request.wantsRead = [request readData:self.readStream];
//                stop = NO;
//                break;
//            }
//        }
//        
//        if(stop) {
//            break;
//        }
//    
//    }
}

- (void) updateQueue {

    if(self.isOpen && !self.wasTerminated) {
        @synchronized (self) {
            [_requests addObjectsFromArray:_additions];
            [_additions removeAllObjects];
        }
        
        @try {
            [self readAvailableBytes];
            [self writeAvailableBytes];
            
//            for(int i = _requests.count; i >= 0; i--) {
//                FLThrowAbortExeptionIf(self.wasTerminated);
//
//                FLTcpRequest* request = [_requests objectAtIndex:i];
//                if(!request.wantsWrite && !request.wantsRead) {
//                    [_requests removeObjectAtIndex:i];
//                }
//            }
        }
        @catch(NSException* ex) {
            [self closeConnectionWithResult:nil error:ex.error];
        }
    }
}

- (void) updateRequestQueue {
    [self.dispatchQueue queueBlock:^{
        [self updateQueue];
    }];
}

- (void) addRequest:(FLTcpRequest*) request {
    @synchronized(self) {
        [_additions addObject:request];
    }
    [self updateRequestQueue];
}

- (void) addRequestsWithArray:(NSArray*) requestArray {
    @synchronized(self) {
        [_additions addObjectsFromArray:requestArray];
    }
    [self updateRequestQueue];
}

@end


#define FLFrameworkTcpStreamErrorCode 1000

NSString* const FLTcpStreamWriteErrorKey = @"FLTcpStreamWriteErrorKey";
NSString* const FLTcpStreamReadErrorKey = @"FLTcpStreamReadErrorKey";

@interface FLTcpStreamError : NSError
@end

@implementation NSError (FLTcpStream)

- (NSError*) readError {
    return self;
}

- (NSError*) writeError {
    return self;
}

+ (NSError*) tcpStreamError:(NSError*) readError writeError:(NSError*) writeError {
    if(readError && writeError) {
// this seems unlikely to happen  - but just in case.    
        NSMutableDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     readError, FLTcpStreamReadErrorKey, 
                                     writeError, FLTcpStreamWriteErrorKey,
                                     [NSString stringWithFormat:@"readError: %@, writeError %@", [readError localizedDescription], [writeError localizedDescription]], NSLocalizedDescriptionKey, 
                                     nil];
    
        return [FLTcpStreamError errorWithDomain:FLErrorDomain code:FLFrameworkTcpStreamErrorCode userInfo:dict];
    }
    if(readError) {
        return readError;
    }
    if(writeError) {
        return writeError;
    }
    
    return nil;
}

@end

@implementation FLTcpStreamError

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ { readError: %@, writeError: %@ }",[super description], [self.readError description], [self.writeError description]];
}

- (NSError*) readError {
    return [self.userInfo objectForKey:FLTcpStreamReadErrorKey];
}

- (NSError*) writeError {
    return [self.userInfo objectForKey:FLTcpStreamWriteErrorKey];
}

@end
#endif
