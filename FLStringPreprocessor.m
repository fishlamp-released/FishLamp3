//
//  FLStringPreprocessor.m
//  FishLampCore
//
//  Created by Mike Fullerton on 10/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLStringPreprocessor.h"
#import "FishLampCore.h"

typedef void (^FLStringPreprocessorOutputBlock)(NSRange range);

@implementation FLStringFormatterLineProprocessor

FLSynthesizeSingleton(FLStringFormatterLineProprocessor);

- (NSRange) processString:(NSString*) string
      foundLineRangeBlock:(FLStringPreprocessorResultBlock) foundLineRangeBlock {

    FLAssertNotNil(string);
    FLAssertNotNil(foundLineRangeBlock);

    NSRange range = { 0, 0 };

    for(NSUInteger i = 0; i < string.length; i++) {
        if([string characterAtIndex:i] == '\n') {
            foundLineRangeBlock(range);
            range.location = i+1;
            range.length = 0;
            continue;
        }

        ++range.length;
    }

    return range;
}

@end
