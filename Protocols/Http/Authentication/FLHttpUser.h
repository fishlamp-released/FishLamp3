//
//  FLHttpUser.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/28/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

#import "FLAuthenticationCredentials.h"
#import "FLAuthenticationToken.h"
#import "FLAuthenticatedEntity.h"

@interface FLHttpUser : NSObject<FLAuthenticatedEntity, NSCopying> {
@private
    id _authenticationCredentials;
    id<FLAuthenticationSession> _session;

}
- (id) initWithAutheticationCredentials:(id<FLAuthenticationCredentials>) credentials;

// TODO: abstract this better.
- (NSString*) cacheFolderPath;
- (NSString*) userFolderPath;
- (NSString*) userDataFolderPath;

@end
