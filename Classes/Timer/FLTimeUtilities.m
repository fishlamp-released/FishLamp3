//
//  FLTimeUtilities.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/12/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLTimeUtilities.h"


#import <mach/mach_time.h>  // for mach_absolute_time() and friends

NSTimeInterval FLTimeBlock(dispatch_block_t block)  {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS)  {
        return -1.0;
    }

    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;

    uint64_t nanos = elapsed * info.numer / info.denom;
    return (NSTimeInterval)nanos / (NSTimeInterval) NSEC_PER_SEC;
} 

uint64_t FLTimeGetHighResolutionTimeStamp() {
    return mach_absolute_time ();
}

NSTimeInterval FLTimeGetInterval(uint64_t start, uint64_t end) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS)  {
        return 0.0;
    }
    uint64_t elapsed = end - start;

    uint64_t nanos = elapsed * info.numer / info.denom;
    return (NSTimeInterval)nanos / (NSTimeInterval) NSEC_PER_SEC;
}
