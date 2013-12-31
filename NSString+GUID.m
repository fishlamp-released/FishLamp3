//
//  NSString+GUID.m
//  FishLamp
//
//  Created by Mike Fullerton on 6/3/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSString+GUID.h"
//#import "FLCoreFoundation.h"

@implementation NSString (GUID)

+ (NSString*) guidString {
	CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
	NSString* str = FLAutorelease(FLBridgeTransfer(NSString*, CFUUIDCreateString(kCFAllocatorDefault, uuid)));
	CFRelease(uuid);
	return str;
}

+ (NSString*) zeroGuidString {
	
// TODO. Use static create methods or dispatch_once    
    static NSString* s_zero_guid = nil;
	if(!s_zero_guid) {
		@synchronized(self) {
			if(!s_zero_guid) {
				CFUUIDRef uuid = CFUUIDCreateWithBytes(kCFAllocatorDefault, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
				s_zero_guid = FLBridgeTransfer(NSString*, CFUUIDCreateString(kCFAllocatorDefault, uuid));
				CFRelease(uuid);
			}
		}
	}
	
	return s_zero_guid;
	
}

@end
