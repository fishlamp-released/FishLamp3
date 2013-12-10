//
//  NSError+FLFailedResult.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/23/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"

@interface NSError (FLFailedResult)
+ (id) failedResultError;
@end

#define FLFailedResult [NSError failedResultError]
