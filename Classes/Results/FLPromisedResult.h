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
+ (id) fromPromisedResult:(FLPromisedResult) promisedResult;
@end

#define FLPromisedResultType(__TYPE__) FLPromisedResult