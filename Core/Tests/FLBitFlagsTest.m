//
//  FLBitsAreNotZero.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

#import "FLTestable.h"
#import "FLCoreFrameworkTest.h"

@interface FLBitFlagTests : FLCoreFrameworkTest {
}
@end

@implementation FLBitFlagTests

- (void) testBitFlags1 {

    FLBitFlags_t mask1 = 0;
    FLBitFlags_t mask2 = 0;

    for(int i = 0; i < 31; i++) {
        
        uint32_t flag = 1 << i;
        
        FLSetBits(mask1, flag);
        FLSetBitsAtomic(mask2, flag);
        FLAssert(mask1 == mask2, @"masks are not the same");
        
        FLAssert(FLTestBits(mask1, flag), @"should be set");
        FLAssert(FLTestBitsAtomic(mask2, flag), @"should be set");
        
        FLAssert(FLTestBits(mask1, flag), @"should be true");
        FLAssert(FLTestBitsAtomic(mask2, flag), @"should be true");
        
    }
    
    for(int i = 0; i < 31; i++) {
        
        uint32_t flag = 1 << i;
    
        FLClearBits(mask1, flag);
        FLClearBitsAtomic(mask2, flag);
        
        FLAssert(mask1 == mask2, @"masks are not the same");

        FLAssert(!FLTestBits(mask1, flag), @"should be set");
        FLAssert(!FLTestBitsAtomic(mask2, flag), @"should be set");
        
        FLAssert(!FLTestBits(mask1, flag), @"should be false");
        FLAssert(!FLTestBitsAtomic(mask2, flag), @"should should be false");

    }

    
    FLAssert(mask1 == 0, @"mask2 is not zero");
    FLAssert(mask2 == 0, @"mask2 is not zero");

}



- (void) testBitFlags2 {

    FLBitFlags_t mask1 = 0;
    FLBitFlags_t mask2 = 0;

    for(int i = 0; i < 32; i++) {
        
        uint32_t flag = 1 << i;
        
        FLSetOrClearBits(mask1, flag, YES);
        FLSetOrClearBitsAtomic(mask2, flag, YES);
        FLAssert(mask1 == mask2);
        
        FLAssert(FLTestBits(mask1, flag));
        FLAssert(FLTestBitsAtomic(mask2, flag));
        
        FLAssert(FLTestAnyBit(mask1, flag));
        FLAssert(FLTestAnyBitAtomic(mask2, flag));
        
    }
    
    for(int i = 0; i < 32; i++) {
        
        uint32_t flag = 1 << i;
    
        FLSetOrClearBits(mask1, flag, NO);
        FLSetOrClearBitsAtomic(mask2, flag, NO);

        FLAssert(mask1 == mask2, @"masks are not the same");

        FLAssert(!FLTestBits(mask1, flag));
        FLAssert(!FLTestBitsAtomic(mask2, flag));
        
        FLAssert(!FLTestAnyBit(mask1, flag));
        FLAssert(!FLGetBitsAtomic(mask2, flag));

    }

    
    FLAssert(mask1 == 0, @"mask2 is not zero");
    FLAssert(mask2 == 0, @"mask2 is not zero");

}


@end
