// 
// FLAuthenticationCredentials.h

// Project: FishLamp
// Schema: FLSessionObjects
//
// Organization: GreenTongue Software LLC, Mike Fullerton
// 
// License: The FishLamp Framework is released under the MIT License: http://fishlamp.com/license
// 
// Copywrite (C) 2013 GreenTongue Software LLC, Mike Fullerton. All rights reserved.
//

#import "FLModelObject.h"

@protocol FLAuthenticationSession;

@protocol FLAuthenticationCredentials <NSObject, NSCopying, NSMutableCopying>
- (NSString*) userName;
- (NSString*) password;
- (BOOL) canAuthenticate;
@end

@protocol FLMutableAuthenticationCredentials <FLAuthenticationCredentials>
- (void) setUserName:(NSString*) userName;
- (void) setPassword:(NSString*) password;
@end

@interface FLAuthenticationCredentials : FLModelObject<FLAuthenticationCredentials> {
@private
    NSString* _userName;
    NSString* _password;
}

@property (readonly, strong, nonatomic) NSString* userName;
@property (readonly, strong, nonatomic) NSString* password;
@property (readonly, assign, nonatomic) BOOL canAuthenticate;

- (id) initWithUserName:(NSString*) userName 
               password:(NSString*) password ;

+ (id) authenticationCredentials:(NSString*) userName
                        password:(NSString*) password;

@end

@interface FLMutableAuthenticationCredentials : FLAuthenticationCredentials<FLMutableAuthenticationCredentials>
@property (readwrite, strong, nonatomic) NSString* userName;
@property (readwrite, strong, nonatomic) NSString* password;
@end

