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




//@protocol FLAuthenticationCredentials <NSObject, NSCopying>
//
//@property (readwrite, strong, nonatomic) NSString* userName;
//@property (readwrite, strong, nonatomic) NSString* password;
//
//@property (readwrite, assign, nonatomic) BOOL isAuthenticated;
//- (void) setUnauthenticated;
//
//@property (readwrite, assign, nonatomic) BOOL rememberPassword;
//@property (readonly, assign, nonatomic) BOOL canAuthenticate;
//
//- (void) clearCredentials;
//
//
//// TODO: abstract this better
//
//@property (readwrite, strong, nonatomic) NSString* authToken;
//@property (readwrite, assign, nonatomic) NSTimeInterval authTokenLastUpdateTime;
//@property (readwrite, assign, nonatomic) NSTimeInterval timeoutInterval;
//@property (readonly, assign, nonatomic) NSTimeInterval lastAuthenticationTimestamp;
//@property (readonly, assign, nonatomic) BOOL authenticationHasExpired;
//
//- (void) resetAuthenticationTimestamp;
//- (void) touchAuthenticationTimestamp;
//
//@end
//
//
//
///*!
// *  A concrete implementation of FLAuthenticationCredentials
// */
//@interface FLAuthenticationCredentials : FLModelObject<FLAuthenticationCredentials> {
//@private
//    NSString* _password;
//    BOOL _isAuthenticated;
//    NSString* _userName;
//    NSTimeInterval _authTokenLastUpdateTime;
//    NSString* _authToken;
//    BOOL _rememberPassword;
//
//    NSTimeInterval _lastAuthenticationTimestamp;
//    NSTimeInterval _timeoutInterval;
//}
//
//+ (id) authenticationCredentials;
//+ (id) authenticationCredentials:(NSString*) userName password:(NSString*) password;
//
//@end