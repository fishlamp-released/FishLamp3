//
//	FLKeychain.h
//	FishLamp
//
//	Created by Mike Fullerton on 12/18/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampMinimum.h"
#import <Security/Security.h>

@interface FLKeychain : NSObject {
}

+ (NSString*) httpPasswordForUserName:(NSString*) userName
                           withDomain:(NSString*) domain;

+ (OSStatus) setHttpPassword:(NSString*) password 
             forUserName:(NSString*) userName 
              withDomain:(NSString*) domain;

+ (OSStatus) removeHttpPasswordForUserName:(NSString*) userName 
                            withDomain:(NSString*) domain;
@end


