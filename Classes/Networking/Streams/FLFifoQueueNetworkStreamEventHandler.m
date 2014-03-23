//
//  FLFifoQueueNetworkStreamEventHandler.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/15/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLFifoQueueNetworkStreamEventHandler.h"
#import "FLNetworkStream_Internal.h"

#import "FishLampSimpleLogger.h"

@interface FLFifoQueueNetworkStreamEventHandler ()
@property (readwrite, strong, nonatomic) FLFifoDispatchQueue* asyncQueue;
@end

@implementation FLFifoQueueNetworkStreamEventHandler

@synthesize asyncQueue = _asyncQueue;
@synthesize stream = _stream;

- (id) init {
	self = [super init];
	if(self) {
        self.asyncQueue = [FLFifoDispatchQueue fifoDispatchQueue];
    }
	return self;
}

#if FL_MRC
- (void) dealloc {
    [_asyncQueue release];
	[super dealloc];
}
#endif

+ (id) networkStreamEventHandler {
    return FLAutorelease([[[self class] alloc] init]);
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"

- (void) queueSelector:(SEL) selector withObject:(id) object {
    __block FLNetworkStream* theStream = FLRetain(self.stream);
    __block id theObject = FLRetain(object);
    FLAssertNotNil(self.asyncQueue);

    [self.asyncQueue dispatch_async:^{
        [self.stream performSelector:selector withObject:theObject];

        FLReleaseWithNil(theStream);
        FLReleaseWithNil(theObject);
    }];
}

- (void) queueSelector:(SEL) selector {
    __block FLNetworkStream* theStream = FLRetain(self.stream);
    FLAssertNotNil(self.asyncQueue);

    [self.asyncQueue dispatch_async:^{
        @try {
            [theStream performSelector:selector];
        }
        @catch(NSException* ex) {
            [theStream addError:ex.error];
            FLLog(@"stream encountered secondary error: %@", [ex.error localizedDescription]);
        }

        FLReleaseWithNil(theStream);
    }];
}

#pragma GCC diagnostic pop

- (void) handleStreamEvent:(CFStreamEventType) eventType {

    FLTrace(@"Read Stream got event %d", eventType);

    FLAssertNotNil(self.stream);
    [self.stream touchTimeoutTimestamp];

    switch (eventType)  {

        // NOTE: HttpStream doesn't get this event.
        case kCFStreamEventOpenCompleted:
            [self queueSelector:@selector(encounteredOpen)];
        break;

        case kCFStreamEventErrorOccurred:  
            [self queueSelector:@selector(encounteredError:) withObject:[self.stream streamError]];
        break;
        
        case kCFStreamEventEndEncountered:
            [self queueSelector:@selector(encounteredEnd)];
        break;
        
        case kCFStreamEventNone:
            // wtf? why would we get this?
            break;
        
        case kCFStreamEventHasBytesAvailable:
            [self queueSelector:@selector(encounteredBytesAvailable)];
        break;
            
        case kCFStreamEventCanAcceptBytes: 
            [self queueSelector:@selector(encounteredCanAcceptBytes)];
            break;
    }
}

- (void) streamWillOpen:(void (^)()) completion {
    if(completion) completion();
}

- (void) streamDidCloseWithResult:(FLPromisedResult) result {
}

- (NSRunLoop*) runLoop {
    return [NSRunLoop mainRunLoop];
}
- (NSString*) runLoopMode {
    return NSDefaultRunLoopMode;
}

@end
