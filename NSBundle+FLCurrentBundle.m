//
//  NSBundle+FLCurrentBundle.m
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "NSBundle+FLCurrentBundle.h"

@implementation FLBundleStack 

static NSMutableArray* s_bundleStack = nil;

+ (void) initialize {
    if(!s_bundleStack) {
        s_bundleStack = [[NSMutableArray alloc] init];
        if([NSBundle mainBundle]) {
            [self pushCurrentBundle:[NSBundle mainBundle]];
        }
    }
}

+ (NSBundle*) currentBundle {
    return [s_bundleStack lastObject];
}

+ (void) pushCurrentBundle:(NSBundle*) bundle {
    [s_bundleStack addObject:bundle];
}

+ (void) popCurrentBundle {
    if(s_bundleStack.count > 0) {
        [s_bundleStack removeObjectAtIndex:s_bundleStack.count - 1];
    }
}

@end
