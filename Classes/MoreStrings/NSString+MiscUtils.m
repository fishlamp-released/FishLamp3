//
//  NSString+MiscUtils.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 2/11/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSString+MiscUtils.h"

#define KILO    1024.0
#define MEGA    (KILO * KILO)
#define GIGA    (MEGA * KILO)
#define TB      (GIGA * KILO)

@implementation NSString (MiscUtils)

+ (NSString*) localizedStringForByteSize:(UInt64) size {
	
    NSString* outString = nil;
    if ( size < KILO ) {
		outString = [NSString stringWithFormat:@"%lld bytes", size];
	} 
    else if ( size < MEGA ) {
		outString = [NSString stringWithFormat:@"%.2f KB", (double)size /(double)KILO];
	} 
    else if ( size < GIGA ) {
		outString = [NSString stringWithFormat:@"%.2f MB", (double)size /(double)MEGA];
	}
    else if ( size < TB ) {
		outString = [NSString stringWithFormat:@"%.2f GB", (double)size /(double)GIGA];
	}
    else {
		outString = [NSString stringWithFormat:@"%.2f TB", (double)size /(double)TB];
	}
    
    return outString;
}

+ (NSString*) localizedStringForTime:(NSTimeInterval) secs {

	NSMutableString *time = [NSMutableString string];
	if ( secs > 3600 ) {
		[time appendFormat:@"%02ld %@ ", (long)floor(secs / 3600.0), NSLocalizedString(@"hours", nil)];
		secs = fmod(secs, 3600.0);
	}
	if ( secs > 60 ) {
		[time appendFormat:@"%02ld %@ ", (long)floor(secs / 60.0), NSLocalizedString(@"minutes", nil)];
		secs = fmod(secs, 60.0);
	}
	[time appendFormat:@"%02ld %@", (long)ceil(secs), NSLocalizedString(@"seconds", nil)];
	return time;
}

@end

