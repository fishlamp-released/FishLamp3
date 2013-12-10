//
//  FLTcpStream.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLFinisher.h"
#import "FLReadStream.h"
#import "FLWriteStream.h"
#import "FLTcpRequest.h"
#import "FLAsyncQueue.h"

#if REFACTOR
@interface FLTcpStream : NSObject<FLReadStreamDelegate, FLWriteStreamDelegate> {
@private
    NSString* _remoteHost;
    int32_t _remotePort;
    FLReadStream* _readStream;
	FLWriteStream* _writeStream;
    FLAsyncQueue* _dispatchQueue;
  
    BOOL _terminate;
  
// requests      
    NSMutableArray* _requests;
    NSMutableArray* _additions;
}

@property (readonly, strong) FLReadStream* readStream;
@property (readonly, strong) FLWriteStream* writeStream;

@property (readonly, assign, nonatomic) int32_t remotePort;
@property (readonly, strong) NSString* remoteHost;

- (id) initWithRemoteHost:(NSString*) address remotePort:(int32_t) port;

+ (id) tcpStream:(NSString*) address remotePort:(int32_t) port;

- (FLFinisher*) openConnection;
- (void) closeConnectionWithResult:(id) result;

- (void) addRequest:(FLTcpRequest*) request;
- (void) addRequestsWithArray:(NSArray*) requestArray;
@end

extern NSString* const FLTcpStreamWriteErrorKey;
extern NSString* const FLTcpStreamReadErrorKey;

@interface NSError (FLTcpStream)
@property (readonly, strong, nonatomic) NSError* writeError;
@property (readonly, strong, nonatomic) NSError* readError;
+ (NSError*) tcpStreamError:(NSError*) readError writeError:(NSError*) writeError;
@end
#endif