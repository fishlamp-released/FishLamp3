//
//  FLPrettyAttributedString.h
//  FishLampCore
//
//  Created by Mike Fullerton on 8/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLWhitespaceStringFormatter.h"

@protocol FLPrettyAttributedStringDelegate;

@interface FLPrettyAttributedString : FLWhitespaceStringFormatter<FLWhitespaceStringFormatterDelegate> {
@private
    NSMutableAttributedString* _attributedString;
}

+ (id) prettyAttributedString:(FLWhitespace*) whitespace;
+ (id) prettyAttributedString;
+ (id) prettyAttributedStringWithString:(NSString*) string;

- (void) deleteAllCharacters;

@end

