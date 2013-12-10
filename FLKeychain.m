//
//	FLKeychain.m
//	FishLamp
//
//	Created by Mike Fullerton on 12/18/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLKeychain.h"
#import "FLCoreFoundation.h"

#import <Security/Security.h>

#if OSX
// non atomic wrappers around sec api

extern OSStatus FLKeychainSetHttpPassword(     NSString* inUsername,
                                        NSString* inDomain,
                                        NSString* inPassword );
                                        
extern OSStatus FLKeychainFindHttpPassword(    NSString* inUserName,
                                        NSString* inDomain,
                                        NSString** outPassword,
                                        SecKeychainItemRef *outItemRef);

extern OSStatus FLKeychainDeleteHttpPassword(NSString* userName, NSString* domain);                                                                                


// SecBase.h

OSStatus FLKeychainDeleteHttpPassword(NSString* userName, NSString* domain) {
    FLAssertStringIsNotEmpty(userName);
    FLAssertStringIsNotEmpty(domain);

    SecKeychainItemRef itemRef = nil;
	OSStatus err = FLKeychainFindHttpPassword(userName, domain, nil, &itemRef);
    
    if ( itemRef ) {
		SecKeychainItemDelete(itemRef);
        CFRelease(itemRef);
    } 
    
    if(err == errSecItemNotFound) {
        err = noErr;
    }

    return err;
}

OSStatus FLKeychainSetHttpPassword(     NSString* inUserName,
                                        NSString* inDomain,
                                        NSString* inPassword ) {

    FLAssertStringIsNotEmpty(inUserName);
    FLAssertStringIsNotEmpty(inDomain);

	OSStatus err = FLKeychainDeleteHttpPassword(inUserName, inDomain);
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

OSStatus FLKeychainFindHttpPassword(    NSString* inUserName,
                                        NSString* inDomain,
                                        NSString** outPassword,
                                        SecKeychainItemRef *outItemRef) {

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


@implementation FLKeychain
	
+ (NSString*) httpPasswordForUserName:(NSString*) userName
                           withDomain:(NSString*) domain
{		
	NSString *password = nil;	//  return value

    @synchronized(self) {
        FLKeychainFindHttpPassword(userName, domain, &password, nil);
    }

	return FLAutorelease(password);
}

+ (OSStatus) setHttpPassword:(NSString*) password 
         forUserName:(NSString*) userName 
          withDomain:(NSString*) domain {

    OSStatus status = 0;
	@synchronized(self) {
        status = FLKeychainSetHttpPassword(userName, domain, password);
    }
    return status;
    
}


+ (OSStatus) removeHttpPasswordForUserName:(NSString*) userName 
                            withDomain:(NSString*) domain {
    OSStatus status = 0;
	@synchronized(self) {
        status = FLKeychainDeleteHttpPassword(userName, domain);
    }
    return status;
}


@end
#endif
