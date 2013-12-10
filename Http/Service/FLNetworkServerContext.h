//
//	FLNetworkEndpointHelper.h
//	FishLamp
//
//	Created by Mike Fullerton on 3/22/11.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

#define FLNetworkServerPropertyKeyUrl @"url"
#define FLNetworkServerPropertyKeyTargetNamespace @"namespace"

@interface FLNetworkServerContext : NSObject<NSCoding> {
@private
	NSMutableDictionary* _properties;
}

@property (readonly, retain, nonatomic) NSMutableDictionary* properties;

@end
