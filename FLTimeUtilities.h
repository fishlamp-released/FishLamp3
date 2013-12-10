//
//  FLTimeUtilities.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

extern NSTimeInterval FLTimeBlock (dispatch_block_t block);

extern uint64_t FLTimeGetHighResolutionTimeStamp();
extern NSTimeInterval FLTimeGetInterval(uint64_t start, uint64_t end);
