//
//  FLWhitespace.h
//  FLCore
//
//  Created by Mike Fullerton on 5/25/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FishLampObjc.h"

@class FLPrettyString;

/// FLWhitespaceDefaultEOL is the default EOL "\n"

#define FLWhitespaceDefaultEOL          @"\n"

/// FLWhitespaceTabTab is defines a "tab style" behavior - e.g. it uses \\t not "    " for a tab.
#define FLWhitespaceTabTab              @"\t"

@interface FLWhitespace : NSObject {
@private
    NSString* _eolString;
}

@property (readonly, assign, nonatomic) NSInteger tabSize;

/// Set the eolString here, e.g. \\n or \\r\\n. See FLWhitespaceDefaultEOL
@property (readonly, strong, nonatomic) NSString* eolString;

/// Set the tabString. See FLWhitespaceFourSpacesTab or FLWhitespaceTabTab
@property (readonly, strong, nonatomic) NSString* tabString; 

- (id) initWithEOL:(NSString*) eol;

+ (id) whitespace:(NSString*) eol;

/// returns tabString for indent level. This is cached and built once for the life of the formatter.
- (NSString*) tabStringForScope:(NSUInteger) indent;

/// returns a formatter built with default EOL and default tab string.
+ (id) tabbedWithSpacesWhitespace;

/// returns a formatter that doesn't insert EOL or tabs (e.g. you're sending XML in a HTTP request)
+ (id) compressedWhitespace;

+ (id) untabbedWhitespace;

+ (id) defaultWhitespace;

@end

#define FLWhitespaceMaxIndent 128

@interface FLRepeatingCharTabWhitespace : FLWhitespace {
@private
    NSString* _cachedTabs[FLWhitespaceMaxIndent];
    NSString* _singleTab;
    NSInteger _tabSize;
}

- (id) initWithEOL:(NSString*) eol
           tabChar:(NSString*) tabChar
tabCharRepeatCount:(NSInteger) tabCharRepeatCount;

@end

@interface FLTabbedWithFourSpacesWhitespace : FLRepeatingCharTabWhitespace
@end
