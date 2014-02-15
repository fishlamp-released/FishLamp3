//
//  FLPrettyString.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 12/30/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton.. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampCore.h"
#import "FLWhitespaceStringFormatter.h"

@class FLWhitespace;
@protocol FLPrettyStringDelegate;

@interface FLPrettyString : FLWhitespaceStringFormatter<FLWhitespaceStringFormatterDelegate> {
@private
    NSMutableString* _string;
}
@property (readonly, strong, nonatomic) NSString* string;

+ (id) prettyString:(FLWhitespace*) whiteSpace;
+ (id) prettyString; // uses default whitespace

+ (id) prettyStringWithString:(NSString*) string;

- (void) deleteAllCharacters;

@end




