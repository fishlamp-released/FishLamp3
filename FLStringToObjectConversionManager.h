//
//  FLStringToObjectConversionManager.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 8/18/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FishLampMinimum.h"

@protocol FLStringToObjectConverting;

@interface FLStringToObjectConversionManager : NSObject {
@private
    NSMutableDictionary* _converters;
}

- (void) addConverter:(id<FLStringToObjectConverting>) encoder;

- (id<FLStringToObjectConverting>) converterForTypeName:(NSString*) typeName;

- (NSString*) stringFromObject:(id) object 
                   forTypeName:(NSString*) typeName;

- (id) objectFromString:(NSString*) string
            forTypeName:(NSString*) forTypeName;

@end

@interface FLDefaultStringToObjectConversionManager : FLStringToObjectConversionManager
+ (id) defaultConverter;
@end

