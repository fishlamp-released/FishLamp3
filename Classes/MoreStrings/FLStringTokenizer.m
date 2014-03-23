//
//  FLStringParser.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringTokenizer.h"



@implementation FLStringTokenizer

@synthesize delimeters = _delimeters;

- (id) init {
    self = [super init];
    if(self) {
        self.delimeters = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    }
    return self;
}

+ (id) stringTokenizer {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_delimeters release];
    [super dealloc];
}
#endif

- (BOOL) isDelimeterChar:(unichar) aChar {
    return [_delimeters characterIsMember:aChar];
}

- (NSRange) rangeOfNextTokenInString:(NSString*) unparsedString {

    NSRange range = { 0, 0 };
    NSUInteger length = unparsedString.length;
    
    for(NSUInteger i = 0; i < length; i++) {
        if(![self isDelimeterChar:[unparsedString characterAtIndex:i]]) {
            break;
        }
        range.location++;
    }

    for(NSUInteger i = range.location; i < length; i++) {
        if([self isDelimeterChar:[unparsedString characterAtIndex:i]]) {
            break;
        }
        range.length++;
    }

    return range;
}

@end


//@interface FLStringTokenizerState : NSObject {
//@private
//    NSString* _string;
//    unsigned long _length;
//    unsigned long _location;
//}
//@property (readonly, strong, nonatomic) NSString* string;
//
//- (id) initWithString:(NSString*) string;
//+ (id) stringTokenizerState:(NSString*) string;
//
//@property (readonly, assign, nonatomic) unsigned long location;
//@property (readonly, assign, nonatomic) unsigned long length;
//@property (readonly, assign, nonatomic) BOOL hasMore;
//@property (readonly, assign, nonatomic) unichar currentChar;
//- (BOOL) substringWithRange:(NSRange) range equalsString:(NSString*) string;
//
//- (BOOL) advanceToNextChar;
//
//@end    
//
//@interface FLStringTokenizer : NSObject {
//}
//
//+ (id) stringTokenizer;
//
//- (NSArray*) parseString:(NSString*) string;
//
//// this is the main thing to override
//- (BOOL) continueParsingToken:(NSRange) tokenRange 
//                    withState:(FLStringTokenizerState*) state;
//
//// optional overrides
//- (BOOL) isWhitespace:(unichar) aChar;
//
//- (BOOL) eatWhitespace:(FLStringTokenizerState*) state;
//
//- (NSRange) parseToken:(FLStringTokenizerState*) state;
//
//- (void) parseStringInState:(FLStringTokenizerState*) state 
//             intoTokenArray:(NSMutableArray*) tokens;
//
//@end

//@interface FLStringTokenizerState ()
//@property (readwrite, strong, nonatomic) NSString* string;
//@end
//
//@implementation FLStringTokenizerState
//
//@synthesize location = _location;
//@synthesize length = _length;
//@synthesize string = _string;
//
//- (id) initWithString:(NSString*) string {
//    self = [super init];
//    if(self) {
//        self.string = string;
//        _location = 0;
//        _length = string.length;
//    }
//    
//    return self;
//}
//
//+ (id) stringTokenizerState:(NSString*) string {
//    return FLAutorelease([[[self class] alloc] initWithString:string]);
//}
//
//#if FL_MRC
//- (void) dealloc {
//    [_string release];
//    [super dealloc];
//}
//#endif
//
//- (BOOL) hasMore {
//    return _location < _length;
//}
//
//- (unichar) currentChar {
//    return [_string characterAtIndex:_location];
//}
//
//- (BOOL) advanceToNextChar {
//    return ++_location < _length;
//}
//
//- (NSString*) stringForRange:(NSRange) range {
//    return [_string substringWithRange:range];
//}
//
//- (BOOL) substringWithRange:(NSRange) range equalsString:(NSString*) string {
//    return [_string compare:string options:NSLiteralSearch range:range] == NSOrderedSame;
//}
//
//@end
//
//@implementation FLStringTokenizer
//
//+ (id) stringTokenizer {
//    return FLAutorelease([[[self class] alloc] init]);
//}
//
//#if FL_MRC
//- (void) dealloc {
//    [super dealloc];
//}
//#endif
//
//- (BOOL) isWhitespace:(unichar) aChar {
//    return [[NSCharacterSet whitespaceCharacterSet] characterIsMember:aChar];
//}
//
//- (BOOL) continueParsingToken:(NSRange) tokenRange withState:(FLStringTokenizerState*) state {
//    return ![self isWhitespace:state.currentChar];
//}
//
//- (BOOL) eatWhitespace:(FLStringTokenizerState*) state {
//    while([self isWhitespace:state.currentChar] && [state advanceToNextChar]) {
//    }
//    
//    return state.hasMore;
//}
//
//- (void) parseStringInState:(FLStringTokenizerState*) state intoTokenArray:(NSMutableArray*) tokens {
//    while(state.hasMore) {
//        NSRange range = [self parseToken:state];
//        if(range.length > 0) {
//            [tokens addObject:[state stringForRange:range]];
//        }
//    }
//}
//
//- (NSArray*) parseString:(NSString*) string {
//    NSMutableArray* tokens = [NSMutableArray array];
//    FLStringTokenizerState* state = [FLStringTokenizerState stringTokenizerState:string];
//    [self parseStringInState:state intoTokenArray:tokens];
//    return tokens;
//}
//
//- (NSRange) parseToken:(FLStringTokenizerState*) state {
//
//    NSRange range = { 0, 0 };
//    
//    if([self eatWhitespace:state]) {
//        range.location = state.location;
//        range.length = 1;
//        while(  [state advanceToNextChar] && 
//                [self continueParsingToken:range withState:state]) {
//            range.length++;
//        }
//    }
//
//    return range;
//}
//
//
//
//@end
