//
//  NSObject+FLBlocks.h
//  FishLamp
//
//  Created by Mike Fullerton on 11/5/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license
//

#import "FishLampObjc.h"

typedef void (^fl_error_block_t)(NSError* error);
typedef dispatch_block_t fl_block_t;

@interface NSObject (Blocks)

- (void) performBlockWithDelay_fl:(NSTimeInterval) delay
                            block:(fl_block_t) block;

- (void) performBlockOnMainThread_fl:(fl_block_t) block;

- (void) performBlockOnMainThreadWithDelay_fl:(NSTimeInterval) delay
                                        block:(fl_block_t) block;

- (void) performBlockOnMainThreadAndWaitUntilDone_fl:(fl_block_t) block;

- (void) performBlockOnThread_fl:(NSThread*) thread block:(fl_block_t) block;


+ (void) performBlockOnMainThread_fl:(fl_block_t) block;

+ (void) performBlockOnThread_fl:(NSThread*) thread block:(fl_block_t) block;

@end

