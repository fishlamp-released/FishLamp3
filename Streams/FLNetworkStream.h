//
//  FLNetworkStream.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLTimer.h"
#import "FishLampAsync.h"

//extern NSString* const FLNetworkStreamErrorDomain;
//extern NSString* const FLNetworkStreamErrorArrayKey;
//#define FLNetworkStreamError 1

@protocol FLNetworkStreamDelegate;
@protocol FLNetworkStreamEventHandler;

#define FLNetworkingIndividualThreads 1

typedef enum {
    FLNetworkStreamSecurityNone,
    FLNetworkStreamSecuritySSL
} FLNetworkStreamSecurity;

@interface FLNetworkStream : NSObject<FLTimerDelegate> {
@private
    NSError* _error;
    BOOL _hasError;
    BOOL _wasCancelled;
    BOOL _open;

    FLTimer* _timer;
    FLNetworkStreamSecurity _streamSecurity;
    id<FLNetworkStreamEventHandler> _eventHandler;
    NSTimeInterval _idleDuration;
    __unsafe_unretained id<FLNetworkStreamDelegate> _delegate;
}

// ctors
- (id) initWithStreamSecurity:(FLNetworkStreamSecurity) security;
- (id) initWithStreamSecurity:(FLNetworkStreamSecurity) security
                 eventHandler:(id<FLNetworkStreamEventHandler>) eventHandler;

@property (readonly, strong) NSString* identifier;

// delegate
@property (readwrite, assign) id<FLNetworkStreamDelegate> delegate;

// state
@property (readonly, assign, getter=isOpen) BOOL open;
- (void) openStreamWithDelegate:(id<FLNetworkStreamDelegate>) delegate;

// errors
@property (readonly, strong) NSError* error;
@property (readonly, assign) BOOL hasError;
@property (readonly, assign) BOOL wasCancelled;
- (void) requestCancel;

// security
@property (readonly, assign, nonatomic) FLNetworkStreamSecurity streamSecurity;

// timer
@property (readonly, strong) FLTimer* timer;

// event handler (runLoop, etc)
@property (readonly, strong) id<FLNetworkStreamEventHandler> eventHandler;
+ (Class) defaultEventHandlerClass;
+ (void) setDefaultEventHandlerClass:(Class) aClass;

@end

@protocol FLNetworkStreamDelegate <NSObject>

- (NSTimeInterval) networkStreamGetTimeoutInterval:(FLNetworkStream*) stream;

@optional

- (void) networkStreamWillOpen:(FLNetworkStream*) networkStream;

- (void) networkStreamDidOpen:(FLNetworkStream*) networkStream;

- (void) networkStream:(FLNetworkStream*) stream didCloseWithResult:(FLPromisedResult) result;

- (void) networkStream:(FLNetworkStream*) networkStream encounteredError:(NSError*) error;

- (void) networkStreamHasBytesAvailable:(FLNetworkStream*) networkStream;

- (void) networkStreamCanAcceptBytes:(FLNetworkStream*) networkStream;

- (void) networkStream:(FLNetworkStream*) networkStream didReadBytes:(NSNumber*) amountRead;

- (void) networkStream:(FLNetworkStream*) networkStream didWriteBytes:(NSNumber*) amountRead;

@end

@protocol FLNetworkStreamEventHandler <NSObject>

// treat this like a delegate - set it to nil in dealloc
@property (readwrite, assign) FLNetworkStream* stream;

+ (id) networkStreamEventHandler;

- (void) handleStreamEvent:(CFStreamEventType) eventType;
- (void) queueSelector:(SEL) selector;
- (void) queueSelector:(SEL) selector withObject:(id) object;

- (void) streamWillOpen:(void (^)()) completion;
- (void) streamDidCloseWithResult:(FLPromisedResult) result;

- (NSRunLoop*) runLoop;
- (NSString*) runLoopMode;

@end






