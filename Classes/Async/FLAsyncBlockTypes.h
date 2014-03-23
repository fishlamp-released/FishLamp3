//
//  FLAsyncBlockTypes.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 2/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLPromisedResult.h"

@class FLFinisher;

/**
@brief block the receives promised result
*/
typedef void (^fl_result_block_t)(FLPromisedResult result);

/**
@brief block that recieves a finisher
@param finisher a finisher that you need to call setFinished on when your async work is completed
*/
typedef void (^fl_finisher_block_t)(FLFinisher* finisher);

/**
@brief completion block is an alias for fl_result_block_t
*/
typedef fl_result_block_t fl_completion_block_t;


