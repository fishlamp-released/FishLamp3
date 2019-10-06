//
//  FLResponderChainState.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 7/21/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLResponderChainState.h"

#import "FLPrettyDescription.h"
#import "FLPrettyString.h"
#import "FishLampSimpleLogger.h"

@interface FLResponderChainState ()
@end

@implementation FLResponderChainState

- (id) initWithWindow:(NSWindow*) window {
    FLAssertNotNil(window);
    
	self = [super init];
	if(self) {
        FLAssertNotNil(window);
		_window = FLRetain(window);
        _responder = FLRetain([window firstResponder]);
        _timeout = 1.0; // much longer than this will cause weird UI
    }
	return self;
}

- (id) init {	
    return [self initWithWindow:nil];
}

+ (id) responderState:(NSWindow*) window {
    return FLAutorelease([[[self class] alloc] initWithWindow:window]);
}

#if FL_MRC
- (void)dealloc {
    [_responder release];
    [_window release];
    [super dealloc];
}
#endif

- (void) restoreResponder:(id) responder
               withWindow:(NSWindow*) window {

//    FLAssertNotNil([responder superview]);

    if(!responder) {
        responder = [window initialFirstResponder];
    }

    if([window makeFirstResponder:responder]) {
        FLDebugLog(@"window refused to set responder");
    }

return;
    [self performBlockOnMainThread_fl:^{
        if([window firstResponder] != responder) {

            if([NSDate timeIntervalSinceReferenceDate] < (_start + _timeout)) {
                [self restoreResponder:responder withWindow:window];
            }
            else {
                FLDebugLog(@"Unable to set first responder %@ in %@", [responder description], [_window description])
            }
        }

    }];
}

- (void) restore {
    if(_window) {
        id responder = _responder;
        id window = _window;

        _start = [NSDate timeIntervalSinceReferenceDate];

        [self performBlockOnMainThread_fl:^{
            [self restoreResponder:responder withWindow:window];
        }];

        FLReleaseWithNil(_responder);
        FLReleaseWithNil(_window);
    }
}

@end

#if DEBUG
@implementation NSWindow (FLResponderChain)

- (NSString*) responderChainDescription {
    FLPrettyString* prettyString = [FLPrettyString prettyString];
    id firstResponder = [self firstResponder];
    while(firstResponder) {
        [prettyString appendLineWithFormat:@"%@, %@", NSStringFromClass([firstResponder class]), [firstResponder description]];
        firstResponder = [firstResponder nextResponder];
    }
    return prettyString.string;
}

@end

@implementation NSView (FLResponderChain)
- (NSString*) responderChainDescription {
    FLPrettyString* prettyString = [FLPrettyString prettyString];
    id firstResponder = self;
    while(firstResponder) {
        [prettyString appendLineWithFormat:@"%@, %@", NSStringFromClass([firstResponder class]), [firstResponder description]];
        firstResponder = [firstResponder nextResponder];
    }
    return prettyString.string;
}
@end

#endif
