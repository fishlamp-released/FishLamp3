//
//	NSObject+Comparison.m
//	FishLamp
//
//	Created by Mike Fullerton on 3/14/11.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSObject+Comparison.h"
#import "NSString+FishLamp.h"

@implementation NSObject (FLComparison)
+ (BOOL) objectIsEqualToObject:(id) object toObject:(id) anotherObject {
	return FLObjectsAreEqual(object, anotherObject);
}
@end

@implementation NSString (FLComparison)
+ (BOOL) objectIsEqualToObject:(id) object toObject:(id) anotherObject {
	return FLStringsAreEqual(object, anotherObject);
}
@end