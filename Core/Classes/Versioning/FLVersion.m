//
//  FLVersion.m
//  FishLamp
//
//  Created by Mike Fullerton on 5/9/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLVersion.h"

const FLVersion FLVersionZero =  { 0, 0, 0, 0 };

FLVersion FLVersionFromString(NSString* versionString) {

    if(!versionString) {
        return FLVersionZero;
    }

	FLVersion version = FLVersionZero;
	
    NSArray* split = [versionString componentsSeparatedByString:@"."];
	
    if(split.count >= 4) {
    	version.build = [[split objectAtIndex:3] intValue];
	}
    
    if(split.count >= 3) {
		version.revision = [[split objectAtIndex:2] intValue];
	}
	
    if(split.count >= 2) {
		version.minor = [[split objectAtIndex:1] intValue];
	}
	
    if(split.count >= 1) {
		version.major = [[split objectAtIndex:0] intValue];
	}
	
    return version;
}

NSString* FLStringFromVersion(FLVersion version) {
	return [NSString stringWithFormat:@"%d.%d.%d.%d", version.major, version.minor, version.revision, version.build];
}

