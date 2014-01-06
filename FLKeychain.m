//
//	FLKeychain.m
//	FishLamp
//
//	Created by Mike Fullerton on 12/18/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLKeychain.h"

#import <Security/Security.h>
#import "FishLampSimpleLogger.h"

#if OSX
// non atomic wrappers around sec api

@interface FLKeychain ()

+ (OSStatus) deleteHttpPassword:(NSString*) userName
                         domain:(NSString*) domain;

+ (OSStatus) setHttpPassword:(NSString*) inUserName
                      domain:(NSString*) inDomain
                    password:(NSString*) inPassword;

+ (OSStatus) findHttpPassword:(NSString*) inUserName
                       domain:(NSString*) inDomain
                  outPassword:(NSString**) outPassword
                   outItemRef:(SecKeychainItemRef*) outItemRef;

@end

@implementation FLKeychain

// SecBase.h

+ (OSStatus) deleteHttpPassword:(NSString*) userName domain:(NSString*) domain {

    FLAssertStringIsNotEmpty(userName);
    FLAssertStringIsNotEmpty(domain);

    SecKeychainItemRef itemRef = nil;
	OSStatus err = [FLKeychain findHttpPassword:userName domain:domain outPassword:nil outItemRef:&itemRef];
    
    if ( itemRef ) {
		SecKeychainItemDelete(itemRef);
        CFRelease(itemRef);
    } 
    
    if(err == errSecItemNotFound) {
        err = noErr;
    }

    return err;
}

+ (OSStatus) setHttpPassword:(NSString*) inUserName
                      domain:(NSString*) inDomain
                    password:(NSString*) inPassword  {

    FLAssertStringIsNotEmpty(inUserName);
    FLAssertStringIsNotEmpty(inDomain);

	OSStatus err = [FLKeychain deleteHttpPassword:inUserName domain:inDomain];
    if(err != noErr && err != errSecItemNotFound) {
        return err;
    }
    
    if(FLStringIsEmpty(inPassword)) {
        return noErr;
    }
    
    const char* domain = [inDomain UTF8String];
    const char* username = [inUserName UTF8String];
    const char* password = [inPassword UTF8String];
    
	//  add new password to default keychain
	OSStatus status = SecKeychainAddInternetPassword (
		NULL,								//  search default keychain
		strlen(domain),                     //  serverNameLength
		domain,								//  serverName
		0,                                  //  securityDomainLength
		NULL,								//  security domain
		strlen(username),                   //  account name length
		username,							//  account name
		strlen(""),                         //  pathLength
		"",									//  path on domain
		0,									//  port (0 == ignore)
		kSecProtocolTypeHTTP,				//  http internet protocol
		kSecAuthenticationTypeDefault,		//  default authentication type
		strlen(password),                   //  password length
		password,							//  password data (stores password)
		NULL								//  ref to the actual item (not needed now)
	);

#if DEBUG
    if(status != noErr) {
        FLLog(@"addInternetPassword returned %ld", (long) status);
    }
#endif

    return status;
}

+ (OSStatus) findHttpPassword:(NSString*) inUserName
                       domain:(NSString*) inDomain
                  outPassword:(NSString**) outPassword
                   outItemRef:(SecKeychainItemRef*) outItemRef {

    FLAssertStringIsNotEmpty(inUserName);
    FLAssertStringIsNotEmpty(inDomain);

    if(outPassword) {
        *outPassword = nil;
    }

    if(outItemRef) {
        *outItemRef = nil;
    }

    if(FLStringIsEmpty(inUserName)) {
        return 0;
    }

    const char* domain = [inDomain UTF8String];
    const char* username = [inUserName UTF8String];
    
	void* passwordBytes = nil;
	UInt32 passwordSize = 0;

	//  search the default keychain for a password
	OSStatus err = SecKeychainFindInternetPassword (
		NULL,								//  search default keychain
		strlen(domain),
		domain,								//  domain
		0,
		NULL,								//  security domain
		strlen(username),
		username,							//  username
		strlen(""),
		"",									//  path on domain
		0,									//  port (0 == ignore)
		kSecProtocolTypeHTTP,				//  http internet protocol
		kSecAuthenticationTypeDefault,		//  default authentication type
		&passwordSize,
		&passwordBytes,                     //  password data (stores password)
		outItemRef							//  ptr to the actual item
	);

	if ( err == noErr && outPassword ) {
        *outPassword = [[NSString alloc] initWithBytes:passwordBytes 
                                                length:passwordSize 
                                              encoding:NSUTF8StringEncoding];
    } 

    if(passwordBytes) {
		SecKeychainItemFreeContent(NULL, passwordBytes); 
    }

#if DEBUG
    if(err != noErr && err != errSecItemNotFound) {
        FLLog(@"Find internet password returned: %ld", (long) err);
    }
#endif

    return err;
}

+ (NSString*) httpPasswordForUserName:(NSString*) userName
                           withDomain:(NSString*) domain
{		
	NSString *password = nil;	//  return value

    @synchronized(self) {
        [FLKeychain findHttpPassword:userName domain:domain outPassword:&password outItemRef:nil];
    }

	return FLAutorelease(password);
}

+ (OSStatus) setHttpPassword:(NSString*) password 
                 forUserName:(NSString*) userName
                  withDomain:(NSString*) domain {

    OSStatus status = 0;
	@synchronized(self) {
        status = [FLKeychain setHttpPassword:userName domain:domain password:password];
    }
    return status;
    
}


+ (OSStatus) removeHttpPasswordForUserName:(NSString*) userName 
                            withDomain:(NSString*) domain {
    OSStatus status = 0;
	@synchronized(self) {
        status = [FLKeychain deleteHttpPassword:userName domain:domain];
    }
    return status;
}


@end
#endif
