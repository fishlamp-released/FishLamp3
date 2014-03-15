//
//  FLWhitespace.m
//  FLCore
//
//  Created by Mike Fullerton on 5/25/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLWhitespace.h"
#import "FishLampAssertions.h"

@interface FLWhitespace ()
@end

@implementation FLWhitespace

@synthesize eolString = _eolString;

- (id) initWithEOL:(NSString*) eol {
    self = [super init];
    if(self) {
        _eolString = FLRetain(eol == nil ? @"" : eol);
    }
    return self;
}

+ (id) whitespace:(NSString*) eol {
    return FLAutorelease([[[self class] alloc] initWithEOL:eol]);
}

+ (FLWhitespace*) whitespace {
    return FLAutorelease([[[self class] alloc] init]);
}

#if FL_MRC
- (void) dealloc {
    [_eolString release];
    [super dealloc];
}
#endif

- (NSString*) tabString {
    return @"";
}

- (NSInteger) tabSize {
    return 0;
}

+ (FLWhitespace*) tabbedWithSpacesWhitespace {
     FLReturnStaticObject(
        [[FLTabbedWithFourSpacesWhitespace alloc] initWithEOL:FLWhitespaceDefaultEOL];
     );
}

+ (FLWhitespace*) compressedWhitespace {
    return nil;
}

+ (id) untabbedWhitespace {
    FLReturnStaticObject(
        [[FLWhitespace alloc] initWithEOL:FLWhitespaceDefaultEOL];
    );
}

+ (FLWhitespace*) defaultWhitespace {
    return [self tabbedWithSpacesWhitespace];
}

- (NSString*) tabStringForScope:(NSUInteger) indent {
    return @"";
}


@end

@implementation FLRepeatingCharTabWhitespace

- (id) initWithEOL:(NSString*) eol
           tabChar:(NSString*) tabChar
tabCharRepeatCount:(NSInteger) tabCharRepeatCount {

    self = [super initWithEOL:eol];
    if(self) {
        NSMutableString* str = [[NSMutableString alloc] initWithString:tabChar];

        for(int i = 1; i < tabCharRepeatCount; i++) {
            [str appendString:tabChar];
        }

        _singleTab = str;

        memset(_cachedTabs, 0, sizeof(NSString*) * FLWhitespaceMaxIndent);
    }

    return self;
}

- (NSString*) tabString {
    return _singleTab;
}

- (NSInteger) tabSize {
    return _tabSize;
}

- (NSString*) expandTabToSize:(NSInteger) toSize {
    NSMutableString* outString = [NSMutableString string];

    for(int i = 0; i < toSize; i++) {
        [outString appendString:_singleTab];
    }

    return outString;
}

#if FL_MRC
- (void) dealloc {
    [_singleTab release];
    for(int i = 0; i < FLWhitespaceMaxIndent; i++) {
        if(_cachedTabs[i]) {
            FLRelease(_cachedTabs[i]);
        }
    }
    [super dealloc];
}
#endif

- (NSString*) tabStringForScope:(NSUInteger) indent {
    FLAssert(indent < FLWhitespaceMaxIndent, @"too many indents");
    
    if( indent > 0) {
        if(indent >= FLWhitespaceMaxIndent) {
            return [self expandTabToSize:indent];
        }
        else {
            if(!_cachedTabs[indent]) {
                _cachedTabs[indent] = FLRetain([self expandTabToSize:indent]);
            }

            return _cachedTabs[indent];
        }
    }
    
    return @"";
}


@end

@implementation FLTabbedWithFourSpacesWhitespace
- (id) initWithEOL:(NSString*) eol {
    return [super initWithEOL:eol tabChar:@" " tabCharRepeatCount:4];
}

@end
