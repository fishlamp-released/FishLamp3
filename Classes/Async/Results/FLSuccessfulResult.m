//
//  FLSuccessfulResult.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 6/23/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLSuccessfulResult.h"

@implementation FLSuccessfulResultObject

+ (id) successfulResult {
    static dispatch_once_t s_predicate = 0;
    static FLSuccessfulResultObject* s_instance = nil;
    dispatch_once(&s_predicate, ^{
        s_instance = [[FLSuccessfulResultObject alloc] init];
    });
    return s_instance;
}

@end
