//
//  FLCredentialsEditor.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/3/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#if NOTUSED

@protocol FLAuthenticationCredentials;
@protocol FLCredentialsEditorDelegate;

@interface FLCredentialsEditor : NSObject {
@private
    id<FLAuthenticationCredentials> _credentials;
    __unsafe_unretained id<FLCredentialsEditorDelegate> _delegate;
    BOOL _editing;
}

@property (readwrite, assign, nonatomic) id<FLCredentialsEditorDelegate> delegate;
@property (readonly, assign, nonatomic, getter=isEditing) BOOL editing;
@property (readonly, strong, nonatomic) id<FLAuthenticationCredentials> credentials;

@property (readwrite, assign, nonatomic) BOOL rememberPassword;
@property (readwrite, strong, nonatomic) NSString* userName;
@property (readwrite, strong, nonatomic) NSString* password;

- (id) initWithCredentials:(id<FLAuthenticationCredentials>) creds;
+ (id) authCredentialEditor:(id<FLAuthenticationCredentials>) creds;

- (void) startEditing;
- (void) stopEditing;

@end

@protocol FLCredentialsEditorDelegate <NSObject>

- (void) credentialsEditor:(FLCredentialsEditor*) editor
willStartEditingCredentials:(id<FLAuthenticationCredentials>) credentials;

- (void) credentialsEditor:(FLCredentialsEditor*) editor
      credentialsDidChange:(id<FLAuthenticationCredentials>) credentials;

- (void) credentialsEditor:(FLCredentialsEditor*) editor
didFinishEditingCredentials:(id<FLAuthenticationCredentials>) credentials;

@end
#endif