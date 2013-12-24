//
//  FLExceptionHandler.m
//  FishLampCore
//
//  Created by Mike Fullerton on 11/8/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLExceptionHandler.h"
#import "FishLampCore.h"

@implementation FLExceptionHandler

FLSynthesizeDefaultProperty(id, defaultExceptionHandler);

- (void) handleException:(NSException*) exception
              completion:(FLExceptionHandlerBlock) completion {

    FLLog(@"Unhandled exception: %@", [exception description]);

    if(completion) {
        completion(NO);
    }
}


@end
