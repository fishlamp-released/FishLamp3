//
//  NSBundle+FLCurrentBundle.h
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"

@interface FLBundleStack : NSObject

+ (NSBundle*) currentBundle;

+ (void) pushCurrentBundle:(NSBundle*) bundle;
+ (void) popCurrentBundle;

@end
