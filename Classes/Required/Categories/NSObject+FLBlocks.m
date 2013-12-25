//
//  NSObject+FLBlocks.m
//  FishLamp
//
//  Created by Mike Fullerton on 11/5/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSObject+FLBlocks.h"
#import "FLErrorException.h"
#import "FLCancelError.h"

@implementation NSObject (FLBlocks)

+ (void) _performBlock:(fl_block_t) block {
    @try {
        if(block) {
            block();
        }
    }
    @catch(NSException* ex) {
        if(!ex.error.isCancelError) {
            @throw;
        }
    }
}

- (void) performBlockWithDelay_fl:(NSTimeInterval) delay
                         block:(fl_block_t) block {   
    [NSObject performSelector:@selector(_performBlock:) withObject:FLCopyWithAutorelease(block) afterDelay:delay];
}

- (void) performBlockOnMainThread_fl:(fl_block_t) block  {
    [NSObject performSelectorOnMainThread:@selector(_performBlock:) withObject:FLCopyWithAutorelease(block) waitUntilDone:NO];
}

+ (void) performBlockOnMainThread_fl:(fl_block_t) block  {
    [NSObject performSelectorOnMainThread:@selector(_performBlock:) withObject:FLCopyWithAutorelease(block) waitUntilDone:NO];
}

- (void) performBlockOnMainThreadAndWaitUntilDone_fl:(fl_block_t) block {
    [NSObject performSelectorOnMainThread:@selector(_performBlock:) withObject:FLCopyWithAutorelease(block) waitUntilDone:YES];
}

- (void) performBlockOnThread_fl:(NSThread*) thread block:(fl_block_t) block {
    [NSObject performSelector:@selector(_performBlock:) onThread:thread withObject:FLCopyWithAutorelease(block) waitUntilDone:NO];
}

+ (void) performBlockOnThread_fl:(NSThread*) thread block:(fl_block_t) block {
    [NSObject performSelector:@selector(_performBlock:) onThread:thread withObject:FLCopyWithAutorelease(block) waitUntilDone:NO];
}

- (void) performBlockOnMainThreadWithDelay_fl:(NSTimeInterval) delay
                                     block:(fl_block_t) block {

    FLPrepareBlockForFutureUse(block);

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self performBlockOnMainThread_fl:block];
    });

}


@end

