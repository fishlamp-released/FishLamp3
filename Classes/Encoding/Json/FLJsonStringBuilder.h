//
//  FLJsonBuilder.h
//  FishLamp
//
//  Created by Mike Fullerton on 5/11/11.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringBuilder.h"

@class FLStringToObjectConversionManager;

@interface FLJsonStringBuilder : FLStringBuilder {
@private
	FLStringToObjectConversionManager* _dataEncoder;
}

@property (readwrite, retain, nonatomic) FLStringToObjectConversionManager* dataEncoder;

- (void) streamObject:(id) object;

//- (void) addObjectAsFunction:(NSString*) functionName object:(id) object;

@end

