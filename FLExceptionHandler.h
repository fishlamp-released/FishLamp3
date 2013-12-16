//
//  FLExceptionHandler.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/8/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FLExceptionHandlerBlock)(BOOL handled);

@protocol FLExceptionHandler <NSObject>

- (void) handleException:(NSException*) exception
              completion:(FLExceptionHandlerBlock) completion;

@end


@interface FLExceptionHandler : NSObject<FLExceptionHandler>
+ (id) defaultExceptionHandler;
@end