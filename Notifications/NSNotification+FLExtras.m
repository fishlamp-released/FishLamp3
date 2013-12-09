//
//	NSNotification+FLExtras.m
//	FishLamp
//
//	Created by Mike Fullerton on 1/23/11.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSNotification+FLExtras.h"

NSString* const NSNotificationCancellableOperationKey = @"FLCancellable";

@implementation NSNotification (FLExtras)

+ (id)notificationWithName:(NSString *)aName object:(id)anObject cancellableOperation:(id) operation
{
	return [NSNotification notificationWithName:aName object:anObject userInfo:[NSDictionary dictionaryWithObject:operation forKey:NSNotificationCancellableOperationKey]];
}

- (id) cancellableOperation
{
	return [self.userInfo objectForKey:NSNotificationCancellableOperationKey];
}


@end
