//
//  FLPromisedResult.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/23/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLPromisedResult.h"

@implementation NSObject (FLPromisedResult)

- (BOOL) isError {
    return NO;
}

+ (id) fromPromisedResult:(FLPromisedResult) promisedResult {
    FLAssertNotNil(promisedResult);
    FLThrowIfError(promisedResult);

    FLConfirm(
        [promisedResult isKindOfClass:[self class]],
        @"Result expected to be a \"%@\" instead it's a \"%@\"",
            NSStringFromClass([self class]),
            NSStringFromClass([promisedResult class]));

    return promisedResult;

}

@end

@implementation NSError (FLPromisedResult)

- (BOOL) isError {
    return YES;
}

+ (id) fromPromisedResult:(FLPromisedResult) promisedResult {
    FLConfirm(
        [promisedResult isKindOfClass:[self class]],
        @"Result expected to be a \"%@\" instead it's a \"%@\"",
            NSStringFromClass([self class]),
            NSStringFromClass([promisedResult class]));

    return promisedResult;

}
@end
