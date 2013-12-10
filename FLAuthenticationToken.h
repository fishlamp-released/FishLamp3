//
//  FLAuthenticationToken.h
//  FishLampCore
//
//  Created by Mike Fullerton on 11/15/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

@protocol FLAuthenticationSession <NSObject, NSCopying>
- (BOOL) hasExpired;
- (void) touchAuthenticationTimestamp;
@end

@interface FLAuthenticationToken : NSObject<FLAuthenticationSession> {
@private
    id _token;
    NSTimeInterval _authTokenLastUpdateTime;
    NSTimeInterval _lastAuthenticationTimestamp;
    NSTimeInterval _timeoutInterval;
}

@property (readonly, strong, nonatomic) NSString* token;
@property (readonly, assign, nonatomic) NSTimeInterval lastAuthenticationTimestamp;
@property (readonly, assign, nonatomic) NSTimeInterval authTokenLastUpdateTime;
@property (readwrite, assign, nonatomic) NSTimeInterval timeoutInterval;

+ (id) authenticationToken:(NSString*) authenticationToken;

- (void) resetAuthenticationTimestamp;
- (void) touchAuthenticationTimestamp;

@end
