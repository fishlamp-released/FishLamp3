//
//  FLPromisedResult.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/23/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

/**
 *  Abstract type for a unfufilled promise. This will either be an error or a valid value.
 */
#define FLPromisedResult id

@interface NSObject (FLPromisedResult)
- (BOOL) isError;
- (NSError*) errorResult;
+ (id) fromPromisedResult:(FLPromisedResult) promisedResult;
@end

#define FLPromisedResultType(__TYPE__) FLPromisedResult

#if DEBUG

#define FLAssertPromisedResultIsType(RESULT, TYPE) \
            do { \
                id __RESULT__ = RESULT; \
                if(![__RESULT__ isError]) { \
                    FLAssertIsKindOfClass(__RESULT__, TYPE); \
                } \
            }   \
            while(0)

#else
#define FLAssertPromisedResultIsType(...)
#endif