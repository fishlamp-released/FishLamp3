//
//  NSBundle.m
//  FishLamp
//
//  Created by Mike Fullerton on 11/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSBundle+FLVersion.h"

NSString* const FLBundleVersionKey       = @"CFBundleVersion";
NSString* const FLBundleShortVersionKey  = @"CFBundleShortVersionString";
NSString* const FLBundleAppNameKey       = @"CFBundleName";
NSString* const FLBundleIdentifierKey    = @"CFBundleIdentifier";

static NSString* s_defaultUserAgent = nil;

#if OSX
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/sysctl.h>

// TODO: move this to an OSX lib
NSString* FLMachineModel()
{
    size_t len = 0;
    sysctlbyname("hw.model", NULL, &len, NULL, 0);

    if (len)
    {
        char *model = malloc(len*sizeof(char));
        sysctlbyname("hw.model", model, &len, NULL, 0);
        NSString *model_ns = [NSString stringWithUTF8String:model];
        free(model);
        return model_ns;
    }

    return @"UnknownMac"; //incase model name can't be read
}
#endif

@implementation NSBundle (FLVersion)

static NSDictionary* s_fakeBundle = nil;

+ (NSDictionary*) fakeBundle {
    return s_fakeBundle;
}

+ (void) setFakeBundle:(NSDictionary*) dictionary {
    FLSetObjectWithRetain(s_fakeBundle, dictionary);
}

+ (NSBundle*) bundleForInfo {
    NSBundle* bundle = [FLBundleStack currentBundle];
    if(!bundle) {
        bundle = [NSBundle mainBundle];
    }
    return bundle;
}

+ (NSDictionary*) infoDictionary {
    return s_fakeBundle ? s_fakeBundle : [[self bundleForInfo] infoDictionary];
}

+ (id) objectForKey:(id) key {

    id value = [[[FLBundleStack currentBundle] infoDictionary] objectForKey:key];

    if(!value && s_fakeBundle) {
        value = [s_fakeBundle objectForKey:key];
    }

    FLAssertNotNilWithComment(value, @"unable to get version info from bundle for key: %@", key);

    return value;
}

+ (NSString*) bundleVersion {
    return [self objectForKey:FLBundleVersionKey];
}

+ (NSString*) bundleShortVersion {
    return [self objectForKey:FLBundleShortVersionKey];
}

+ (NSString*) bundleName {
	return [self objectForKey:FLBundleAppNameKey];
}

+ (NSString*) bundleIdentifier {
	return [self objectForKey:FLBundleIdentifierKey];
}

+ (void) setFakeBundleIdentifier:(NSString*) bundleIdentifier
                      bundleName:(NSString*) appName
                      appVersion:(FLVersion) appVersion {

    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
        bundleIdentifier, FLBundleIdentifierKey,
        appName, FLBundleAppNameKey,
        [NSString stringWithFormat:@"%d.%d.%d", appVersion.major, appVersion.minor, appVersion.revision], FLBundleShortVersionKey,
        [NSString stringWithFormat:@"%d", appVersion.build], FLBundleVersionKey,
        nil];
        
    [self setFakeBundle:dict];
}            

+ (FLVersion) appVersion {
    FLVersion build = FLVersionFromString([self bundleVersion]);
    FLVersion version = FLVersionFromString([self bundleShortVersion]);

    FLAssert(build.minor == 0 && build.revision == 0 && build.build == 0);

    version.build = build.major;

    return version;
}

+ (NSString*) appVersionString {
    return FLStringFromVersion([self appVersion]);
}


+ (NSString*) defaultUserAgentString {
    
#if OSX
    NSString* defaultUserAgent = [NSString stringWithFormat:@"%@/%@ (%@; %@; %@;)",
        [self bundleName],
        [self appVersionString],
        [self bundleIdentifier],
        FLMachineModel(),
//                [UIDevice currentDevice].machineName,
//                [UIDevice currentDevice].systemName,
//                [UIDevice currentDevice].systemVersion];
        FLStringFromVersion(FLGetOSVersion())];
#else

    NSString* defaultUserAgent = [NSString stringWithFormat:@"%@/%@ (%@; %@; %@;)",
        [self bundleName],
        [self appVersionString],
        [self bundleIdentifier],
// TODO (MWF): fix this
        @"iDevice",
//                [UIDevice currentDevice].machineName,
//                [UIDevice currentDevice].systemName,
//                [UIDevice currentDevice].systemVersion];
        FLStringFromVersion(FLGetOSVersion())];


#endif

    return defaultUserAgent;
}

+ (NSString*) defaultUserAgent {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!s_defaultUserAgent) {
            [self setDefaultUserAgent:[self defaultUserAgentString]];
        }
    });

    return s_defaultUserAgent;
}   

+ (void) setDefaultUserAgent:(NSString*) userAgent {
    FLSetObjectWithRetain(s_defaultUserAgent, userAgent);
}

@end
