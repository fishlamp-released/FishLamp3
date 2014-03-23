//
//  FLStringParser.h
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLampCore.h"
#import "FLStringTokenizer.h"

@interface FLStringParser : NSObject {
@private
    NSMutableArray* _tokens;
    NSMutableArray* _tokenizers;
    NSMutableArray* _history;
    NSString* _originalString;
    NSRange _remainingRange;
    NSString* _unparsedString;
}
@property (readonly, strong, nonatomic) NSArray* tokens;

@property (readonly, copy, nonatomic) NSString* originalString;

@property (readonly, strong, nonatomic) NSString* unparsedString;

@property (readonly, assign, nonatomic) NSRange remainingRange;

- (id) initWithString:(NSString*) string;
+ (id) stringParser:(NSString*) string;

@property (readonly, strong, nonatomic) NSString* lastToken;
@property (readonly, assign, nonatomic) BOOL hasMore;
- (NSString*) parseNextToken;
- (NSString*) revertToPreviousToken;

- (void) pushTokenizer:(id<FLStringTokenizer>) tokenizer;
- (void) popTokenizer;

- (void) removeTokenizer:(id<FLStringTokenizer>) tokenizer;

@end
