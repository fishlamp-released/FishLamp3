//
//  FLFinisherBlockOperation.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLOperation.h"

@interface FLFinisherBlockOperation : FLOperation {
@private
    fl_finisher_block_t _finisherBlock;
}
+ (id) finisherBlockOperation:(fl_finisher_block_t) block;
@end
