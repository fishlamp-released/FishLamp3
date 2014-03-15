//
//  FLOSVersion.m
//  FishLamp
//
//  Created by Mike Fullerton on 7/11/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLOSVersion.h"

#if IOS
#import <UIKit/UIKit.h>
#endif

FLVersion FLGetOSVersion()  {
    static FLVersion s_osVersion = { 0, 0, 0, 0 };
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        NSString* versionString = nil;
    
#if IOS
        versionString = [UIDevice currentDevice].systemVersion;
#else
        versionString = [[NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"] objectForKey:@"ProductVersion"];
#endif   
        s_osVersion = FLVersionFromString(versionString);

    });

    return s_osVersion;
}