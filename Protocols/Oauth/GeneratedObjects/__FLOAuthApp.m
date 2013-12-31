// [Generated]
//
// This file was generated at 6/18/12 2:01 PM by Whittle ( http://whittle.greentongue.com/ ). DO NOT MODIFY!!
//
// __FLOAuthApp.m
// Project: FishLamp
// Schema: FLOauth
//
// Copywrite (C) 2012 GreenTongue Software, LLC. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOAuthApp.h"
#import "FLObjectDescriber.h"

#import "FLDatabaseTable.h"

@implementation FLOAuthApp


@synthesize accessTokenUrl = __accessTokenUrl;
@synthesize apiKey = __apiKey;
@synthesize appId = __appId;
@synthesize authorizeUrl = __authorizeUrl;
@synthesize callback = __callback;
@synthesize consumerKey = __consumerKey;
@synthesize consumerSecret = __consumerSecret;
@synthesize requestTokenUrl = __requestTokenUrl;

+ (NSString*) accessTokenUrlKey
{
    return @"accessTokenUrl";
}

+ (NSString*) apiKeyKey
{
    return @"apiKey";
}

+ (NSString*) appIdKey
{
    return @"appId";
}

+ (NSString*) authorizeUrlKey
{
    return @"authorizeUrl";
}

+ (NSString*) callbackKey
{
    return @"callback";
}

+ (NSString*) consumerKeyKey
{
    return @"consumerKey";
}

+ (NSString*) consumerSecretKey
{
    return @"consumerSecret";
}

+ (NSString*) requestTokenUrlKey
{
    return @"requestTokenUrl";
}

- (void) dealloc
{
    FLRelease(__appId);
    FLRelease(__apiKey);
    FLRelease(__consumerKey);
    FLRelease(__consumerSecret);
    FLRelease(__requestTokenUrl);
    FLRelease(__accessTokenUrl);
    FLRelease(__authorizeUrl);
    FLRelease(__callback);
    FLSuperDealloc();
}

- (id) init
{
    if((self = [super init]))
    {
    }
    return self;
}

+ (FLOAuthApp*) oAuthApp
{
    return FLAutorelease([[FLOAuthApp alloc] init]);
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
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"appId" columnType:FLDatabaseTypeText columnConstraints:[NSArray arrayWithObject:[FLPrimaryKeyConstraint primaryKeyConstraint]]]];
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"apiKey" columnType:FLDatabaseTypeText columnConstraints:nil]];
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"consumerKey" columnType:FLDatabaseTypeText columnConstraints:nil]];
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"consumerSecret" columnType:FLDatabaseTypeText columnConstraints:nil]];
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"requestTokenUrl" columnType:FLDatabaseTypeText columnConstraints:nil]];
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"accessTokenUrl" columnType:FLDatabaseTypeText columnConstraints:nil]];
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"authorizeUrl" columnType:FLDatabaseTypeText columnConstraints:nil]];
        [s_table addColumn:[FLDatabaseColumn databaseColumnWithName:@"callback" columnType:FLDatabaseTypeText columnConstraints:nil]];
    });
    return s_table;
}

@end

@implementation FLOAuthApp (ValueProperties) 
@end

// [/Generated]
