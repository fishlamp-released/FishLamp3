//
//  FLBlockOperation.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 9/1/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLOperation.h"

@interface FLBlockOperation : FLOperation {
@private
    fl_block_t _block;
}
+ (id) blockOperation:(fl_block_t) block;
@end
