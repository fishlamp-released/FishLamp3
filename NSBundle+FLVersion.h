//
//  NSBundle+FLVersion.h
//  FishLamp
//
//  Created by Mike Fullerton on 11/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"
#import "NSBundle+FLCurrentBundle.h"
#import "FLVersion.h"

extern NSString* const FLBundleVersionKey;
extern NSString* const FLBundleShortVersionKey;
extern NSString* const FLBundleAppNameKey;
extern NSString* const FLBundleIdentifierKey;

@interface NSBundle (FLVersion)

+ (NSString*) bundleShortVersion;
+ (NSString*) bundleVersion;
+ (NSString*) bundleName;
+ (NSString*) bundleIdentifier;

// combination of bundleShortVersion + bundleVersion
+ (FLVersion) appVersion;
+ (NSString*) appVersionString;

+ (NSDictionary*) fakeBundle;
+ (void) setFakeBundle:(NSDictionary*) dictionary;

+ (void) setFakeBundleIdentifier:(NSString*) bundleIdentifier
                      bundleName:(NSString*) appName
                      appVersion:(FLVersion) version;

// by default this is loaded from [NSBundle userAgent];
+ (void) setDefaultUserAgent:(NSString*) userAgent;

+ (NSString*) defaultUserAgent;

@end

