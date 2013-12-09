//
//  NSBundle+FLAdditions.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 3/30/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampMinimum.h"

@interface NSBundle (FLAdditions)

- (NSURL*) URLInInfoDictionaryForKey:(NSString*) key;

@end
