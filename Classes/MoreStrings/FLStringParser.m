//
//  FLStringParser.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 1/9/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLStringParser.h"

@interface FLStringParser ()
@property (readwrite, strong, nonatomic) NSString* unparsedString;
@end

@implementation FLStringParser

@synthesize originalString = _originalString;
@synthesize tokens = _tokens;
@synthesize remainingRange = _remainingRange;
@synthesize unparsedString = _unparsedString;

- (id) initWithString:(NSString*) string {
    self = [super init];
    if(self) {
        _originalString = [string copy];
        _tokens = [[NSMutableArray alloc] init];
        _remainingRange = NSMakeRange(0, _originalString.length);
        _tokenizers = [[NSMutableArray alloc] init];
        _history = [[NSMutableArray alloc] init];
        
        [self pushTokenizer:[FLStringTokenizer stringTokenizer]];
    }
    return self;
}

+ (id) stringParser:(NSString*) string {
    return FLAutorelease([[[self class] alloc] initWithString:string]);
}

#if FL_MRC
- (void) dealloc {
    [_history release];
    [_tokenizers release];
    [_originalString release];
    [_tokens release];
    [_unparsedString release];
    [super dealloc];
}
#endif

- (NSString*) unparsedString {
    if(!_unparsedString) {
        if(_remainingRange.length > 0) {
            _unparsedString = FLRetain([_originalString substringWithRange:_remainingRange]);
        }
    }
    
    return _unparsedString;
}


- (NSString*) parseNextToken {

    if(_remainingRange.length > 0) {
        [_history addObject:[NSValue valueWithRange:_remainingRange]];
    
        NSString* unparsedString = self.unparsedString;

        NSRange range = [[_tokenizers lastObject] rangeOfNextTokenInString:unparsedString];
        
        NSUInteger advancedBy = range.location + range.length;
        
        FLConfirm(advancedBy > 0, @"Tokenizer must move range forward");

        NSString* token = [unparsedString substringWithRange:range];
        [_tokens addObject:token];
        
        _remainingRange.location += advancedBy;
        _remainingRange.length -= advancedBy;
        self.unparsedString = [_originalString substringWithRange:_remainingRange];
        
        return token;
    }
    
    return nil;
}

- (NSString*) revertToPreviousToken {
    if(_history.count) {
        NSValue* last = [_history lastObject];
        if(last) {
            _remainingRange = [last rangeValue];
        }
    }
    
    if(_tokens.count) {
        [_tokens removeObjectAtIndex:_tokens.count - 1];
    }
    
    self.unparsedString = nil;
    
    return [self lastToken];
}


- (NSString*) lastToken {
    return _tokens.count ? _tokens.lastObject : nil;
}

- (BOOL) hasMore {
    return _remainingRange.length > 0;
}

- (void) pushTokenizer:(id<FLStringTokenizer>) tokenizer {
    [_tokenizers addObject:tokenizer];
}

- (void) removeTokenizer:(id<FLStringTokenizer>) tokenizer {
    [_tokenizers removeObject:tokenizer];
}

- (void) popTokenizer {
    if(_tokenizers.count) {
        [_tokenizers removeObjectAtIndex:_tokenizers.count - 1];
    }
}

@end
