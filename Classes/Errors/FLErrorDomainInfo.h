//
//  FLErrorDomainInfo.h
//  FishLampFrameworks
//
//  Created by Mike Fullerton on 8/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#if REFACTOR

#import "FishLampCore.h"
#import "FLProperties.h"

@protocol FLErrorDomainInfo <NSObject>
- (NSString*) stringFromErrorCode:(int) errorCode;

@end

@interface FLErrorDomainInfo : NSObject {
@private
    NSMutableDictionary* _domains;
}

FLSingletonProperty(FLErrorDomainInfo);

- (FLErrorDomainInfo*) infoForErrorDomain:(NSString*) errorDomain;
- (void) setInfo:(FLErrorDomainInfo*) info forDomain:(NSString*) domain;

- (NSString*) stringFromErrorCode:(int) errorCode withDomain:(NSString*) domain;


@end


#endif