//
//  NSObject+FLParseable.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 5/23/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLParseInfo.h"

#import <objc/runtime.h>

@implementation FLParseInfo

@synthesize hint = _hint;
@synthesize fileName = _fileName;
@synthesize line = _line;
@synthesize column = _column;

- (id) initWithHint:(NSString*) hint
    file:(NSString*) file
    line:(NSUInteger) line 
    column:(NSUInteger) column 
{
    self = [super init];
    if(self) {
        _line = line;
        _column = column;
        FLSetObjectWithRetain(_fileName, file);
        FLSetObjectWithRetain(_hint, hint);
    }
    
    return self;
}

#if FL_MRC
- (void) dealloc {
    FLRelease(_fileName);
    FLRelease(_hint);
    FLSuperDealloc();
}

#endif

+ (FLParseInfo*) parseInfo:(NSString*) hint file:(NSString*) fileName line:(NSUInteger) line column:(NSUInteger) column {
    return FLAutorelease([[FLParseInfo alloc] initWithHint:hint file:fileName line:line column:column]); 
}

- (NSString*) description {
    return [NSString stringWithFormat:@"Parsed in file: %@, at line: %ld, at column: %ld, hint: %@", _fileName == nil ? @"<unknown>" : _fileName, (long) _line, (long) _column, _hint ? _hint : @"<no hint>"];
}

@end

@implementation NSObject (FLParseInfo)
FLSynthesizeAssociatedProperty(FLAssociationPolicyRetainNonatomic, parseInfo, setParseInfo, FLParseInfo*);
@end
