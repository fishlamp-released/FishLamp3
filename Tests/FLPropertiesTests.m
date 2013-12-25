//
//  FLPropertiesTests.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/25/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPropertiesTests.h"

@implementation FLPropertiesTests

//CFTypeRef ptr = (__bridge_retained CFTypeRef) [[FLWeakRefTestObject alloc] initWithBlock:^(id sender){
//}];
//
//_weakRef = [FLWeakReference weakReference:(__bridge id) ptr];
//[_weakRef addNotifierWithBlock:^(id sender) {
//    [asyncTask setFinished];
//}];
//
//NSLog(@"This is from the background thread: %@", [_weakRef object]);
//
//CFRelease(ptr);

//+ (void) addTestCasesToSanityChecks:(NSMutableArray*) array {
////    [array addObject:autorelease([FLCriticalWeakRefTest new])];
//}


+ (NSString*) testGroupName {
    return @"Framework";
}

@end
