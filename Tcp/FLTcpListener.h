//
//  FLTcpServer.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "FLTcpStream.h"

//typedef enum {
//	SERVER_STATE_IDLE,
//	SERVER_STATE_STARTING,
//	SERVER_STATE_RUNNING,
//	SERVER_STATE_STOPPING
//} FLServerState;

#if REFACTOR

@interface FLTcpListener : NSObject {
@private
//	FLServerState _state;

	CFSocketRef _socket;
    NSInteger _port;
    BOOL _stop;
    NSMutableArray* _connections;
}

- (id) initWithListeningPort:(NSInteger) port;

@property (readonly, assign, nonatomic) NSInteger listeningPort;

//@property (readonly, assign, nonatomic) FLServerState serverState;

- (void) startListening;
- (void) stopListening;

- (void) startListeningInBackground;

@end

#endif
