//
//  FLUserDefaultsCredentialStorage.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLUserDefaultsCredentialStorage.h"
#import "NSBundle+FLVersion.h"
#import "FLKeychain.h"

NSString* const FLDefaultsKeyWizardLastUserNameKey = @"CredentialStorageLastUser";
NSString* const FLDefaultsKeyWizardSavePasswordKey = @"CredentialStorageServiceSavePassword";

@interface FLUserDefaultsCredentialStorage ()

- (NSString*) readPasswordForUserName:(NSString*) userName;
- (void) removePasswordForUser:(NSString*) userName;
- (void) writePassword:(NSString*) password forUserName:(NSString*) userName;

@end

@implementation FLUserDefaultsCredentialStorage

FLSynthesizeSingleton(FLUserDefaultsCredentialStorage);

- (id<FLAuthenticationCredentials>) credentialsForLastUser {
    NSString* userName = [[NSUserDefaults standardUserDefaults] objectForKey:FLDefaultsKeyWizardLastUserNameKey];
    return FLStringIsNotEmpty(userName) ? [self readCredentialsForUserName:userName] : nil;
}

- (void) setCredentialsForLastUser:(id<FLAuthenticationCredentials>) newLastUser {
    NSString* lastUserName = [[NSUserDefaults standardUserDefaults] objectForKey:FLDefaultsKeyWizardLastUserNameKey];
    if(lastUserName && ![lastUserName isEqualToString:newLastUser.userName]) {
        [self removePasswordForUser:lastUserName];
    }
    else {
        [self writeCredentials:newLastUser];
        [[NSUserDefaults standardUserDefaults] setObject:newLastUser.userName forKey:FLDefaultsKeyWizardLastUserNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL) rememberPasswordSetting {
    NSNumber* remember = [[NSUserDefaults standardUserDefaults] objectForKey:FLDefaultsKeyWizardSavePasswordKey];
    return remember && [remember boolValue];
}

- (void) setRememberPasswordSetting:(BOOL)savePasswordSetting {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:savePasswordSetting]
                                              forKey:FLDefaultsKeyWizardSavePasswordKey];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) readPasswordForUserName:(NSString*) userName {
    FLAssertStringIsNotEmpty([NSBundle bundleIdentifier], @"bundle identifier must be set to use keychain for password");

    FLAssertStringIsNotEmpty(userName);

    if(userName) {
        return [FLKeychain httpPasswordForUserName:userName withDomain:[NSBundle bundleIdentifier]];
    }

    return nil;
}

- (void) writePassword:(NSString*) password forUserName:(NSString*) userName {
    FLAssertStringIsNotEmpty([NSBundle bundleIdentifier], @"bundle identifier must be set to use keychain for password");

    NSString* existingPassword = [self readPasswordForUserName:userName];

    if(FLStringsAreNotEqual(existingPassword, password)) {
        [FLKeychain setHttpPassword:password forUserName:userName withDomain:[NSBundle bundleIdentifier]];
    }
}

- (void) writeCredentials:(id<FLAuthenticationCredentials>) creds {
    if(FLStringIsNotEmpty(creds.userName)) {
        if([self rememberPasswordSetting]) {
            [self writePassword:creds.password forUserName:creds.userName];
        }
        else {
            [self removePasswordForUser:creds.userName];
        }
    }
}


- (void) removePasswordForUser:(NSString*) userName {
    FLAssertStringIsNotEmpty([NSBundle bundleIdentifier], @"bundle identifier must be set to use keychain for password");

    if(FLStringIsNotEmpty(userName)) {
        [FLKeychain removeHttpPasswordForUserName:userName withDomain:[NSBundle bundleIdentifier]];
    }
}

- (void) removeCredentials:(id<FLAuthenticationCredentials>) credentials {
    FLAssertNotNil(credentials);
    [self removePasswordForUser:credentials.userName];
}

- (FLAuthenticationCredentials*) readCredentialsForUserName:(NSString*) userName {

    if(FLStringIsNotEmpty(userName)) {

        if([self rememberPasswordSetting]) {

            return [FLAuthenticationCredentials authenticationCredentials:userName
                                                                 password:[self readPasswordForUserName:userName]];
        }
        else {
            [self removePasswordForUser:userName];

            return [FLAuthenticationCredentials authenticationCredentials:userName password:nil];
        }

    }

    return nil;
}



@end

//@implementation FLAuthenticationCredentials (NSUserDefaults)
//
//+ (id) authCredentialsFromUserDefaults {
//    FLAuthenticationCredentials* credentials = FLAutorelease([[[self class] alloc] init]);
//    [credentials readFromUserDefaults];
//    return credentials;
//}
//
//- (void) writeToUserDefaults {
//    [[FLUserDefaultsCredentialStorage instance] writeCredentials:self];
//}
//
//- (void) writePasswordToKeychain {
//    [[FLUserDefaultsCredentialStorage instance] writePasswordToKeychain:self];
//}
//
//- (void) readFromUserDefaults {
//    if(!self.userName) {
//        self.rememberPassword = NO;
//        self.password = @"";
//        
//        self.userName =
//        
//        NSNumber* saved = [[NSUserDefaults standardUserDefaults] objectForKey:FLDefaultsKeyWizardSavePasswordKey];
//        self.rememberPassword = saved ? [saved boolValue] : NO;
//
//        [self readPasswordFromKeychain];
//    }
//}
//
//
//
//
//
//@end
