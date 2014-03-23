//
//  FLCredentialsStorage.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAuthenticationCredentials.h"

@protocol FLCredentialsStorage <NSObject>
@property (readwrite, nonatomic, assign) id<FLAuthenticationCredentials> credentialsForLastUser;

- (FLAuthenticationCredentials*) readCredentialsForUserName:(NSString*) userName;
- (void) writeCredentials:(id<FLAuthenticationCredentials>) credentials;
- (void) removeCredentials:(id<FLAuthenticationCredentials>) credentials;

@property (readwrite, nonatomic, assign) BOOL rememberPasswordSetting;

@end
