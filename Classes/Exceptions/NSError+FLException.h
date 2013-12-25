//
//  NSError+FishLampExceptions.h
//  FishLampTestLibraries
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import "FishLampRequired.h"

extern NSString* const FLUnderlyingExceptionKey;

#define FLExceptionErrorDomain @"FLExceptionErrorDomain"

typedef NS_ENUM(NSUInteger, FLExceptionErrorDomainErrorCode) {
    FLUnknownExceptionErrorCode = 1
};

@interface NSError (FLException)
- (id) errorWithException:(NSException*) exception;
- (id) initWithException:(NSException*) exception;
- (NSException*) exception;

+ (id) unknownExceptionError:(NSException*) exception;

@end
