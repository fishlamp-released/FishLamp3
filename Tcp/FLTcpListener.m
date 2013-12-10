//
//  FLTcpServer.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/19/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#if REFACTOR

#import "FLTcpListener.h"
#import <sys/socket.h>
#import <arpa/inet.h>

@interface NSData (FLTcpSockets) 
- (int)port;
- (NSString *)host;
@end

@implementation NSData (FLTcpSockets) 

- (int)port
{
    int port = 0;
    struct sockaddr* addr = (struct sockaddr*)[self bytes];

    if(addr->sa_family == AF_INET) {
        // IPv4 family
        port = ntohs(((struct sockaddr_in *)addr)->sin_port);
    } else if(addr->sa_family == AF_INET6) {
        // IPv6 family
        port = ntohs(((struct sockaddr_in6 *)addr)->sin6_port);
    } else {
        // The family is neither IPv4 nor IPv6. Can't handle.
        port = 0;
    }
    
    return port;
}


- (NSString *)host
{
    struct sockaddr *addr = (struct sockaddr *)[self bytes];

    if(addr->sa_family == AF_INET) {

        char *address = inet_ntoa(((struct sockaddr_in *)addr)->sin_addr);

        if (address) {
            return [NSString stringWithCString: address encoding:NSASCIIStringEncoding];
        }
    }
    else if(addr->sa_family == AF_INET6) {
        struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)addr;

        char straddr[INET6_ADDRSTRLEN];

        inet_ntop(AF_INET6, &(addr6->sin6_addr), straddr, 
            sizeof(straddr));

        return [NSString stringWithCString: straddr encoding:NSASCIIStringEncoding];
    }
    return nil;
}

@end


@implementation FLTcpListener

//@synthesize serverState = _serverState;
@synthesize listeningPort = _port;

- (id) initWithListeningPort:(NSInteger) port {
    self = [super init];
    if(self) {
        _port = port;
        _connections = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#if FL_MRC 
- (void) dealloc {
    FLRelease(_connections);
    FLSuperDealloc();
}
#endif

//- (void) failOnSocketError:(CFSocketError err) {
//
//}

- (void) _removeConnection:(FLTcpStream*) connection {
    @synchronized(self) {
        [_connections removeObject:connection];
    }
}

- (void) networkConnectionDidClose:(FLTcpStream*) connection {
    [self _removeConnection:connection];
}

- (void) _addConnection:(FLTcpStream*) connection {

//    [connection addObserver:self];

    @synchronized(self) {
    
        [_connections addObject:connection];
    }
}

- (BOOL) didHandleReadInConnection:(FLTcpStream*) connection readStream:(NSInputStream*) readStream {


    return YES;
}

- (void) _handleNewConnection:(CFSocketRef) socket
    addressData:(NSData*) addressData
    nativeSocket:(CFSocketNativeHandle) nativeSocket {
    
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
   
    /* Create the read and write streams for the socket */
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocket,
        &readStream, &writeStream);

    if (!readStream || !writeStream) {
        close(nativeSocket);
//        fprintf(stderr, "CFStreamCreatePairWithSocket() failed\n");
        return;
    }

    CFReadStreamOpen(readStream);
    CFWriteStreamOpen(writeStream);

FIXME("accepting connections is broken");

//    FLTcpStream* newConnection = [FLTcpStream tcpConnection];
//    newConnection.remotePort = addressData.port;
//    newConnection.remoteHostAddress = addressData.host;
//    newConnection.localPort = self.listeningPort;
//    [newConnection setOpenedStreams:writeStream readStream:readStream];
//    
//    [self _addConnection:newConnection];
//
//    [newConnection openConnection:nil];
}


void FLTcpServerAcceptCallBack(
    CFSocketRef socket,
    CFSocketCallBackType type,
    CFDataRef address,
    const void *data,
    void *info)
{
// this is skanky - where is this coming from? Am I sending this in somewhere?
    CFSocketNativeHandle nativeSocket = *((CFSocketNativeHandle *) data);

    FLTcpListener* server = FLBridge(FLTcpListener*, info);
    [server _handleNewConnection:socket 
        addressData:FLBridge(id, address)
        nativeSocket:nativeSocket];
}

- (void) startListening
{
//	self.lastError = nil;
//	self.state = SERVER_STATE_STARTING;
    
    CFSocketContext context;
    memset(&context, sizeof(CFSocketContext), 0);    
    context.info = FLBridge(void*, self);

	_socket = CFSocketCreate(kCFAllocatorDefault, 
        PF_INET, 
        SOCK_STREAM,
		IPPROTO_TCP, 
        kCFSocketAcceptCallBack,
        FLTcpServerAcceptCallBack, 
        &context);
        
	if (!_socket){
//		[self errorWithName:@"Unable to create socket."];
		return;
	}

    /* Re-use local addresses, if they're still in TIME_WAIT */
    BOOL useIt = YES;
    if(setsockopt(CFSocketGetNative(_socket), SOL_SOCKET, SO_REUSEADDR,
        (void *)&useIt, sizeof(BOOL)) != kCFSocketSuccess) {
        
    }

//	if (setsockopt(nativeSocket, SOL_SOCKET, SO_REUSEADDR,
//		(void *)&reuse, sizeof(int)) != 0)
//	{
////		[self errorWithName:@"Unable to set socket options."];
//		return;
//	}
	
	struct sockaddr_in address;
	memset(&address, 0, sizeof(address));
	address.sin_len = sizeof(address);
	address.sin_family = AF_INET;
	address.sin_addr.s_addr = htonl(INADDR_ANY);
	address.sin_port = htons(_port); 
    
    NSData *addressData = [NSData dataWithBytes: &address length: sizeof(address)];
    if (CFSocketSetAddress(_socket, FLBridge(void*,addressData)) != kCFSocketSuccess) {
//        fprintf(stderr, "CFSocketSetAddress() failed\n");
//        CFRelease(TCPServer);
//        return EXIT_FAILURE;
    }
    
    CFRunLoopSourceRef sourceRef =
        CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), sourceRef, kCFRunLoopCommonModes);
    CFRelease(sourceRef);
    

	
	
//	self.state = SERVER_STATE_RUNNING;
}

- (void) _stop {
    
	if (_socket)
	{
		CFSocketInvalidate(_socket);
		CFRelease(_socket);
		_socket = nil;
	}
}

- (void) stopListening
{
    @synchronized(self) {
        _stop = YES;
    }


//	self.state = SERVER_STATE_IDLE;
}

- (void) blockUntilFinished
{
    @try {
        while(!_stop)
        {
            [[NSRunLoop currentRunLoop] runMode:self.eventHandler.runLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
    @finally {
        [self _stop];
    }
}

- (void) startListeningInBackground
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            _stop = NO;
            [self startListening];
            [self blockUntilFinished];
        }
        @catch(NSException* ex) {
            FLLog(@"Error in network thread: %@", [ex description]);
        }
    });
}  


@end
#endif
