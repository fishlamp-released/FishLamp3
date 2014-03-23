// 
// FLAuthenticationCredentials.m

// Project: FishLamp
// Schema: FLSessionObjects
// 
// Organization: GreenTongue Software LLC, Mike Fullerton
// 
// License: The FishLamp Framework is released under the MIT License: http://fishlamp.com/license
// 
// Copywrite (C) 2013 GreenTongue Software LLC, Mike Fullerton. All rights reserved.
// 

#import "FLAuthenticationCredentials.h"
#import "FLAuthenticationToken.h"

@interface FLAuthenticationCredentials ()
@property (readwrite, strong, nonatomic) NSString* userName;
@property (readwrite, strong, nonatomic) NSString* password;
@end

@implementation FLAuthenticationCredentials
 
@synthesize userName = _userName;
@synthesize password = _password;

- (id) init {	
    return [self initWithUserName:nil password:nil];
}

- (id) initWithUserName:(NSString*) userName 
               password:(NSString*) password {

	self = [super init];
	if(self) {
        self.userName = userName;
        self.password = password;
	}
	return self;
}       

+ (id) authenticationCredentials:(NSString*) userName 
              password:(NSString*) password  {
    return FLAutorelease([[[self class] alloc] initWithUserName:userName 
                                                       password:password ]);
}

+ (id) credentials {
    return FLAutorelease([[[self class] alloc] init]);
}


#if FL_MRC
- (void) dealloc {
    [_userName release];
	[_password release];
    [super dealloc];
}
#endif

- (id)mutableCopyWithZone:(NSZone *)zone {
    return FLModelObjectCopy(self, [FLMutableAuthenticationCredentials class]); 
}

- (BOOL) canAuthenticate {
    return FLStringIsNotEmpty(self.userName) && FLStringIsNotEmpty(self.password);
}

@end

@implementation FLMutableAuthenticationCredentials
@dynamic userName;
@dynamic password;
@end
