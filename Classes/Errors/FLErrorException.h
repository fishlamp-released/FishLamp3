//
//  FLErrorException.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/26/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

extern NSString* const FLUnderlyingExceptionKey;

@interface NSException (NSError)

@property (readonly, strong, nonatomic) NSError* error;

+ (NSException *)exceptionWithName:(NSString *)name 
                            reason:(NSString *)reason 
                          userInfo:(NSDictionary *)userInfo 
                             error:(NSError*) error;
                             
- (id)initWithName:(NSString *)aName 
            reason:(NSString *)aReason 
          userInfo:(NSDictionary *)aUserInfo 
             error:(NSError*) error;

+ (id) exceptionWithError:(NSError*) error;

- (id) initWithError:(NSError*) error;

@end

@interface NSError (FLErrorException)
- (id) errorWithException:(NSException*) exception;
- (id) initWithException:(NSException*) exception;
- (NSException*) exception;
@end
