//
//  FLScopeStringBuilder.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 2/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLWhitespace.h"
#import "FLStringFormatter.h"
#import "FLStringBuilderSection.h"

@interface FLStringBuilder : FLStringFormatter<FLStringFormatterDelegate> {
@private
    NSMutableArray* _stack;
}

+ (id) stringBuilder;

@property (readonly, strong, nonatomic) FLStringBuilderSection* openedSection;

- (void) openSection:(FLStringBuilderSection*) section;

- (void) closeSection;

- (void) appendSection:(FLStringBuilderSection*) section;

- (void) appendSection:(FLStringBuilderSection*) section
   withSubsectionBlock:(fl_block_t) block;

- (void) closeAllSections;

- (NSString*) buildString;
- (NSString*) buildStringWithWhitespace:(FLWhitespace*) whitespace;
- (NSString*) buildStringWithNoWhitespace;

@end

