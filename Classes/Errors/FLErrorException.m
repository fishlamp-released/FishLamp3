//
//  NSException.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLErrorException.h"
#import "FLErrorCodes.h"
#import "NSError+FishLamp.h"

NSString* const FLUnderlyingExceptionKey = @"com.fishlamp.exception";

@implementation NSError (FLException)

- (NSException*) exception {
    return [self.userInfo objectForKey:FLUnderlyingExceptionKey];
}

- (id) initWithException:(NSException*) exception {
	return [self initWithDomain:FLErrorDomain code:FLUnknownExceptionErrorCode
                        userInfo:[NSDictionary dictionaryWithObject:exception forKey:FLUnderlyingExceptionKey]];
}

+ (id) unknownExceptionError:(NSException*) exception {
    return FLAutorelease([[[self class] alloc] initWithException:exception]);
}

@end

@implementation NSException (NSError)

- (NSError*) error {
    NSError* error = [self.userInfo objectForKey:NSUnderlyingErrorKey];
    if(error) {
        return error;
    }

    return [NSError unknownExceptionError:self];
}

- (id)initWithName:(NSString *)aName
            reason:(NSString *)aReason
          userInfo:(NSDictionary *)aUserInfo
             error:(NSError*) aError {

    NSDictionary* theUserInfo = aUserInfo;

    if(aError) {

        if(aUserInfo) {
            NSMutableDictionary* newUserInfo = FLMutableCopyWithAutorelease(aUserInfo);
            [newUserInfo setObject:FLCopyWithAutorelease(aError) forKey:NSUnderlyingErrorKey];
            theUserInfo = newUserInfo;
        }
        else {
            theUserInfo = [NSDictionary dictionaryWithObject:FLCopyWithAutorelease(aError) forKey:NSUnderlyingErrorKey];
        }
    }

    return [self initWithName:aName reason:aReason userInfo:theUserInfo];
}

+ (NSException *)exceptionWithName:(NSString *)name
                            reason:(NSString *)reason
                          userInfo:(NSDictionary *)userInfo
                             error:(NSError*) error {
    return FLAutorelease([[[self class] alloc] initWithName:name reason:reason userInfo:userInfo error:error]);
}

- (id) initWithError:(NSError*) error {
    return [self initWithName:[error nameForException]
                       reason:[error reasonForException]
                     userInfo:nil
                        error:error];
}

+ (id) exceptionWithError:(NSError*) error {
    return FLAutorelease([[[self class] alloc] initWithError:error]);
}

@end

//@implementation FLErrorException
//
//+ (id) errorException:(NSError*) error {
//    return FLAutorelease([[[self class] alloc] initWithError:error]);
//}
//
//@end
//
