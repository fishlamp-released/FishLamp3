//
//  NSError+FLFailedResult.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/23/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "NSError+FLFailedResult.h"

#import "FLErrorCodes.h"

@implementation NSError (FLAsyncResult)
+ (id) failedResultError {
    FLReturnStaticObject(
     [NSError errorWithDomain:FLErrorDomain
                               code:FLErrorResultFailed
               localizedDescription:NSLocalizedString(@"An operation failed.", nil)
                           userInfo:nil
                            stackTrace:nil]);
}
@end

