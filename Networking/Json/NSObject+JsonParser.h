//
//  NSObject+JsonParser.h
//  FishLamp
//
//  Created by Mike Fullerton on 5/17/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#if REFACTOR

#import "FishLampMinimum.h"

@interface NSObject (FLJsonParser)

- (BOOL) openJsonObjectForKey:(NSString *)key 
	parentKey:(NSString*) parentKey
	parentObject:(id) parentObject 
	outObject:(id*) outObject;
	
- (BOOL) setJsonData:(id) data forKey:(NSString*) key;

@end

#endif
