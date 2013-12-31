//
//  FLStringPreprocessor.h
//  FishLampCore
//
//  Created by Mike Fullerton on 10/24/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampRequired.h"

typedef void (^FLStringPreprocessorResultBlock)(NSRange range);

@protocol FLStringPreprocessor <NSObject>
- (NSRange) processString:(NSString*) string
      foundLineRangeBlock:(FLStringPreprocessorResultBlock) foundLineRangeBlock;
@end

@interface FLStringFormatterLineProprocessor : NSObject<FLStringPreprocessor>
FLSingletonProperty(FLStringFormatterLineProprocessor);
@end


