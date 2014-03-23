//
//  FLHttpUser.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/28/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLHttpUser.h"
#import "NSBundle+FLVersion.h"

@implementation FLHttpUser

@synthesize authenticationCredentials = _authenticationCredentials;
@synthesize session= _session;

- (id) init {
	return [self initWithAutheticationCredentials:nil];
}

- (id) initWithAutheticationCredentials:(id<FLAuthenticationCredentials>) credentials {
	self = [super init];
	if(self) {
        _authenticationCredentials = [((id)credentials) copy];
	}
	return self;
}

+ (id) httpUser:(id<FLAuthenticationCredentials>) credentials {
    return FLAutorelease([[[self class] alloc] initWithAutheticationCredentials:credentials]);
}

#if FL_MRC
- (void) dealloc {
    [_session release];
    [_authenticationCredentials release];
    [super dealloc];
}
#endif

- (NSString*) userName {
    return [_authenticationCredentials userName];
}

- (BOOL) isAuthenticated {
    return self.session != nil;
}

- (void) setUnathenticated {
    self.session = nil;
}

- (id) copyWithZone:(NSZone *)zone {
    FLHttpUser* user = [[[self class] alloc] init];
    user.authenticationCredentials = self.authenticationCredentials;
    user.session = self.session;
    return user;
}

- (NSString*) userFolderPath {
    return [NSString stringWithFormat:@"%@/%@", [NSBundle bundleIdentifier], self.userName];
}

- (NSString*) cacheFolderPath {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [cachePath stringByAppendingPathComponent:[self userFolderPath]];
}
 
- (NSString*) userDataFolderPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:[self userFolderPath]];
} 
 

@end
