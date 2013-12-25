//
//  NSException.m
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSError+FLException.h"
#import "FishLampCoreErrorDomain.h"
#import "NSError+FishLampCore.h"

@implementation NSException (FL)

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

//@implementation NSError+FLException
//
//+ (id) errorException:(NSError*) error {
//    return FLAutorelease([[[self class] alloc] initWithError:error]);
//}
//
//@end
//
