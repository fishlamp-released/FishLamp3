//
//  FLToolCommandOption.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampMinimum.h"
#import "FLStringParser.h"

@interface FLToolCommandOption : NSObject {
@private
    NSMutableSet* _optionKeys;
    NSString* _help; 
}

@property (readonly, strong, nonatomic) NSSet* optionKeys;
@property (readwrite, strong, nonatomic) NSString* help;

- (id) initWithKeys:(NSString*) name;
+ (id) toolCommandOption:(NSString*) keys;
+ (id) toolCommandOption;

- (void) addKeys:(NSString*) keys; // space and/or comma delimited.

- (void) printHelpToStringFormatter:(FLStringFormatter*) output;

// override point
- (id) parseOptionData:(FLStringParser*) input siblings:(NSDictionary*) siblings;

- (void) printUsage:(FLStringFormatter*) output;


@end
