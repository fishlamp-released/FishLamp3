//
//	NSNotification+FishLamp.m
//	FishLamp
//
//	Created by Mike Fullerton on 1/23/11.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSNotification+FishLamp.h"

NSString* const NSNotificationCancellableOperationKey = @"FLCancellable";

@implementation NSNotification (FishLamp)

+ (id)notificationWithName:(NSString *)aName object:(id)anObject cancellableOperation:(id) operation
{
	return [NSNotification notificationWithName:aName object:anObject userInfo:[NSDictionary dictionaryWithObject:operation forKey:NSNotificationCancellableOperationKey]];
}

- (id) cancellableOperation
{
	return [self.userInfo objectForKey:NSNotificationCancellableOperationKey];
}


@end
