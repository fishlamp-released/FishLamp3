//
//  FLCredentialsEditor.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCredentialsEditor.h"
#import "FLAuthenticationCredentials.h"
#if NOTUSED

@interface FLCredentialsEditor ()
@property (readwrite, assign, nonatomic, getter=isEditing) BOOL editing;
@end

@implementation FLCredentialsEditor

@synthesize editing = _editing;
@synthesize delegate = _delegate;
@synthesize credentials = _credentials;

#if FL_MRC
- (void) dealloc {
	[_credentials release];
	[super dealloc];
}
#endif

- (id) initWithCredentials:(id<FLAuthenticationCredentials>) creds {
	self = [super init];
	if(self) {
        _credentials = FLRetain(creds);
    }
	return self;
}                 

+ (id) authCredentialEditor:(id<FLAuthenticationCredentials>) creds {
     return FLAutorelease([[[self class] alloc] initWithCredentials:creds]);
}

- (void) openIfNeeded {
    if(!_editing) {
        _editing = YES;
        [self startEditing];
    }
}

- (NSString*) userName {
    FLAssertNotNil(_credentials);
    return _credentials.userName;
}

- (void) didChange {
    [self startEditing];
    [self.delegate credentialsEditor:self credentialsDidChange:self.credentials];
}

- (void) setUserName:(NSString*) userName {
    FLAssertNotNil(_credentials);

    if(FLStringsAreNotEqual(_credentials.userName, userName)) {
        [self didChange];
        _credentials.userName = userName;
    }
}

- (NSString*) password {
    FLAssertNotNil(_credentials);
    return _credentials.password;
}

- (void) setPassword:(NSString*) password {
    FLAssertNotNil(_credentials);
    if(FLStringsAreNotEqual(_credentials.password, password)) {
        [self didChange];
        _credentials.password = password;
    }
}

- (BOOL) rememberPassword {
    FLAssertNotNil(_credentials);
    return _credentials.rememberPassword;
}

- (void) setRememberPassword:(BOOL) remember {
    [self openIfNeeded];
    FLAssertNotNil(_credentials);

    if( remember != _credentials.rememberPassword) {
        [self didChange];
        _credentials.rememberPassword = remember;
    }
}

- (void) startEditing {
    if(!_editing) {
        FLAssertNotNil(_credentials);
        [self.delegate credentialsEditor:self willStartEditingCredentials:self.credentials];
        _editing = YES;
    }
}

- (void) stopEditing {
    if(_editing) {
        FLAssertNotNil(_credentials);
        [self.delegate credentialsEditor:self didFinishEditingCredentials:self.credentials];
        _editing = NO;
    }
}

//- (id<FLAuthenticationCredentials>) credentials {
//    return FLCopyWithAutorelease(_credentials);
//}
//
//- (void) setCredentials:(id<FLAuthenticationCredentials>) creds {
//    FLSetObjectWithMutableCopy(_credentials, creds);
//}


@end
#endif