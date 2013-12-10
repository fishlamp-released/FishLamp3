// [Generated]
//
// This file was generated at 6/18/12 2:01 PM by Whittle ( http://whittle.greentongue.com/ ). DO NOT MODIFY!!
//
// __FLOAuthSession.m
// Project: FishLamp
// Schema: FLOauth
//
// Copywrite (C) 2012 GreenTongue Software, LLC. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOAuthSession.h"
#import "FLObjectDescriber.h"

#import "FLDatabaseTable.h"

@implementation FLOAuthSession


@synthesize appName = __appName;
@synthesize oauth_token = __oauth_token;
@synthesize oauth_token_secret = __oauth_token_secret;
@synthesize screen_name = __screen_name;
@synthesize userGuid = __userGuid;
@synthesize user_id = __user_id;

+ (NSString*) appNameKey
{
    return @"appName";
}

+ (NSString*) oauth_tokenKey
{
    return @"oauth_token";
}

+ (NSString*) oauth_token_secretKey
{
    return @"oauth_token_secret";
}

+ (NSString*) screen_nameKey
{
    return @"screen_name";
}

+ (NSString*) userGuidKey
{
    return @"userGuid";
}

+ (NSString*) user_idKey
{
    return @"user_id";
}

- (void) copySelfTo:(id) object
{
//    [super copySelfTo:object];
    ((FLOAuthSession*)object).userGuid = FLCopyOrRetainObject(__userGuid);
    ((FLOAuthSession*)object).appName = FLCopyOrRetainObject(__appName);
    ((FLOAuthSession*)object).oauth_token_secret = FLCopyOrRetainObject(__oauth_token_secret);
    ((FLOAuthSession*)object).user_id = FLCopyOrRetainObject(__user_id);
    ((FLOAuthSession*)object).screen_name = FLCopyOrRetainObject(__screen_name);
    ((FLOAuthSession*)object).oauth_token = FLCopyOrRetainObject(__oauth_token);
}

- (id) copyWithZone:(NSZone*) zone
{
    id outObject = [[[self class] alloc] init];
    [self copySelfTo:outObject];
    return outObject;
}

- (void) dealloc
{
    FLRelease(__userGuid);
    FLRelease(__appName);
    FLRelease(__oauth_token);
    FLRelease(__oauth_token_secret);
    FLRelease(__user_id);
    FLRelease(__screen_name);
    FLSuperDealloc();
}

- (void) encodeWithCoder:(NSCoder*) aCoder
{
    if(__userGuid) [aCoder encodeObject:__userGuid forKey:@"__userGuid"];
    if(__appName) [aCoder encodeObject:__appName forKey:@"__appName"];
    if(__oauth_token) [aCoder encodeObject:__oauth_token forKey:@"__oauth_token"];
    if(__oauth_token_secret) [aCoder encodeObject:__oauth_token_secret forKey:@"__oauth_token_secret"];
    if(__user_id) [aCoder encodeObject:__user_id forKey:@"__user_id"];
    if(__screen_name) [aCoder encodeObject:__screen_name forKey:@"__screen_name"];
}

- (id) init
{
    if((self = [super init]))
    {
    }
    return self;
}

- (id) initWithCoder:(NSCoder*) aDecoder
{
    if((self = [super init]))
    {
        __userGuid = FLRetain([aDecoder decodeObjectForKey:@"__userGuid"]);
        __appName = FLRetain([aDecoder decodeObjectForKey:@"__appName"]);
        __oauth_token = FLRetain([aDecoder decodeObjectForKey:@"__oauth_token"]);
        __oauth_token_secret = FLRetain([aDecoder decodeObjectForKey:@"__oauth_token_secret"]);
        __user_id = FLRetain([aDecoder decodeObjectForKey:@"__user_id"]);
        __screen_name = FLRetain([aDecoder decodeObjectForKey:@"__screen_name"]);
    }
    return self;
}

+ (FLOAuthSession*) oAuthSession
{
    return FLAutorelease([[FLOAuthSession alloc] init]);
}



- (BOOL) isModelObject {
    return YES;
}
+ (BOOL) isModelObject {
    return YES;
}
+ (FLDatabaseTable*) sharedDatabaseTable

{
    static FLDatabaseTable* s_table = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        s_table = [[FLDatabaseTable alloc] initWithClass:[self class]];
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"userGuid" columnType:FLDatabaseTypeText columnConstraints:[NSArray arrayWithObject:[FLPrimaryKeyConstraint primaryKeyConstraint]]]];
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"appName" columnType:FLDatabaseTypeText columnConstraints:[NSArray arrayWithObjects:[FLNotNullConstraint notNullConstraint], nil]]];
        [s_table addIndex:[FLDatabaseIndex databaseIndex:@"appName" indexProperties:FLDatabaseColumnIndexPropertyNone]];
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"oauth_token" columnType:FLDatabaseTypeText columnConstraints:nil]];
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"oauth_token_secret" columnType:FLDatabaseTypeText columnConstraints:nil]];
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"user_id" columnType:FLDatabaseTypeText columnConstraints:nil]];
        [s_table addIndex:[FLDatabaseIndex databaseIndex:@"user_id" indexProperties:FLDatabaseColumnIndexPropertyNone]];
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"screen_name" columnType:FLDatabaseTypeText columnConstraints:nil]];
    });
    return s_table;
}

@end

@implementation FLOAuthSession (ValueProperties) 
@end

// [/Generated]
