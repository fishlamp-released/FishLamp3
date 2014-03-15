//
//  FLRandom.h
//  fBee
//
//  Created by Mike Fullerton on 5/21/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLCoreFlags.h"
#import "FishLampCore.h"

#define FLSetRandomSeed() srandom(time(NULL))

NS_INLINE
NSUInteger FLRandomInt(NSUInteger min, NSUInteger max) {
	return min + (NSUInteger) random() % ((max+1) - min);
}


NS_INLINE
BOOL FLGetRandomBool() {
	return FLRandomInt(0, 100) > 50 ? YES : NO;
}
