//
//  FLTypeSpecificEnumSet.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/30/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLEnumSet.h"

typedef NSInteger FLEnumSetEnumValueLookup(NSString* string);
typedef NSString* FLEnumSetEnumStringLookup(NSInteger theEnum);

#define FLTypeSpecificEnumSetDefaultDelimeter @","
#define FLTypeSpecificEnumSetDefaultParseDelimeters @" ,"


@interface FLTypeSpecificEnumSet : FLEnumSet {
@private
    FLEnumSetEnumValueLookup* _valueLookup;
    FLEnumSetEnumStringLookup* _stringLookup;
}

+ (id) typeSpecificEnumSet:(FLEnumSetEnumValueLookup*) valueLookup 
              stringLookup:(FLEnumSetEnumStringLookup*) stringLookup;

- (id) initWithValueLookup:(FLEnumSetEnumValueLookup*) valueLookup 
              stringLookup:(FLEnumSetEnumStringLookup*) stringLookup;

@property (readwrite, strong, nonatomic) NSString* concatenatedString;

//- (NSString*) concatenatedStringWithDelimiter:(NSString*) delimeter;
//- (void) setConcatenatedString:(NSString*) string withParseDelimiter:(NSString*) delimeter;

- (void) addEnum:(NSInteger) theEnum;

- (NSString*) stringForEnum:(NSInteger) theEnum;
- (NSInteger) enumForString:(NSString*) theString;

@end