//
//  FLResponderChainState.h
//  FishLampOSX
//
//  Created by Mike Fullerton on 7/21/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "FishLampOSX.h"

@interface FLResponderChainState : NSObject {
@private
    NSWindow* _window;
//    NSInteger _tryCount;
    id _responder;
    NSTimeInterval _timeout;
    NSTimeInterval _start;
}

+ (id) responderState:(NSWindow*) window;

- (void) restore;

@end

#if DEBUG
@interface NSWindow (FLResponderChain)
- (NSString*) responderChainDescription;
@end

@interface NSView (FLResponderChain)
- (NSString*) responderChainDescription;
@end
#endif

