//
//  FLNetworkStream_Internal.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLNetworkStream.h"

@interface FLNetworkStream ()

- (void) addError:(NSError*) error;

- (void) touchTimeoutTimestamp;

// required overrides
- (void) openStream;
- (void) closeStream;

// all of these are called on the async queue.

// optional overrides
- (void) willOpen;
- (void) didOpen;
- (void) didCloseWithResult:(FLPromisedResult) result;
- (NSError*) streamError;

// stream events. All of these do nothing by default. They are called on the 
// async queue.
- (void) encounteredOpen;
- (void) encounteredCanAcceptBytes;
- (void) encounteredBytesAvailable;
- (void) encounteredError:(NSError*) error;
- (void) encounteredEnd;
@end
