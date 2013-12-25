//
//  NSError+FishLampExceptions.m
//  FishLampTestLibraries
//
//  Created by Mike Fullerton on 12/24/13.
//
//

#import "NSError+FLException.h"

NSString* const FLUnderlyingExceptionKey = @"com.fishlamp.exception";

@implementation NSError (FLException)

- (NSException*) exception {
    return [self.userInfo objectForKey:FLUnderlyingExceptionKey];
}

- (id) initWithException:(NSException*) exception {
	return [self initWithDomain:FLExceptionErrorDomain
                           code:FLUnknownExceptionErrorCode
                       userInfo:[NSDictionary dictionaryWithObject:exception forKey:FLUnderlyingExceptionKey]];
}

- (id) errorWithException:(NSException*) exception {
    return FLAutorelease([[[self class] alloc] initWithException:exception]);
}

+ (id) unknownExceptionError:(NSException*) exception {
    return FLAutorelease([[[self class] alloc] initWithException:exception]);
}

@end