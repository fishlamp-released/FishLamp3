//
//  FLObjcKnownTypes.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 5/11/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampCore.h"

@interface FLObjcKnownTypes : NSObject

+ (NSArray*) loadKnownTypes;
+ (NSDictionary*) knownTypeAliases;

@end
