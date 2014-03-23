//
//  FLStringBuilderSection.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/29/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampCore.h"
#import "FLWhitespace.h"
#import "FLStringFormatter.h"
#import "FLPrettyString.h"
#import "FLWhitespaceStringFormatter.h"

@class FLStringBuilder;

@interface FLStringBuilderSection : FLStringFormatter<FLStringFormatterDelegate> {
@private
    NSMutableArray* _lines;
    BOOL _needsLine;
    BOOL _lineOpen;

    __unsafe_unretained id _parentSection;
    __unsafe_unretained id _stringDocument;
}
@property (readonly, strong, nonatomic) NSArray* lines;
@property (readonly, assign, nonatomic) id parentSection;
@property (readonly, assign, nonatomic) id stringDocument;

+ (id) stringBuilderSection;

- (void) appendSection:(FLStringBuilderSection*) section;

// optional overrides
- (void) willBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter;
- (void) didBuildWithStringFormatter:(id<FLStringFormatter>) stringFormatter;
- (void) didMoveToParent:(FLStringBuilderSection*) parent;

@end


